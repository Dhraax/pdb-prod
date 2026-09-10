#!/usr/bin/env python3
"""Generate the arcane enchanting tables from the reviewed design.

Reads documentation/oficios/arcano.json - the authored design, one row per
property - and writes migration/05_arcane.sql.

Arcane has no recipes. The player builds the request at the NUI and the applier
revalidates it, so what these tables carry is not a menu but the rules: which
items a property may touch, how many essences buy which value, and what each
step is worth.

Run with no arguments. Use --check to validate without writing.
"""

from __future__ import annotations

import argparse
import csv
import json
import re
import sys
from pathlib import Path
from typing import Dict, List, Tuple

ROOT = Path(__file__).resolve().parents[1]
DESIGN = ROOT / "documentation" / "oficios" / "arcano.json"
OUTPUT = ROOT / "migration" / "05_arcane.sql"
CATALOGUE = ROOT / "migration" / "03_catalogue.sql"
BASEITEMS = ROOT / "haks-2da" / "baseitems.2da"
UTI_DIRS = (ROOT / "src" / "cnr" / "uti", ROOT / "src" / "shared" / "uti")

# --------------------------------------------------------------------------
# Base item groups.
#
# The weapon groups are not written down. They are read, every build, from the
# two facts that decide them.
#
# The first is that the arcane table only ever sees what a trade forged:
# CnrArc_IsEnchantable demands the CNR_OFICIO mark, and cnr_i_craft is the only
# thing that stamps it. A weapon nobody crafts can never reach the table, so
# listing it is noise; a weapon the smith does craft and the list forgets is a
# player writing a bug report. The hand-written list was NWN vanilla, stopped
# at row 111, and forgot eighteen weapons the trades make - the nunchaku, the
# sai, the katar, the falchion, the picks, the mauls, the three huge weapons,
# the longspear. Reported 2026-08-27.
#
# The second is baseitems.2da's PropColumn, which is the column the engine
# itself uses to decide whether an item may carry a property at all. Grouping by
# it means the menu can no longer offer what AddItemProperty will silently
# refuse - which is how ten on-hit properties came to be offered on bows, where
# itemprops.2da row 48 says "****" for 1_Ranged. Same report.
#
# Deriving from both gives a closed set with nothing to maintain: a new weapon
# in the smith is enchantable the day it ships, and nothing else ever is.
#
# One consequence worth stating: the sling leaves the ranged group. No trade
# makes one, so no sling could ever have carried the mark, and nothing that used
# to be enchantable stops being so.
#
# WEARABLE stays written by hand on purpose. It is a design decision - the
# design's "equipo" column - and not a mechanical class: PropColumn 3 is
# "staves" and holds the magic staff along with the bunch of flowers and the
# fashion accessory. The trades also make fifty wearables the design does not
# name - boots, gloves, bracers, cloaks, the leather belt - and whether those
# become enchantable is a decision, not a derivation.
# --------------------------------------------------------------------------

# PropColumn -> what that column is, for the four the weapon groups care about.
PROP_COLUMN_MELEE = 0
PROP_COLUMN_LAUNCHER = 1
PROP_COLUMN_THROWN = 2
PROP_COLUMN_AMMO = 5


def read_2da(path: Path) -> Tuple[List[str], Dict[int, Dict[str, str]]]:
    lines = path.read_text(encoding="cp1252", errors="replace").splitlines()
    header = lines[2].split()
    table: Dict[int, Dict[str, str]] = {}
    for line in lines[3:]:
        cells = line.split()
        if cells and cells[0].isdigit() and len(cells) >= len(header):
            table[int(cells[0])] = dict(zip(header, cells[1:1 + len(header)]))
    return header, table


def blueprint_base_items() -> Dict[str, int]:
    """resref -> BaseItem, for every blueprint a recipe can name."""
    out: Dict[str, int] = {}
    for directory in UTI_DIRS:
        for path in sorted(directory.glob("*.uti.json")):
            data = None
            for encoding in ("utf-8", "cp1252"):
                try:
                    data = json.loads(path.read_text(encoding=encoding))
                    break
                except (UnicodeDecodeError, json.JSONDecodeError):
                    continue
            if data is None:
                continue
            base = data.get("BaseItem")
            if isinstance(base, dict):
                out[path.name.split(".")[0].lower()] = int(base["value"])
    return out


