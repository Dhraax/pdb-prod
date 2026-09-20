#!/usr/bin/env python3
"""Check the PDB documentation graph and its source-policy invariants.

The owner keeps a small set of publication and working files in the
documentation root. They are explicit exceptions, not canonical documents.

This is the production copy. It is deliberately the same program as the
development one, rule for rule, so that a document written in either checkout
passes or fails identically and neither repository drifts into a weaker
contract than the other. Change one and change the other in the same slice;
the two exception sets below are the only part that is allowed to differ, and
today they do not.

Usage:  python3 scripts/check_documentation.py

Exit 0 when every invariant holds, 1 otherwise.
"""

import re
import sys
from pathlib import Path
from urllib.parse import unquote


REPO = Path(__file__).resolve().parent.parent
DOCS = REPO / "documentation"

ROOT_EXCEPTIONS = {
    "README.md",
    "Oficios Basicos - Etapa 1 - 2026 - Testers.xlsx",
    "artifice.md",
    "forum-post-format.md",
    "forum-post-hechizos.md",
    "forum-post-oficios.md",
    "pruebas-hechizos.md",
}

PRESCRIPTIVE_SOURCE_FILES = {
    DOCS / "README.md",
    DOCS / "nwscript" / "style-guide.md",
    DOCS / "nwscript" / "script-template.md",
}

LINK = re.compile(r"(?<!!)\[[^\]]*\]\(([^)]+)\)")
MONTH = re.compile(r"\d{4}-\d{2}\.md")


def read(path):
    return path.read_text(encoding="utf-8-sig", errors="replace")


def local_target(source, raw_target):
    target = raw_target.strip().strip("<>")
    target = unquote(target.split("#", 1)[0].strip())
    if not target or "://" in target or target.startswith(("mailto:", "#")):
        return None
    path = (source.parent / target).resolve()
    if path.is_dir():
        path = path / "README.md"
    return path


def main():
    failures = []
    markdown = sorted(DOCS.rglob("*.md"))
    readmes = [path for path in markdown if path.name == "README.md"]
    inbound_from_readme = {path.resolve(): [] for path in markdown}

    for path in sorted(DOCS.iterdir()):
        if path.is_file() and path.name not in ROOT_EXCEPTIONS:
            failures.append(
                "documentation root file is neither canonical nor an approved "
                f"owner exception: {path.relative_to(REPO)}"
            )

    root_index = read(DOCS / "README.md")
    for directory in sorted(path for path in DOCS.iterdir() if path.is_dir()):
        index = directory / "README.md"
        if not index.is_file():
            failures.append(
                f"documentation module has no README: {directory.relative_to(REPO)}"
            )
            continue
        relative = directory.relative_to(DOCS).as_posix()
        if (
            f"({relative}/README.md)" not in root_index
            and f"({relative}/)" not in root_index
        ):
            failures.append(
                f"documentation module is absent from the root index: {relative}/"
            )

    for source in markdown:
        for raw_target in LINK.findall(read(source)):
            target = local_target(source, raw_target)
            if target is None:
                continue
            if not target.exists():
                failures.append(
                    f"broken local link: {source.relative_to(REPO)} -> {raw_target}"
                )
                continue
            if source.name == "README.md" and target in inbound_from_readme:
                inbound_from_readme[target].append(source)

    for path in markdown:
        if path.parent == DOCS:
            continue
        if path.name == "README.md":
            if path != DOCS / "README.md" and not inbound_from_readme[path.resolve()]:
                failures.append(
                    f"README is not indexed by another README: {path.relative_to(REPO)}"
                )
            continue
        if MONTH.fullmatch(path.name) and path.parent.parent.name == "changelog":
            continue
        if not inbound_from_readme[path.resolve()]:
            failures.append(
                f"document is absent from every README index: {path.relative_to(REPO)}"
            )

    for path in PRESCRIPTIVE_SOURCE_FILES:
        if "nwnlexicon.com" in read(path).lower():
            failures.append(
                "prescriptive document still directs agents to NWN Lexicon: "
                f"{path.relative_to(REPO)}"
            )

    if failures:
        print("Documentation check failed:")
        for failure in failures:
            print("  " + failure)
        return 1

    print(
        f"Documentation check passed: {len(markdown)} Markdown files, "
        f"{len(readmes)} README indexes."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
