#!/usr/bin/env python3
"""Freeze the legacy CNR station scripts as authored JSON.

Phase 1c of documentation/oficios/cnr/catalogue-authoring-plan.md.

Reads the seven `.nss` station files and writes one JSON file per station under
migration/catalogue/. The extraction is lossless by design: every field any
`CnrRecipe*` setter writes is recorded, including the ones the current SQL
generator ignores (XP, ability percentages, biproducts). Nothing is derived,
renamed or reordered here — that stays the generator's job.

Run once. After that the JSON is the source and the `.nss` files are dead.

Usage:  python3 migration/extract_catalogue_json.py
"""

from __future__ import annotations

import json
import re
import sys
from collections import OrderedDict
from pathlib import Path
from typing import Any, Dict, List, Optional, Tuple

ROOT = Path(__file__).resolve().parent.parent
NSS = ROOT / "src" / "cnr" / "nss"
OUT = ROOT / "migration" / "catalogue"

# `.nss` sources are Windows-1252, never UTF-8.
ENCODING = "cp1252"

STATIONS = (
    "cnralchemytable",
    "cnranvilsmith",
    "cnrcuringtub",
    "cnrforgepublic",
    "cnrhebcauldron",
    "cnrjewelersbench",
    "cnrtailorstable",
)

# Counted from the sources; the extraction must reproduce these exactly.
EXPECTED = {
    "cnralchemytable": dict(recipes=65, components=192, submenus=1, levels=0,
                            biproducts=0, abilities=0, precraft=0),
    "cnranvilsmith": dict(recipes=112, components=224, submenus=7, levels=112,
                          biproducts=0, abilities=0, precraft=112),
    "cnrcuringtub": dict(recipes=10, components=30, submenus=3, levels=10,
                         biproducts=0, abilities=0, precraft=0),
    "cnrforgepublic": dict(recipes=14, components=14, submenus=0, levels=14,
                           biproducts=0, abilities=0, precraft=0),
    "cnrhebcauldron": dict(recipes=8, components=8, submenus=1, levels=0,
                           biproducts=0, abilities=8, precraft=0),
    "cnrjewelersbench": dict(recipes=88, components=176, submenus=2, levels=88,
                             biproducts=0, abilities=0, precraft=60),
    "cnrtailorstable": dict(recipes=97, components=144, submenus=9, levels=97,
                            biproducts=7, abilities=0, precraft=0),
}

# --------------------------------------------------------------------------
# One pattern per setter. Anchored on the call so commented-out lines, which
# are dropped before matching, cannot leak in.

RE_SUBMENU = re.compile(
    r'(?:string\s+)?(\w+)\s*=\s*CnrRecipeAddSubMenu\(\s*'
    r'(?:"([^"]*)"|(\w+))\s*,\s*"([^"]*)"\s*\)'
)
RE_RECIPE = re.compile(
    r'(\w+)\s*=\s*CnrRecipeCreateRecipe\(\s*(?:"([^"]*)"|(\w+))\s*,\s*'
    r'"([^"]*)"\s*,\s*"([^"]*)"\s*,\s*(-?\d+)\s*\)'
)
RE_COMPONENT = re.compile(
    r'CnrRecipeAddComponent\(\s*(\w+)\s*,\s*"([^"]*)"\s*,\s*(-?\d+)\s*'
    r'(?:,\s*(-?\d+)\s*)?\)'
)
RE_LEVEL = re.compile(r'CnrRecipeSetRecipeLevel\(\s*(\w+)\s*,\s*(-?\d+)\s*\)')
RE_XP = re.compile(
    r'CnrRecipeSetRecipeXP\(\s*(\w+)\s*,\s*(-?\d+)\s*,\s*(-?\d+)\s*'
    r'(?:,\s*(\w+)\s*)?\)'
)
RE_ABILITY = re.compile(
    r'CnrRecipeSetRecipeAbilityPercentages\(\s*(\w+)\s*'
    + r',\s*(-?\d+)\s*' * 6 + r'\)'
)
RE_BIPRODUCT = re.compile(
    r'CnrRecipeSetRecipeBiproduct\(\s*(\w+)\s*,\s*"([^"]*)"\s*,\s*'
    r'(-?\d+)\s*,\s*(-?\d+)\s*\)'
)
RE_PRE_CRAFT = re.compile(
    r'CnrRecipeSetRecipePreCraftingScript\(\s*(\w+)\s*,\s*"([^"]*)"\s*\)'
)
RE_DEV_PRE_CRAFT = re.compile(
    r'CnrRecipeSetDevicePreCraftingScript\(\s*"([^"]*)"\s*,\s*"([^"]*)"\s*\)'
)
RE_DEV_TRADESKILL = re.compile(
    r'CnrRecipeSetDeviceTradeskillType\(\s*"([^"]*)"\s*,\s*([\w.]+)\s*\)'
)
RE_DEV_TOOL = re.compile(
    r'CnrRecipeSetDevice(Equipped|Inventory)Tool\(\s*"([^"]*)"\s*,\s*'
    r'"([^"]*)"\s*(?:,\s*([\w.]+)\s*)?\)'
)