def crafted_base_items() -> Dict[int, int]:
    """BaseItem -> how many products the trades make of it.

    Read from the generated catalogue rather than from the station JSON: the
    blueprint a recipe ends up creating is resolved by build_catalogue, through
    literal resrefs, variant groups and the alchemy potion bases, and the SQL is
    where that answer lives. Run build_catalogue.py first when recipes change.
    """
    if not CATALOGUE.exists():
        fail(f"{CATALOGUE.relative_to(ROOT)} is missing; run build_catalogue.py first")
    text = CATALOGUE.read_text(encoding="utf-8")
    by_resref = blueprint_base_items()
    counts: Dict[int, int] = {}

    def harvest(table: str) -> None:
        header = re.search(rf"INSERT INTO {table} \((.*?)\) VALUES", text)
        if not header:
            return
        columns = header.group(1).split(",")
        for body in re.findall(rf"INSERT INTO {table} \(.*?\) VALUES \((.*?)\);", text):
            row = dict(zip(columns, next(csv.reader([body], quotechar="'",
                                                    skipinitialspace=True))))
            base = by_resref.get(row["base_resref"].strip().lower())
            if base is not None:
                counts[base] = counts.get(base, 0) + 1

    harvest("cnr_recipe")
    harvest("cnr_variant")
    if not counts:
        fail("no crafted base items found in the catalogue")
    return counts


def weapon_groups() -> Tuple[List[int], List[int], List[int], List[int]]:
    """The four weapon classes, as the trades and the engine jointly define."""
    _, base_items = read_2da(BASEITEMS)
    crafted = crafted_base_items()
    buckets: Dict[int, List[int]] = {PROP_COLUMN_MELEE: [], PROP_COLUMN_LAUNCHER: [],
                                     PROP_COLUMN_THROWN: [], PROP_COLUMN_AMMO: []}
    for base in sorted(crafted):
        row = base_items.get(base)
        if row is None:
            continue
        column = row.get("PropColumn")
        if column in (None, "****"):
            continue
        bucket = buckets.get(int(column))
        if bucket is not None:
            bucket.append(base)
    for column, bucket in buckets.items():
        if not bucket:
            fail(f"no crafted base item lands in PropColumn {column}")
    return (buckets[PROP_COLUMN_MELEE], buckets[PROP_COLUMN_LAUNCHER],
            buckets[PROP_COLUMN_THROWN], buckets[PROP_COLUMN_AMMO])


MELEE, LAUNCHER, THROWN, AMMO = weapon_groups()
# What the design calls "a distancia" is the launcher plus the thrown weapon:
# Mighty is the only property that uses it, and itemprops.2da allows it on both
# and on neither melee nor ammunition.
RANGED = LAUNCHER + THROWN
WEARABLE = [
    16,   # ARMOR
    14,   # SMALLSHIELD
    56,   # LARGESHIELD
    57,   # TOWERSHIELD
    17,   # HELMET
    50,   # QUARTERSTAFF   - carpentry's staff is a melee weapon
    45,   # MAGICSTAFF     - cnr_bastonroble, the caster staff
    514,  # SORCERERDAGGER - item_dagahechi, so a caster is not tied to a staff
    19,   # AMULET
    52,   # RING
]

# Design label -> (code, display name, base items, any_base)
GROUPS: List[Tuple[str, str, str, List[int], bool]] = [
    # The design used to say "baston" once and mean three different rows: the
    # carpenter's quarterstaff, the caster's magic staff and, from 2026-08-27,
    # the sorcerer's dagger. It now names each of them, so the label and the
    # list below cannot drift apart again.
    ("Armadura, escudo, yelmo, baston, baston de mago, daga de mago, colgante, anillo",
     "equipo", "Armadura, escudo, yelmo, bastón, bastón de mago, daga de mago, "
     "colgante o anillo", WEARABLE, False),
    ("Arma cuerpo a cuerpo y a distancia",
     "arma_cc_dist", "Arma cuerpo a cuerpo o a distancia", MELEE + RANGED, False),
    # On-hit is the engine's, not ours: itemprops.2da row 48 allows it on melee,
    # on thrown weapons and on ammunition, and refuses it on every launcher. An
    # arrow enchanted here is what an archer actually wants - a bow never
    # delivers the hit, the ammunition does.
    ("Armas cuerpo a cuerpo, arrojadizas y municion",
     "arma_golpe", "Arma cuerpo a cuerpo, arrojadiza o municion",
     MELEE + THROWN + AMMO, False),
    ("Colgante, anillo",
     "colgante_anillo", "Colgante o anillo", [19, 52], False),
    ("Armas cuerpo a cuerpo",
     "arma_cc", "Arma cuerpo a cuerpo", MELEE, False),
    ("Armas a distancia",
     "arma_dist", "Arma a distancia", RANGED, False),
    ("Todos los objetos",
     "cualquiera", "Cualquier objeto", [], True),
    # Massive criticals and Keen are refused on ammunition, so neither group
    # reaches it. Both are legal on a launcher.
    ("Armas cuerpo a cuerpo y a distancia (estoques, kukris y cimitarras 2 cristales)",
     "arma_toda_x2",
     "Arma cuerpo a cuerpo o a distancia (estoque, kukri y cimitarra cuestan 2 cristales)",
     MELEE + RANGED, False),
]
# Rapier, kukri, scimitar cost two crystals in the massive-criticals group.
DOUBLE_CRYSTAL = {"arma_toda_x2": [51, 42, 53]}

