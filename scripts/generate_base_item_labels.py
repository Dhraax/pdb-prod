#!/usr/bin/env python3
"""Regenerate the control panel's base-item label table from baseitems.2da.

The panel lets an administrator choose which base items an arcane group
admits. The database stores the numeric BASE_ITEM_* value and nothing else, so
without this table the form would ask somebody to remember that 361 is a
leather belt.

The panel runs in a container that does not have the repository, so the labels
are generated into a Python module rather than read at runtime. Re-run this
after changing baseitems.2da:

    python3 scripts/generate_base_item_labels.py

Usage with --check verifies the generated module is in step and writes nothing.
"""

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "haks-2da" / "baseitems.2da"
TARGET = ROOT / "cnr-editor" / "backend" / "app" / "base_item_labels.py"


def read_labels() -> dict[int, str]:
    """Return {row index: label} for every defined row of baseitems.2da."""
    lines = SOURCE.read_text(encoding="cp1252", errors="replace").splitlines()
    labels: dict[int, str] = {}
    for line in lines[3:]:
        fields = line.split()
        if len(fields) < 3 or not fields[0].isdigit():
            continue
        index, label = int(fields[0]), fields[2]
        if label in ("****", "DELETED"):
            continue
        labels[index] = label
    return labels


def render(labels: dict[int, str]) -> str:
    rows = "\n".join(f"    {index}: {label!r}," for index, label in sorted(labels.items()))
    return (
        '"""Base-item labels, generated from haks-2da/baseitems.2da.\n'
        "\n"
        "Do not edit by hand. Run scripts/generate_base_item_labels.py instead.\n"
        "\n"
        "The arcane group editor needs a name for each BASE_ITEM_* value it\n"
        "offers, and the panel's container has no copy of the 2DA.\n"
        '"""\n'
        "\n"
        "BASE_ITEM_LABELS: dict[int, str] = {\n"
        f"{rows}\n"
        "}\n"
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="verify without writing")
    args = parser.parse_args()

    if not SOURCE.is_file():
        print(f"missing source: {SOURCE}", file=sys.stderr)
        return 1

    rendered = render(read_labels())
    if args.check:
        current = TARGET.read_text(encoding="utf-8") if TARGET.is_file() else ""
        if current != rendered:
            print("base_item_labels.py is out of step with baseitems.2da", file=sys.stderr)
            return 1
        print("base_item_labels.py matches baseitems.2da")
        return 0

    TARGET.write_text(rendered, encoding="utf-8")
    print(f"wrote {TARGET.relative_to(ROOT)} with {rendered.count(':')} labels")
    return 0


if __name__ == "__main__":
    sys.exit(main())
