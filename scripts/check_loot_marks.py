#!/usr/bin/env python3
"""Refuse a tree where treasure equipment can leave the generators unmarked.

The essence extractor only breaks pieces that carry CNR_LOOT_TIER, and the
rule since 2026-09-28 is that the tier is the rank of the colour the piece was
named with: the call that marks it sits next to the naming, in the two
generators that colour loot. Twice before, a path was added or narrowed and
whole classes of loot - boss-chest pieces, quest rewards, plain chest pieces -
stopped reaching the extractor without anything failing. This check makes
that a build error instead.

Rules:
  1. In every pb_tesoro_* library, a function that creates an item names it
     with nombrarObjeto and marks it with CnrLoot_MarkGenerated.
  2. In pb_tesoros_inc, every function that starts a piece with
     IniciarObjetoCreado finishes it with FinalizarObjetoCreado, which marks
     both the enchanted and the plain branch. The other creators there make
     gold, scrolls, gems, junk, potions and miscellany, never equipment.
  3. Nothing outside cnr_i_loot calls CnrLoot_Mark directly, so no path can
     mark by a rule of its own.

The documented contract is documentation/oficios/cnr/loot-extraction.md.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
NSS = ROOT / "src" / "shared" / "nss"
SRC = ROOT / "src"

LIBRARIES = (
    "pb_tesoro_armor", "pb_tesoro_ccweap", "pb_tesoro_ccwea2", "pb_tesoro_diweap",
    "pb_tesoro_escudo", "pb_tesoro_magos", "pb_tesoro_miscel", "pb_tesoro_munici",
)
# Creators in pb_tesoros_inc that make no equipment.
NON_EQUIPMENT = {
    "CrearOro", "CrearPergamino", "CrearGemas", "CrearBasura", "CrearPocion",
    "CrearMiscelanea", "IniciarObjetoCreado",
}
FUNCTION = re.compile(r"^(?:void|int|object|string|float)\s+(\w+)\s*\([^;{]*\)\s*\{", re.M)


def functions(text: str) -> dict:
    """Split a script into top-level function bodies by brace depth."""
    bodies = {}
    for match in FUNCTION.finditer(text):
        depth = 0
        for index in range(match.end() - 1, len(text)):
            if text[index] == "{":
                depth += 1
            elif text[index] == "}":
                depth -= 1
                if depth == 0:
                    bodies[match.group(1)] = text[match.end():index]
                    break
    return bodies


def code(text: str) -> str:
    """Drop comments, so a mention in prose never satisfies a rule."""
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    return re.sub(r"//[^\n]*", "", text)


def read(path: Path) -> str:
    return code(path.read_bytes().decode("cp1252", errors="replace"))


def main() -> int:
    errors = []

    for name in LIBRARIES:
        path = NSS / f"{name}.nss"
        for function, body in functions(read(path)).items():
            if "CreateItemOnObject" not in body:
                continue
            for required in ("nombrarObjeto(", "CnrLoot_MarkGenerated("):
                if required not in body:
                    errors.append(f"{name}.nss: {function} creates an item without {required[:-1]}")

    inc = functions(read(NSS / "pb_tesoros_inc.nss"))
    finalize = inc.get("FinalizarObjetoCreado", "")
    if finalize.count("CnrLoot_MarkGenerated(") < 2:
        errors.append("pb_tesoros_inc.nss: FinalizarObjetoCreado must mark both "
                      "the enchanted and the plain branch")
    for function, body in inc.items():
        if "IniciarObjetoCreado(" in body and function != "IniciarObjetoCreado":
            if "FinalizarObjetoCreado(" not in body:
                errors.append(f"pb_tesoros_inc.nss: {function} starts a piece "
                              "without FinalizarObjetoCreado")
        elif "CreateItemOnObject" in body and function not in NON_EQUIPMENT:
            errors.append(f"pb_tesoros_inc.nss: {function} creates an item outside "
                          "IniciarObjetoCreado/FinalizarObjetoCreado; mark it or list "
                          "it as non-equipment in scripts/check_loot_marks.py")

    for path in sorted(SRC.rglob("*.nss")):
        if path.name == "cnr_i_loot.nss":
            continue
        if re.search(r"\bCnrLoot_Mark\s*\(", read(path)):
            errors.append(f"{path.relative_to(ROOT)}: calls CnrLoot_Mark directly; "
                          "use CnrLoot_MarkGenerated")

    if errors:
        print("Loot marking check FAILED:")
        for error in errors:
            print("  - " + error)
        return 1
    print("Loot marking check passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