def strip_comment(line: str) -> str:
    """Drop a trailing // comment, ignoring // that sits inside a string."""
    out = []
    in_str = False
    i = 0
    while i < len(line):
        ch = line[i]
        if in_str:
            if ch == "\\":
                out.append(ch)
                i += 1
                if i < len(line):
                    out.append(line[i])
                    i += 1
                continue
            if ch == '"':
                in_str = False
        else:
            if ch == '"':
                in_str = True
            elif ch == "/" and i + 1 < len(line) and line[i + 1] == "/":
                break
        out.append(ch)
        i += 1
    return "".join(out)


class Recipe:
    def __init__(self, var: str, submenu: Optional[str], name: str,
                 tag: str, qty: int, order: int) -> None:
        self.var = var
        self.submenu = submenu
        self.name = name
        self.tag = tag
        self.qty = qty
        self.order = order
        self.components: List[Dict[str, Any]] = []
        self.level: Optional[int] = None
        self.xp: Optional[Dict[str, Any]] = None
        self.abilities: Optional[Dict[str, int]] = None
        self.biproduct: Optional[Dict[str, Any]] = None
        self.pre_craft: Optional[str] = None

    def to_json(self) -> "OrderedDict[str, Any]":
        d: "OrderedDict[str, Any]" = OrderedDict()
        d["sort_order"] = self.order
        d["submenu"] = self.submenu
        d["display_name"] = self.name
        d["output_tag"] = self.tag
        d["output_qty"] = self.qty
        d["components"] = self.components
        d["level"] = self.level
        d["xp"] = self.xp
        d["abilities"] = self.abilities
        d["biproduct"] = self.biproduct
        d["pre_crafting_script"] = self.pre_craft
        return d


def extract(station: str) -> "OrderedDict[str, Any]":
    text = (NSS / f"{station}.nss").read_text(encoding=ENCODING)

    device: "OrderedDict[str, Any]" = OrderedDict()
    device["source_file"] = f"{station}.nss"
    device["tag"] = None
    device["tradeskill_type"] = None
    device["pre_crafting_script"] = None
    device["tools"] = []

    submenus: "OrderedDict[str, str]" = OrderedDict()   # variable -> title
    submenu_rows: List["OrderedDict[str, Any]"] = []
    recipes: List[Recipe] = []
    by_var: Dict[str, Recipe] = {}
    order = 0

    for raw in text.split("\n"):
        line = strip_comment(raw)
        if "Cnr" not in line:
            continue

        m = RE_DEV_PRE_CRAFT.search(line)
        if m:
            device["tag"] = device["tag"] or m.group(1)
            device["pre_crafting_script"] = m.group(2)
            continue

        m = RE_DEV_TRADESKILL.search(line)
        if m:
            device["tag"] = device["tag"] or m.group(1)
            device["tradeskill_type"] = m.group(2)
            continue

        m = RE_DEV_TOOL.search(line)
        if m:
            device["tag"] = device["tag"] or m.group(2)
            tool: "OrderedDict[str, Any]" = OrderedDict()
            tool["tag"] = m.group(3)
            tool["access_mode"] = m.group(1).lower()
            tool["breakage"] = m.group(4)
            device["tools"].append(tool)
            continue

        m = RE_SUBMENU.search(line)
        if m:
            var, parent_lit, parent_var, title = m.groups()
            submenus[var] = title
            row: "OrderedDict[str, Any]" = OrderedDict()
            row["name"] = title
            # A submenu hangs off the device tag or off another submenu.
            row["parent"] = submenus.get(parent_var) if parent_var else None
            submenu_rows.append(row)
            if parent_lit and not device["tag"]:
                device["tag"] = parent_lit
            continue

        m = RE_RECIPE.search(line)
        if m:
            var, dev_lit, menu_var, name, tag, qty = m.groups()
            if dev_lit and not device["tag"]:
                device["tag"] = dev_lit
            submenu = submenus.get(menu_var) if menu_var else None
            order += 1
            rec = Recipe(var, submenu, name, tag, int(qty), order)
            recipes.append(rec)
            by_var[var] = rec
            continue

        m = RE_COMPONENT.search(line)
        if m:
            rec = by_var.get(m.group(1))
            if rec is None:
                raise SystemExit(f"{station}: component before any recipe: {line!r}")
            comp: "OrderedDict[str, Any]" = OrderedDict()
            comp["tag"] = m.group(2)
            comp["qty"] = int(m.group(3))
            comp["retain_on_fail"] = int(m.group(4)) if m.group(4) else 0
            rec.components.append(comp)
            continue

        m = RE_LEVEL.search(line)
        if m:
            by_var[m.group(1)].level = int(m.group(2))
            continue

        m = RE_XP.search(line)
        if m:
            xp: "OrderedDict[str, Any]" = OrderedDict()
            xp["game"] = int(m.group(2))
            xp["trade"] = int(m.group(3))
            xp["scalar_override"] = m.group(4)
            by_var[m.group(1)].xp = xp
            continue

        m = RE_ABILITY.search(line)
        if m:
            names = ("str", "dex", "con", "int", "wis", "cha")
            vals = [int(v) for v in m.groups()[1:]]
            by_var[m.group(1)].abilities = OrderedDict(zip(names, vals))
            continue

        m = RE_BIPRODUCT.search(line)
        if m:
            bip: "OrderedDict[str, Any]" = OrderedDict()
            bip["tag"] = m.group(2)
            bip["qty"] = int(m.group(3))
            bip["on_fail_qty"] = int(m.group(4))
            by_var[m.group(1)].biproduct = bip
            continue

        m = RE_PRE_CRAFT.search(line)
        if m:
            by_var[m.group(1)].pre_craft = m.group(2)
            continue

    doc: "OrderedDict[str, Any]" = OrderedDict()
    doc["_generated_by"] = "migration/extract_catalogue_json.py"
    doc["_source"] = f"src/cnr/nss/{station}.nss"
    doc["device"] = device
    doc["submenus"] = submenu_rows
    doc["recipes"] = [r.to_json() for r in recipes]
    return doc