CRYSTALS = {
    "Nishruu": "cnr_cristal1",
    "Fénix": "cnr_cristal2",
    "Hada": "cnr_cristal3",
    "Dragón": "cnr_cristal4",
    "Contemplador": "cnr_cristal5",
    "Sombra": "cnr_cristal6",
}

# Immunity is an index into iprp_immuncost.2da, not a percentage: 5% is 1,
# 10% is 2, and 15% and 20% are PDB's own rows 9 and 8.
IMMUNITY_INDEX = {5: 1, 10: 2, 15: 9, 20: 8}

# NWN has no 1d2 or 1d3 damage bonus, so the ladder skips what does not exist.
# (essences, value1, value2, label); value2 is the DamageBonus die shorthand.
DAMAGE_LADDER = [
    (1, 1, 0, "+1"),
    (2, 2, 0, "+2"),
    (4, 0, 4, "1d4"),
    (6, 0, 6, "1d6"),
    (8, 0, 8, "1d8"),
]


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def load_design() -> List[dict]:
    if not DESIGN.exists():
        fail(f"{DESIGN} is missing")
    rows = json.loads(DESIGN.read_text(encoding="utf-8"))
    if not isinstance(rows, list) or not rows:
        fail("the design must be a non-empty list")
    return rows


def number(value: object, default: int = 0) -> int:
    """Read the design's `maximo`, which is '7', 'CD 16', '1d8' or ''."""
    text = str(value or "")
    digits = "".join(c for c in text if c.isdigit())
    return int(digits) if digits else default