def verify(station: str, doc: Dict[str, Any]) -> List[str]:
    exp = EXPECTED[station]
    recipes = doc["recipes"]
    got = dict(
        recipes=len(recipes),
        components=sum(len(r["components"]) for r in recipes),
        submenus=len(doc["submenus"]),
        levels=sum(1 for r in recipes if r["level"] is not None),
        biproducts=sum(1 for r in recipes if r["biproduct"] is not None),
        abilities=sum(1 for r in recipes
                      if r["abilities"] and any(r["abilities"].values())),
        precraft=sum(1 for r in recipes if r["pre_crafting_script"]),
    )
    errs = [f"{station}: {k} expected {v}, got {got[k]}"
            for k, v in exp.items() if got[k] != v]
    missing_xp = [r["display_name"] for r in recipes if r["xp"] is None]
    if missing_xp:
        errs.append(f"{station}: {len(missing_xp)} recipes without XP, "
                    f"first {missing_xp[0]!r}")
    no_menu = [r["display_name"] for r in recipes if r["submenu"] is None]
    if no_menu and exp["submenus"]:
        errs.append(f"{station}: {len(no_menu)} recipes outside every submenu, "
                    f"first {no_menu[0]!r}")
    return errs


def main() -> int:
    # Extract and verify everything before touching the filesystem. A partial
    # or drifted extraction must never overwrite the authored source, so the
    # write phase only starts once every station has passed.
    documents: List[Tuple[str, Dict[str, Any]]] = []
    problems: List[str] = []

    for station in STATIONS:
        doc = extract(station)
        problems.extend(verify(station, doc))
        documents.append((station, doc))

    if not any(doc["recipes"] for _, doc in documents):
        print("The station .nss files are empty - this script has already done "
              "its job.\nThe authored source is migration/catalogue/*.json; "
              "edit that, not the .nss.\nSee "
              "documentation/oficios/cnr/catalogue-authoring-plan.md phase 4.",
              file=sys.stderr)
        return 1

    if problems:
        print("EXTRACTION IS NOT LOSSLESS - nothing written:", file=sys.stderr)
        for problem in problems:
            print(f"  {problem}", file=sys.stderr)
        return 1

    OUT.mkdir(parents=True, exist_ok=True)
    totals = {"recipes": 0, "components": 0, "submenus": 0, "biproducts": 0}

    for station, doc in documents:
        path = OUT / f"{station}.json"
        with path.open("w", encoding="utf-8", newline="\n") as handle:
            json.dump(doc, handle, indent=2, ensure_ascii=False)
            handle.write("\n")

        totals["recipes"] += len(doc["recipes"])
        totals["components"] += sum(len(r["components"]) for r in doc["recipes"])
        totals["submenus"] += len(doc["submenus"])
        totals["biproducts"] += sum(1 for r in doc["recipes"] if r["biproduct"])
        print(f"  {station:<20} {len(doc['recipes']):>3} recipes -> "
              f"{path.relative_to(ROOT)}")

    print(f"\ntotals: {totals['recipes']} recipes, "
          f"{totals['components']} component entries, "
          f"{totals['submenus']} submenus, "
          f"{totals['biproducts']} biproducts")
    print("all per-station counts match the source")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