def steps_for(row: dict) -> List[tuple]:
    """Every amount that can be bought.

    Each step is (essences, value1, value2, label) and may carry a fifth
    element, a subtype that overrides the property's own.
    """
    section = row["seccion"]
    product = row["producto"]
    top = number(row.get("maximo"))

    if section in ("HABILIDADES", "CARACTERÍSTICAS", "SALVACIONES"):
        return [(n, n, 0, f"+{n}") for n in range(1, max(1, top) + 1)]

    if section == "INMUNIDAD AL DAÑO":
        return [(n, IMMUNITY_INDEX[n * 5], 0, f"{n * 5}%") for n in range(1, 5)]

    if section == "DAÑO (ARMAS)":
        return list(DAMAGE_LADDER)

    if section == "EFECTO AL GOLPEAR":
        # Fixed: three essences, CD 16, which is IP_CONST_ONHIT_SAVEDC index 1.
        return [(3, 1, 0, "CD 16")]

    if section == "HUECOS DE CONJURO":
        # Every spell level is a separate step. Full casters pay one essence
        # per level. Truncated progressions pay two through four for levels
        # one through three, preserving the reviewed four-essence top cost.
        cost_offset = 0 if top >= 6 else 1
        return [(level + cost_offset, level, 1,
                 f"1 hueco de esfera {level}")
                for level in range(1, max(1, top) + 1)]

    if section == "OTROS":
        if product == "Afiladura":
            return [(3, 0, 0, "Sí")]
        if product == "Críticos masivos":
            return list(DAMAGE_LADDER)
        if product == "Luz":
            # value1 is the brightness step, value2 the colour, white.
            return [(n, n, 6, f"Brillo {n}") for n in range(1, max(1, top) + 1)]
        if product.startswith("Reduccion de daño"):
            # "5/+1,+2,+3": the soak never moves, the enhancement needed to
            # pierce it does. value1 is 1, which is Soak5 in iprp_soakcost.2da
            # - row 0 there is Random, not 5 - and the step overrides subtype
            # with IP_CONST_DAMAGEREDUCTION_*, where +1 is 0.
            return [(n, 1, 0, f"5/+{n}", n - 1) for n in range(1, max(1, top) + 1)]
        return [(n, n, 0, f"+{n}") for n in range(1, max(1, top) + 1)]

    fail(f"no ladder defined for section {section!r}")
    return []


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="validate, write nothing")
    args = parser.parse_args()

    design = load_design()
    group_ids: Dict[str, int] = {}
    lines: List[str] = []

    lines.append("-- Generated by migration/build_arcane.py. Do not edit by hand.")
    lines.append("-- Source: documentation/oficios/arcano.json")
    lines.append("")
    lines.append("DELETE FROM cnr_arcane_step;")
    lines.append("DELETE FROM cnr_arcane_property;")
    lines.append("DELETE FROM cnr_arcane_group_base;")
    lines.append("DELETE FROM cnr_arcane_group;")
    lines.append("")

    for index, (label, code, display, bases, any_base) in enumerate(GROUPS, start=1):
        group_ids[label] = index
        lines.append(
            f"INSERT INTO cnr_arcane_group (group_id,code,display_name,any_base)"
            f" VALUES ({index},'{code}','{display}',{1 if any_base else 0});"
        )
        doubles = set(DOUBLE_CRYSTAL.get(code, []))
        for base in sorted(set(bases)):
            cost = 2 if base in doubles else 1
            lines.append(
                f"INSERT INTO cnr_arcane_group_base (group_id,base_item,crystal_cost)"
                f" VALUES ({index},{base},{cost});"
            )
    lines.append("")

    unknown_groups = set()
    total_steps = 0
    for arcane_id, row in enumerate(design, start=1):
        label = ", ".join(row.get("equipo") or [])
        group_id = group_ids.get(label)
        if group_id is None:
            unknown_groups.add(label)
            continue

        essence = row.get("material_resref")
        if not essence:
            fail(f"row {arcane_id} ({row['producto']!r}) has no material_resref")
        crystal = CRYSTALS.get(row.get("cristal", ""))
        if crystal is None:
            fail(f"row {arcane_id} names an unknown crystal {row.get('cristal')!r}")

        props = row.get("propiedades") or []
        prop_type = props[0]["type"] if props else ""
        subtype = props[0].get("subtype") or 0 if props else 0
        supported = 1 if row.get("soportado") and prop_type else 0
        note = (row.get("nota") or "").replace("'", "''")[:255]
        name = row["producto"].replace("'", "''")

        essence_name = (row.get("material") or "").replace("'", "''")[:96]
        crystal_name = "Cristal urdímbrico de " + row.get("cristal", "")
        crystal_name = crystal_name.replace("'", "''")[:96]
        ubicacion = (row.get("ubicacion") or "").split(" y ")[0].replace("'", "''")[:96]
        lines.append(
            "INSERT INTO cnr_arcane_property (arcane_id,section,display_name,group_id,"
            "tier,essence_resref,essence_name,crystal_resref,crystal_name,ubicacion,"
            "property_type,subtype,min_level,dc,"
            f"supported,note) VALUES ({arcane_id},'{row['seccion']}','{name}',{group_id},"
            f"{row['tier']},'{essence}','{essence_name}','{crystal}','{crystal_name}',"
            f"'{ubicacion}','{prop_type}',{subtype},"
            f"{row['min_level']},{row['dc']},{supported},"
            + (f"'{note}'" if note else "NULL")
            + ");"
        )

        ladder = steps_for(row)
        most = max(step[0] for step in ladder)
        for step in ladder:
            essences, value1, value2, display_value = step[:4]
            step_subtype = step[4] if len(step) > 4 else None
            # Experience follows what was spent, so a one-essence enchant is
            # not a cheap way up.
            xp = max(1, round(row["xp"] * essences / most))
            lines.append(
                "INSERT INTO cnr_arcane_step (arcane_id,essences,subtype,value1,"
                f"value2,xp,display_value) VALUES ({arcane_id},{essences},"
                + ("NULL" if step_subtype is None else str(step_subtype))
                + f",{value1},{value2},{xp},'{display_value}');"
            )
            total_steps += 1

    if unknown_groups:
        fail("these equipment labels have no group: " + "; ".join(sorted(unknown_groups)))

    supported_rows = sum(1 for row in design if row.get("soportado"))
    print(f"grupos          : {len(GROUPS)}")
    print(f"propiedades     : {len(design)}  ({supported_rows} aplicables hoy)")
    print(f"escalones       : {total_steps}")

    if args.check:
        print("--check: nada escrito")
        return

    OUTPUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"escrito         : {OUTPUT.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
