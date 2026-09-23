#!/usr/bin/env python3
"""Build and validate the database-driven CNR catalogue.

The frozen station JSON files are the recipe/component inventory. The Etapa-2
JSON files define the approved material, alchemy and property design, while UTI
blueprints are authoritative for Tag/TemplateResRef relationships. The legacy
SQL seed is used only for its already-audited numeric item-property rows and
for dynamic smithing metadata.
"""

from __future__ import annotations

import argparse
import ast
import csv
import json
import re
import subprocess
import sys
import tokenize
import unicodedata
from collections import OrderedDict, defaultdict
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Sequence, Tuple


ROOT = Path(__file__).resolve().parent.parent
NSS = ROOT / "src" / "cnr" / "nss"
DOCS = ROOT / "documentation" / "oficios"
CATALOGUE_DIR = ROOT / "migration" / "catalogue"
LEGACY_SEED_PATH = ROOT / "migration" / "legacy-catalogue-seed.sql"
SEED_PATH = ROOT / "migration" / "02_seed.sql"
CATALOGUE_PATH = ROOT / "migration" / "03_catalogue.sql"
MODULE_GIT = ROOT / "src" / "module" / "git"

# -----------------------------------------------------------------------------
# Naming contract. Every blueprint CNR owns lives under src/cnr and is named
# cnr_*, with tag equal to resref, so a rename is mechanical and checkable and the
# trade can be lifted into another module whole. documentation/oficios/cnr/
# naming.md owns the scheme; the exceptions below are the complete list.
# -----------------------------------------------------------------------------
CNR_UTI = ROOT / "src" / "cnr" / "uti"
CNR_UTP = ROOT / "src" / "cnr" / "utp"
SHARED_UTI = ROOT / "src" / "shared" / "uti"
SHARED_UTP = ROOT / "src" / "shared" / "utp"
ITEM_PALETTE = ROOT / "src" / "shared" / "itp" / "itempalcus.itp.json"
PLACEABLE_PALETTE = ROOT / "src" / "shared" / "itp" / "placeablepalcus.itp.json"
STORE_LIST = NSS / "sapo_cons_alma.nss"
RESREF_MAX = 16
# pb_mod_activate dispatches potions on the "sute_her" tag prefix and their tags
# carry codes such as sute_her_DM1, so potions keep both their names and tags.
POTION_PREFIX = "sute_her_"
# Blueprints that must all satisfy one station tool share that tool's tag. Owner
# decision, 2026-09-16.
SHARED_TOOL_TAGS = {
    "cnr_t_martlig_2": "cnr_t_martligero",
    "cnr_t_martlig_3": "cnr_t_martligero",
    "cnr_t_martlig_4": "cnr_t_martligero",
    "cnr_t_aguja_peq": "cnr_t_aguja",
}
# Owner requires the skinning variants to retain identical item identity fields.
ITEM_TEMPLATE_ALIASES = {"cnr_t_desol_gran": "cnr_t_desollador"}
# The engine's stations and resource chests keep CNR's own convention, cnr +
# CamelCase: that tag is the key cnr_station and the scripts look them up by.
ENGINE_PLACEABLE = re.compile(r"^cnr[A-Z][A-Za-z]+$")
# Identifiers in the trade's item namespaces. A literal in one of them that names
# no blueprint is exactly what a rename leaves behind. Essences and crystals are
# numbered, which keeps them apart from the engine's cnr_c_* conversations.
ITEM_NAMESPACE = re.compile(r"^cnr_(?:[bgjmpqt]_[a-z0-9_]+|[ce]_[0-9]+)$")
# Converts persisted store keys, so it names retired identifiers on purpose.
STORE_KEY_MIGRATION = "sapo_alma_migr.nss"

ALCHEMY_PROFESSION_ID = 4   # potions are not enchantable goods
DC_MIN = 10
DC_MAX = 35
# A profession runs 1..20 and its recipes open along it one or two at a time.
# The tier still decides material, DC and, in jewellery, the metal; this is only
# what the menu is allowed to show.
LEVEL_MIN = 1
LEVEL_MAX = 20
# Raised 30% on 2026-08-16. At 12-48 every profession needed about 1300 crafts
# to reach level 20 against the 43000-XP curve in cnr_trade_init.nss, which is
# grind rather than progression. Stored player XP is untouched by this: a
# character keeps its level and simply advances faster from here.
XP_MIN = 21
XP_MAX = 81
MATERIAL_XP_FACTOR = 0.30
GOLD_PER_DC = 12
# Tier 4 rolls against a DC this much lower than its progression position
# gives (2026-09-23). At 31-35 a level 17-20 crafter failed tier 4 so often
# that tier 3 paid as much experience per attempt, and the top tier was never
# needed to level. The gold cost stays on the unrelieved DC.
TIER4_DC_RELIEF = 3

PROFESSIONS = (
    (1, "Herreria", "Herrería", 0, 0, 2, 1000),
    (2, "Carpinteria", "Carpintería", 1, 1, 0, 2000),
    (3, "Peleteria", "Peletería", 2, 1, 2, 3000),
    (4, "Alquimia", "Alquimia", 3, 4, 3, 4000),
    (5, "Joyeria", "Joyería", 4, 5, 4, 5000),
    (6, "Arcano", "Arcano", 5, 3, 4, 6000),
    (7, "Sastreria", "Sastrería", 6, 1, 5, 7000),
)


@dataclass(frozen=True)
class Station:
    source: str
    tag: str
    profession_id: int
    display_name: str
    output_kind: str
    animation: Optional[str]


STATIONS: Sequence[Station] = (
    Station("cnralchemytable", "cnrAlchemyTable", 4, "Mesa de alquimia", "product", "cnr_alchemy_anim"),
    Station("cnranvilsmith", "cnrAnvilSmith", 1, "Yunque de herrero", "product", "cnr_anvil_anim"),
    Station("cnrcuringtub", "cnrCuringTub", 3, "Tina de curtido", "material", "cnr_curing_anim"),
    Station("cnrforgepublic", "cnrForgePublic", 1, "Forja", "material", "cnr_forge_anim"),
    Station("cnrhebcauldron", "cnrHebCauldron", 4, "Caldero de hierbas", "material", "cnr_alchemy_anim"),
    Station("cnrjewelersbench", "cnrJewelersBench", 5, "Mesa de joyero", "product", "cnr_jeweler_anim"),
    Station("cnrtailorstable", "cnrTailorsTable", 3, "Mesa de peletero", "product", "cnr_tailor_anim"),
    Station("cnrsewingtable", "cnrSewingTable", 7, "Mesa de sastrería", "product", "cnr_tailor_anim"),
    Station("cnrsawtable", "cnrSawTable", 2, "Tabla de serrería", "material", "cnr_carp_anim"),
    Station("cnrcarpsbench", "cnrCarpsBench", 2, "Banco de carpintero", "product", "cnr_carp_anim"),
)

STATION_TOOLS = (
    # 4% for ordinary tools, 3% for needles; each is rolled per attempt. A tool does not
    # wear down, it either survives the roll or it is gone. The engine reads
    # this as a percentage: Random(10000) < chance * 100.
    #
    # It was 10.0 from 2026-08-14 to 2026-08-19, which is one tool every ten
    # crafts and drew complaints about kits breaking twice in a row. The legacy
    # values were 0.3 and 0.1, written as if they were percentages but read by
    # the old engine as a third of one percent and a tenth, so tools never
    # broke at all. 4% sits between the two: about twenty-five crafts per tool.
    ("cnrAnvilSmith", "cnr_t_martligero", "equipped", 4.0, 1),
    ("cnrForgePublic", "cnr_t_gu_fundid", "equipped", 4.0, 1),
    # Only for cutting: setting a stone into a blank does not need the kit.
    ("cnrJewelersBench", "cnr_t_kit_orfeb", "inventory", 4.0, 1, "Tallado"),
    # The needle is held, not carried. Its 3% chance averages 33.3 attempts.
    ("cnrTailorsTable", "cnr_t_aguja", "equipped", 3.0, 1),
    ("cnrTailorsTable", "cnr_t_kit_cuero", "inventory", 4.0, 2),
    ("cnrAlchemyTable", "cnr_t_gu_alquim", "equipped", 4.0, 1),
    ("cnrHebCauldron", "cnr_t_gu_cocina", "equipped", 4.0, 1),
    ("cnrSewingTable", "cnr_t_aguja", "equipped", 3.0, 1),
    # Sastreria has its own kit; the leather one stays with Peleteria.
    ("cnrSewingTable", "cnr_t_kit_sastre", "inventory", 4.0, 2),
    ("cnrSawTable", "cnr_t_kit_serr", "inventory", 4.0, 1),
    ("cnrSawTable", "cnr_t_sierra", "inventory", 4.0, 2),
    ("cnrCarpsBench", "cnr_t_kit_carp", "inventory", 4.0, 1),
)

# The number the player types is allocated from the station's own base, not
# from a counter shared by the whole profession. Four professions run two
# stations, and while they shared a counter, adding a recipe to the first one
# renumbered every recipe of the second: the eighteen light tier-4 pieces moved
# the forge's fifteen ingots from 1121-1135 to 1139-1153. Reported by the audit
# of 2026-08-23.
#
# Every base sits inside its profession's thousand, and a profession that runs
# two stations splits that thousand down the middle: the first station starts
# at X000 and the second at X500. The bases used to sit right behind the
# station in front of them - the forge at 1200, the bench at 2008, the table at
# 3010, the cauldron at 4065 - so every station was one recipe away from
# colliding with its neighbour, and the forty-five alchemy recipes that were
# authored but never written into the legacy script would have run the mesa
# straight through the cauldron's base. Five hundred numbers per station is
# more than any station will ever need, so the bases stop moving.
# A station that grows into the next base is still a build error rather than a
# silent renumbering - see the check below.
PUBLIC_ID_BASES = {
    "cnranvilsmith": 1000,
    "cnrforgepublic": 1500,
    "cnrsawtable": 2000,
    "cnrcarpsbench": 2500,
    "cnrcuringtub": 3000,
    "cnrtailorstable": 3500,
    "cnralchemytable": 4000,
    "cnrhebcauldron": 4500,
    "cnrjewelersbench": 5000,
    "cnrsewingtable": 7000,
}

EXPECTED_RECIPE_COUNTS = {
    # 65 while the catalogue only carried what the legacy cnrAlchemyTable.nss
    # had written down. alquimia.json authored 110 results and the script only
    # ever implemented 65, so forty-five potions - Blanca, Furiosa, de Agua and
    # the rest - were designed, given a base blueprint, and never craftable.
    "cnralchemytable": 110,
    "cnranvilsmith": 138,
    "cnrcuringtub": 10,
    # 15 until the steel nugget was added on 2026-09-01. Steel is the one metal
    # with no vein in the map: it is alloyed from iron and carbon instead, which
    # the harvesting notes had specified and nothing had implemented, so the
    # steel ingot was enabled and impossible to make.
    "cnrforgepublic": 16,
    "cnrhebcauldron": 8,
    # 86 originally. The chain retired 30 metal recipes and added 28 cutting
    # ones; then silver left the trade, taking 22 setting recipes with it, and
    # the six blanks moved here from the anvil so a jeweller needs no smith.
    "cnrjewelersbench": 90,
    # 70 until the whip was added over the ten leathers.
    # 80 until the whip left on 2026-08-23. It is a weapon: it belongs to the
    # smith's variant group, where it gets a metal and the weapon properties,
    # instead of ten leather recipes that asked for a glove pattern and carried
    # no properties at all.
    "cnrtailorstable": 70,
    # 37 until the seven legacy 'Pattern for X' recipes were removed: they
    # produced a cnrPat* blueprint and consumed cnrBookPatterns and cnrCloth,
    # none of which exists in the repository, the game or the haks.
    "cnrsewingtable": 30,
    "cnrsawtable": 8,
    # 78 until a plain oak magic staff was added so arcane has a MAGICSTAFF to
    # enchant: the eight carpentry staves are quarterstaves, and 76 design rows
    # ask for a "baston".
    "cnrcarpsbench": 79,
}

SMITH_TIER_COUNTS = (3, 5, 4, 3)
LEATHER_TIER_COUNTS = (2, 2, 2, 4)
JEWEL_TIER_SIZE = 7
CARP_TIER_COUNTS = (2, 2, 2, 2)


@dataclass(frozen=True)
class Blueprint:
    tag: str
    resref: str
    name: Optional[str]
    path: Path
    base_item: Optional[int] = None


@dataclass(frozen=True)
class Component:
    tag: str
    quantity: int
    retain_on_fail: int
    # A component the craft gives back on success is a reusable tool, not an
    # ingredient. This is how the legacy biproduct mechanic is expressed.
    retain_on_success: int = 0


@dataclass
class RecipeSource:
    station: Station
    category_id: int
    category_name: str
    display_name: str
    legacy_code: str
    output_quantity: int
    components: List[Component]
    legacy_level: int
    pre_craft_script: Optional[str]
    # Authored recipes may be parked without being deleted; the engine filters
    # on enabled = 1 when listing, counting and looking up by id.
    enabled: bool = True
    # Use this resref verbatim instead of resolving legacy_code. Required when
    # the output is a base game item, because PDB has unique named blueprints
    # that keep the base item's TAG - resolving "nw_wbwln001" by tag finds
    # "Arco de Anirin" and the recipe would craft that instead.
    literal_resref: Optional[str] = None
    # Which column of carpinteria.json supplies this recipe's properties.
    property_set: Optional[str] = None
    # A second product, created on success only. Stated as a literal resref for
    # the same reason base_resref is: nothing about it is resolved.
    extra_resref: Optional[str] = None
    extra_quantity: int = 0
    # When set, the recipe offers the products of this group and makes the one
    # the player picks. base_resref stays as the group's first variant so no
    # query ever reads an empty product.
    variant_group: Optional[str] = None


@dataclass(frozen=True)
class Material:
    profession_id: int
    code: str
    display_name: str
    tier: int
    sort_order: int


@dataclass
class Recipe:
    recipe_id: int
    public_id: int
    source: RecipeSource
    material_code: Optional[str]
    tier: int
    min_level: int
    crafted_by: int
    display_name: str
    base_resref: str
    output_tag: Optional[str]
    dc: int
    xp: int
    gold: int
    enabled: int = 1
    # Palette name of the extra product. The recipe list shows this, never the
    # resref, for the same reason components show a name and not a tag.
    extra_name: Optional[str] = None
    # The result holds a gem and is therefore no longer material for anything.
    marks_socketed: int = 0


def read_text(path: Path, encoding: str = "cp1252") -> str:
    return path.read_text(encoding=encoding)


def load_json(path: Path, encoding: str = "cp1252"):
    return json.loads(read_text(path, encoding))


def load_csv(path: Path) -> List[dict]:
    with path.open("r", encoding="utf-8-sig", newline="") as stream:
        return list(csv.DictReader(stream))


def normalize(value: Optional[str]) -> str:
    decomposed = unicodedata.normalize("NFKD", value or "")
    plain = "".join(char for char in decomposed if not unicodedata.combining(char))
    plain = re.sub(r"<[^>]*>", "", plain)
    return re.sub(r"[^a-z0-9]+", " ", plain.casefold()).strip()


def normalize_property_text(value: Optional[str]) -> str:
    """Normalize design wording while preserving its numeric meaning."""
    aliases = {
        "dano": "",
        "electricidad": "relampago",
        "electrico": "relampago",
        "malignos": "maligno",
        "positivo": "radiante",
        "reg": "regeneracion",
        "resistencia": "",
        "sonico": "trueno",
        "vs": "",
    }
    normalized_clauses = []
    for clause in re.split(r"[|,]", value or ""):
        normalized = normalize(clause)
        for phrase in ("muertos vivientes", "no muertos", "undeads"):
            normalized = normalized.replace(phrase, "nomuertos")
        normalized = re.sub(
            r"\b(\d+)\s+reg\s+vampirica\b", r"reg vampirica \1", normalized
        )
        normalized = re.sub(r"\b(\d+)\s+regeneracion\b", r"regeneracion \1", normalized)
        normalized_clause = "".join(
            aliases.get(token, token) for token in normalized.split()
        )
        if normalized_clause:
            normalized_clauses.append(normalized_clause)
    return "|".join(normalized_clauses)


def validate_design_sources(
    smith_json: Sequence[dict],
    jewelry_json: Sequence[dict],
    leather_json: Sequence[dict],
    alchemy_json: Sequence[dict],
) -> None:
    smith_csv = load_csv(DOCS / "Oficios Basicos - Etapa 2 - 2025 - Herreria.csv")
    jewelry_csv = load_csv(DOCS / "Oficios Basicos - Etapa 2 - 2025 - Joyería.csv")
    leather_csv = load_csv(DOCS / "Oficios Basicos - Etapa 2 - 2025 - Peleteria.csv")
    poison_csv = load_csv(DOCS / "Oficios Basicos - Etapa 2 - 2025 - Venenos.csv")

    smith_rows = [
        row for row in smith_csv if row["Metal"] and not row["Metal"].startswith("Nivel")
    ]
    smith_materials = list(OrderedDict((row["material"], None) for row in smith_json))
    if len(smith_json) != 75 or len(smith_materials) != 15:
        raise ValueError("herreria.json must contain 15 materials times five item types")
    if {normalize(row["Metal"]) for row in smith_rows} != {
        normalize(material) for material in smith_materials
    }:
        raise ValueError("Smithing material names differ between CSV and JSON")
    smith_by_key = {
        (normalize(row["material"]), normalize(row["tipo"])): row
        for row in smith_json
    }
    smith_property_map = {
        "Propiedades - Armas": "arma",
        "Propiedades - Armaduras": "armadura",
        "Propiedades - Escudos": "escudo",
        "Propiedades - Cascos": "casco",
        "Propiedades - Municion": "municion",
    }
    smith_mismatches = []
    for row in smith_rows:
        for csv_column, item_type in smith_property_map.items():
            source = smith_by_key.get((normalize(row["Metal"]), item_type))
            if not source or normalize_property_text(row[csv_column]) != normalize_property_text(
                source["propiedad"]
            ):
                smith_mismatches.append(f"{row['Metal']} / {item_type}")
    if smith_mismatches:
        raise ValueError("Smithing CSV/JSON mismatch for: " + ", ".join(smith_mismatches))

    if len(jewelry_json) != 28:
        raise ValueError("joyeria.json must contain 28 gems")
    jewelry_by_name = {normalize(row["gema"]): row for row in jewelry_json}
    if len(jewelry_by_name) != len(jewelry_json) or len({row["tag"] for row in jewelry_json}) != 28:
        raise ValueError("Jewelry gem names and tags must be unique")
    jewelry_metals = {"bronce", "oro", "platino"}
    tiers = {row.get("tier") for row in jewelry_json}
    if tiers != {1, 2, 3}:
        raise ValueError(f"Jewellery tiers must be 1..3, found {sorted(tiers)}")
    for row in jewelry_json:
        for key in ("tallada", "metal", "anillo", "colgante"):
            if not row.get(key):
                raise ValueError(f"Gem {row['tag']!r} is missing its {key}")
        if row["metal"] not in jewelry_metals:
            raise ValueError(f"Gem {row['tag']!r} names an unknown metal {row['metal']!r}")
    # One cut gem, one ring and one necklace per gem, and no two gems share any
    # of them: this is what makes a set piece identify its stone.
    for key in ("tallada", "anillo", "colgante"):
        if len({row[key] for row in jewelry_json}) != 28:
            raise ValueError(f"Gems must not share a {key}")
    dust_count = sum(1 for row in jewelry_json if row.get("arenilla"))
    if dust_count != 8:
        raise ValueError(f"Expected 8 gems to yield dust, found {dust_count}")

    for row in jewelry_csv:
        source = jewelry_by_name.get(normalize(row["Gema TALLADA"]))
        if not source or normalize_property_text(source["propiedad"]) != normalize_property_text(
            row["Propiedades"]
        ):
            raise ValueError(f"Jewelry CSV/JSON mismatch for {row['Gema TALLADA']!r}")

    leather_rows = [
        row for row in leather_csv if row["Piel"] and not row["Piel"].startswith("Nivel")
    ]
    def leather_name(value: str) -> str:
        return normalize(value).replace("herviboro", "herbivoro")

    leather_by_name = {leather_name(row["piel"]): row for row in leather_json}
    if len(leather_json) != 10 or len(leather_by_name) != 10:
        raise ValueError("peleteria.json must contain ten unique hides")
    leather_property_map = {
        "Propiedades - Armadura": "armadura",
        "Propiedades - Cinturón": "cinturon",
        "Propiedades - Capa": "capa",
        "Propiedades - Botas": "botas",
        "Propiedades - Brazales": "brazales",
        "Propiedades - Guantes": "guantes",
    }
    for row in leather_rows:
        source = leather_by_name.get(leather_name(row["Piel"]))
        if not source:
            raise ValueError(f"Leather CSV row {row['Piel']!r} is absent from JSON")
        for csv_column, json_key in leather_property_map.items():
            if normalize_property_text(row[csv_column]) != normalize_property_text(
                source[json_key]["propiedad"]
            ):
                raise ValueError(f"Leather CSV/JSON mismatch for {row['Piel']!r}, {csv_column}")

    alchemy_by_name = {normalize(row["resultado"]): row for row in alchemy_json}
    if len(alchemy_json) != 110 or len(alchemy_by_name) != 110:
        raise ValueError("alquimia.json must contain 110 unique results")
    for row in poison_csv:
        source = alchemy_by_name.get(normalize(row["Resultado"]))
        if not source:
            raise ValueError(f"Poison CSV row {row['Resultado']!r} is absent from JSON")
        csv_components = sorted(
            normalize(row[key])
            for key in ("Componente1", "Componente2", "Componente3")
            if row[key] and normalize(row[key]) != "n a"
        )
        json_components = sorted(
            normalize(source[key])
            for key in ("componente1", "componente2", "componente3")
            if source[key]
        )
        if csv_components != json_components:
            raise ValueError(f"Poison component mismatch for {row['Resultado']!r}")


def sql_value(value) -> str:
    if value is None or value == "":
        return "NULL"
    if isinstance(value, (int, float)):
        return str(value)
    escaped = str(value).replace("\\", "\\\\").replace("'", "''")
    return f"'{escaped}'"


def tier_sequence(values: Sequence[str], counts: Sequence[int]) -> Dict[str, int]:
    tiers: Dict[str, int] = {}
    index = 0
    for tier, count in enumerate(counts, 1):
        for value in values[index:index + count]:
            tiers[value] = tier
        index += count
    if index != len(values):
        raise ValueError(f"Tier definition covers {index} values, expected {len(values)}")
    return tiers


def progression_value(position: int, total: int, minimum: int, maximum: int) -> int:
    """Spread an authored position over an inclusive numeric range."""
    if position < 1 or position > total:
        raise ValueError(f"Progression position {position} is outside 1..{total}")
    if total <= 1:
        return minimum
    numerator = (position - 1) * (maximum - minimum)
    return minimum + (numerator + ((total - 1) // 2)) // (total - 1)


def alchemy_authored_difficulty(
    recipe: dict,
    poison_handling_by_name: Dict[str, int],
) -> int:
    """Return the authored ordering value without changing output identity."""
    recipe_name = normalize(recipe["resultado"])
    if recipe_name in poison_handling_by_name:
        return poison_handling_by_name[recipe_name]

    tag = recipe["sCustomTag"]
    potion_match = re.match(r"^sute_her_[0-9]+_([0-9]+)_", tag, re.IGNORECASE)
    if potion_match:
        return int(potion_match.group(1))

    # Distilled water is the sole authored utility recipe without a numeric
    # potion tag. It is intentionally the first alchemy exercise.
    if tag == "sute_her_DM1":
        return 1

    raise ValueError(
        f"Alchemy recipe {recipe['resultado']!r} has no authored difficulty"
    )


def parse_sql_rows(source: str, table: str) -> List[List[str]]:
    bodies = re.findall(rf"INTO\s+{re.escape(table)}\s+VALUES\s*\((.*?)\);", source)
    rows: List[List[str]] = []
    for body in bodies:
        rows.append(next(csv.reader([body], quotechar="'", skipinitialspace=True)))
    return [[column.strip() for column in row] for row in rows]


def load_blueprints() -> Tuple[Dict[str, Blueprint], Dict[str, Blueprint]]:
    by_tag: Dict[str, Blueprint] = {}
    by_resref: Dict[str, Blueprint] = {}
    # CNR's own blueprints live under src/cnr/uti; the rest of the module's are
    # still in src/shared/uti, and a recipe may name either.
    paths = sorted(
        list((ROOT / "src" / "cnr" / "uti").glob("*.uti.json"))
        + list((ROOT / "src" / "shared" / "uti").glob("*.uti.json"))
    )
    for path in paths:
        data = None
        for encoding in ("utf-8", "cp1252"):
            try:
                data = load_json(path, encoding)
                break
            except (UnicodeDecodeError, json.JSONDecodeError):
                continue
        if not data:
            continue
        tag = data.get("Tag", {}).get("value", "")
        resref = data.get("TemplateResRef", {}).get("value", "")
        localized = data.get("LocalizedName", {}).get("value", {})
        name = None
        if isinstance(localized, dict):
            # Language-keyed text only. A blueprint may instead hold a bare
            # StrRef - {"id": 13484} - and taking the first value of that dict
            # yielded the number itself, which is what the menu printed.
            for key in ("0", "1", "2", "3", "8"):
                candidate = localized.get(key)
                if isinstance(candidate, str) and candidate.strip():
                    name = candidate
                    break
        if isinstance(name, str) and name.strip().isdigit():
            name = None
        if not tag or not resref:
            continue
        base_item = data.get("BaseItem", {}).get("value")
        blueprint = Blueprint(tag, resref, name, path,
                              base_item if isinstance(base_item, int) else None)
        by_tag.setdefault(normalize(tag), blueprint)
        by_resref.setdefault(normalize(resref), blueprint)
    return by_tag, by_resref


def load_module_names() -> Dict[str, str]:
    """Display names of tagged items placed in tracked module areas.

    Some components exist only as area instances, never as a blueprint under
    src/shared/uti, so the menu had nothing to show but their tag. A name that
    is only a StrRef number is skipped: it would read worse than the tag.
    """
    names: Dict[str, str] = {}

    def walk(node) -> None:
        if isinstance(node, dict):
            tag = node.get("Tag")
            localized = node.get("LocalizedName")
            if isinstance(tag, dict) and isinstance(localized, dict):
                tag_value = tag.get("value")
                values = localized.get("value")
                if isinstance(tag_value, str) and isinstance(values, dict) and values:
                    text = re.sub(r"<[^>]*>", "", str(next(iter(values.values())))).strip()
                    if text and not text.isdigit():
                        names.setdefault(tag_value, text)
            for child in node.values():
                walk(child)
        elif isinstance(node, list):
            for child in node:
                walk(child)

    for path in sorted(MODULE_GIT.glob("*.git.json")):
        try:
            walk(json.loads(path.read_text(encoding="utf-8")))
        except (ValueError, UnicodeDecodeError):
            continue
    return names


def load_module_tags() -> set[str]:
    """Return exact object tags embedded in tracked module area instances."""
    tag_pattern = re.compile(
        br'"Tag"\s*:\s*\{\s*"type"\s*:\s*"[^"]+"\s*,\s*"value"\s*:\s*"([^"]+)"'
    )
    tags: set[str] = set()
    for path in sorted(MODULE_GIT.glob("*.git.json")):
        tags.update(tag.decode("ascii") for tag in tag_pattern.findall(path.read_bytes()))
    return tags


# ---------------------------------------------------------------------------
# Carpentry design text -> property rows.
#
# The CSV states properties as Spanish prose, so it is parsed rather than
# tabulated. Anything this cannot map raises: a silently dropped clause is an
# item that quietly lacks a designed property.
# ---------------------------------------------------------------------------
def carp_norm(value: str) -> str:
    d = unicodedata.normalize('NFKD', (value or '').lower())
    return ''.join(c for c in d if not unicodedata.combining(c)).strip()

# Arcane spell failure reduction, as INDICES. All ten constants were declared,
# compiled and disassembled: MINUS_5..MINUS_50 are 9,8,7,6,5,4,3,2,1,0. They are
# linear, so this is a formula rather than a hand-written table - twice now a
# hand-written subset was mistaken for the whole set.
CARP_ASF = {pct: (50 - pct) // 5 for pct in range(5, 55, 5)}

# 'fisico' is deliberately absent: in this design it does not name a damage
# type, it names the physical type the weapon does not already deal, and only
# the engine knows that at craft time. It becomes DamageBonusOpposite, which
# cnr_i_prop.nss resolves from the item. Mapping it to iprp_damagetype row 4
# looked right and silently produced nothing: that row carries no cost on this
# server, so every property built on it was discarded and the weapon came out
# with its enhancement bonus alone.
CARP_DANO = {'contundente':0,'perforante':1,'cortante':2,'magico':5,'acido':6,
        'frio':7,'divino':8,'relampago':9,'fuego':10,'necrotico':11,'radiante':12,
        'trueno':13,'veneno':17}
CARP_INMUN = {5:1, 10:2, 25:3, 50:4, 75:5, 90:6, 100:7, 20:8, 15:9}
CARP_SAVEDC = {14:0, 16:1, 18:2, 20:3, 22:4, 24:5, 26:6, 28:7, 30:8, 32:9, 34:10}

def parse_carpentry_clause(clausula: str):
    """-> list of (property_type, subtype, value1, value2) or None if unknown."""
    c = carp_norm(clausula)
    c = re.sub(r'\s+', ' ', c)
    r = []
    # 1dN <tipo> CD NN Ralentizar   (compound)
    m = re.fullmatch(r'1d(\d+) (\w+) cd (\d+) ralentizar', c)
    if m and m.group(2) in CARP_DANO and int(m.group(3)) in CARP_SAVEDC:
        return [('DamageBonus', CARP_DANO[m.group(2)], 0, int(m.group(1))),
                ('OnHitSlow', 0, CARP_SAVEDC[int(m.group(3))], 0)]
    m = re.fullmatch(r'1d(\d+) (?:dano )?fisico cd (\d+) ralentizar', c)
    if m and int(m.group(2)) in CARP_SAVEDC:
        return [('DamageBonusOpposite', 0, 0, int(m.group(1))),
                ('OnHitSlow', 0, CARP_SAVEDC[int(m.group(2))], 0)]
    m = re.fullmatch(r'1d(\d+) criticos masivos', c)
    if m: return [('MassiveCriticals', 0, 0, int(m.group(1)))]
    m = re.fullmatch(r'1d(\d+) (?:dano )?fisico', c)
    if m:
        return [('DamageBonusOpposite', 0, 0, int(m.group(1)))]
    m = re.fullmatch(r'1d(\d+) (?:dano )?(\w+)', c)
    if m and m.group(2) in CARP_DANO:
        return [('DamageBonus', CARP_DANO[m.group(2)], 0, int(m.group(1)))]
    m = re.fullmatch(r'(?:mejora (\d+)|(\d+) mejora)', c)
    if m: return [('EnhancementBonus', 0, int(m.group(1) or m.group(2)), 0)]
    m = re.fullmatch(r'(?:ataque (\d+)|(\d+) ataque)', c)
    if m: return [('AttackBonus', 0, int(m.group(1) or m.group(2)), 0)]
    m = re.fullmatch(r'reforzado (\d+)', c)
    if m: return [('Mighty', 0, int(m.group(1)), 0)]
    if c in ('afilado', 'afiladura'): return [('Keen', 0, 0, 0)]
    m = re.fullmatch(r'ca ?(\d+)', c)
    if m: return [('ACBonus', 0, int(m.group(1)), 0)]
    m = re.fullmatch(r'(?:inmunidad )?(\d+)% (?:resistencia |inmunidad )?(\w+)', c)
    if m and int(m.group(1)) in CARP_INMUN and m.group(2) in CARP_DANO:
        return [('DamageImmunity', CARP_DANO[m.group(2)], CARP_INMUN[int(m.group(1))], 0)]
    m = re.fullmatch(r'(\d+)[%&] reduccion fallo conjuro', c)
    if m and int(m.group(1)) in CARP_ASF:
        return [('SpellFailure', 0, CARP_ASF[int(m.group(1))], 0)]
    m = re.fullmatch(r'cd (\d+) aturdir', c)
    if m and int(m.group(1)) in CARP_SAVEDC: return [('Stun', 0, CARP_SAVEDC[int(m.group(1))], 0)]
    m = re.fullmatch(r'ralentizar cd (\d+)', c)
    if m and int(m.group(1)) in CARP_SAVEDC: return [('OnHitSlow', 0, CARP_SAVEDC[int(m.group(1))], 0)]
    return None


# The CNR's own base blueprints. A recipe that makes one of these item types
# builds it from OUR blueprint, never from a stock one and never from a named
# item that happens to be lying around in the palette.
#
# This is here as the last word: an authored recipe, a legacy metadata row and
# a literal resref all reach this map, so no route into the catalogue can
# quietly reintroduce a stock blueprint. Adding a new base item type means
# adding the .uti under src/cnr/uti and one line here.
#
# The list, with what each one is and which recipes use it, is in
# documentation/oficios/cnr/base-items.md.
CNR_BASE_ITEMS: Dict[str, str] = {
    "nw_wswls001": "cnr_b_lsword",     # espada larga
    "nw_ashlw001": "cnr_b_lshield",    # escudo grande
    "nw_ashsw001": "cnr_b_sshield",    # escudo pequeno
    "nw_wamar001": "cnr_b_arrow",      # flechas
    "nw_wambo001": "cnr_b_bolt",       # virotes
    "nw_wambu001": "cnr_b_bullet",     # balas de honda
    "nw_wbwsh001": "cnr_b_sbow",       # arco corto
    "nw_wbwln001": "cnr_b_lbow",       # arco largo
    "nw_wbwxl001": "cnr_b_lxbow",      # ballesta ligera
    "nw_wbwxh001": "cnr_b_hxbow",      # ballesta pesada
    "nw_wblcl001": "cnr_b_club",       # clava
    "nw_wdbqs001": "cnr_b_qstaff",     # baston
    "nw_cloth029": "cnr_b_cloth",      # ropa, CA 0
    "nw_aarcl004": "cnr_b_leather",    # armadura de cuero, CA 2
    # nw_aarcl013 no esta aqui a proposito: era una capa magica que servia a
    # tres familias de armadura a la vez, y cada una fue a su propio blueprint
    # en los ficheros de catalogo. Un mapa 1 a 1 no puede deshacer eso.
}


# joyeria.json names the blank's metal as the design does; the blueprints are named
# after what the player sees, and the bronce blanks are shown as copper.
JEWELRY_BLANK_METAL = {"bronce": "cobre", "oro": "oro", "platino": "platino"}


def apply_cnr_base_item(base_resref: str) -> str:
    """Send a stock base blueprint to the CNR's own equivalent.

    Compared in plain lower case and not through normalize(), which strips the
    underscore out of "nw_wambu001" and would never match a key here.
    """
    return CNR_BASE_ITEMS.get((base_resref or "").strip().lower(), base_resref)


def resolve_resref(
    identifier: str,
    blueprints_by_tag: Dict[str, Blueprint],
    blueprints_by_resref: Dict[str, Blueprint],
) -> Tuple[str, bool]:
    key = normalize(identifier)
    blueprint = blueprints_by_resref.get(key) or blueprints_by_tag.get(key)
    if blueprint:
        return blueprint.resref, True
    if 0 < len(identifier) <= 16:
        return identifier, False
    raise ValueError(f"{identifier!r} is neither a local blueprint nor a valid resref")


RE_SUBMENU = re.compile(
    r"(?:string\s+)?(\w+)\s*=\s*CnrRecipeAddSubMenu\(\s*\"[^\"]+\"\s*,\s*\"([^\"]+)\"\s*\)"
)
RE_RECIPE = re.compile(
    r"CnrRecipeCreateRecipe\(\s*(?:\"([^\"]+)\"|(\w+))\s*,\s*\"([^\"]*)\"\s*,\s*\"([^\"]*)\"\s*,\s*(\d+)\s*\)"
)
RE_COMPONENT = re.compile(
    r"CnrRecipeAddComponent\(\s*\w+\s*,\s*\"([^\"]+)\"\s*,\s*(\d+)\s*(?:,\s*(\d+)\s*)?\)"
)
RE_LEVEL = re.compile(r"CnrRecipeSetRecipeLevel\(\s*\w+\s*,\s*(\d+)\s*\)")
RE_PRE_CRAFT = re.compile(
    r"CnrRecipeSetRecipePreCraftingScript\(\s*\w+\s*,\s*\"([^\"]+)\"\s*\)"
)


# Submenus that lump together item classes the player should browse apart.
# The real category is decided by how the recipe name starts.
CATEGORY_SPLITS: Dict[str, List[Tuple[str, str]]] = {
    "Armaduras Intermedias": [
        ("Cota de escamas", "Cotas de Escamas"),
        ("Armadura completa", "Armaduras Completas"),
    ],
}


def split_category(submenu: str, recipe_name: str) -> str:
    """Effective category name for a recipe."""
    for prefix, target in CATEGORY_SPLITS.get(submenu, []):
        if recipe_name.lower().startswith(prefix.lower()):
            return target
    return submenu


def load_station_json(station: Station) -> dict:
    """Read one frozen station file from migration/catalogue/.

    The `.nss` sources are no longer read. migration/extract_catalogue_json.py
    froze them once; this JSON is the authored source from now on.
    """
    path = CATALOGUE_DIR / f"{station.source}.json"
    if not path.exists():
        raise SystemExit(
            f"missing {path.relative_to(ROOT)} - restore the frozen catalogue source"
        )
    with path.open(encoding="utf-8") as handle:
        return json.load(handle)


AUTHORED_COMPONENT_NAMES: Dict[str, str] = {}


def parse_station_recipes() -> Tuple[List[str], List[RecipeSource], Dict[str, int]]:
    category_sql: List[str] = []
    recipes: List[RecipeSource] = []
    authored_component_names: Dict[str, str] = {}
    station_counts: Dict[str, int] = defaultdict(int)
    category_id = 0

    for station in STATIONS:
        document = load_station_json(station)
        station_counts[station.source] += 0
        # Categories are created on demand: one submenu may yield several.
        by_name: Dict[str, Tuple[int, str]] = {}
        sort_counter = [0]

        def category_for(display_name: str) -> Tuple[int, str]:
            nonlocal category_id
            if display_name not in by_name:
                category_id += 1
                sort_counter[0] += 1
                by_name[display_name] = (category_id, display_name)
                category_sql.append(
                    "INSERT INTO cnr_category "
                    "(category_id,station_id,parent_id,display_name,sort_order) "
                    f"SELECT {category_id},station_id,NULL,{sql_value(display_name)},{sort_counter[0]} "
                    f"FROM cnr_station WHERE tag={sql_value(station.tag)};"
                )
            return by_name[display_name]

        for entry in document["recipes"]:
            for component in entry["components"]:
                # A base game item has no local blueprint and no placed
                # instance to read a name from; the JSON may state one so the
                # menu does not fall back to the raw tag.
                if component.get("display_name"):
                    authored_component_names.setdefault(
                        component["tag"], component["display_name"]
                    )
            display_name = entry["display_name"]
            legacy_code = entry["output_tag"]
            # A recipe declared straight on the device has no submenu.
            submenu = entry["submenu"] or "General"
            category = category_for(split_category(submenu, display_name))

            # A recipe may list the same tag twice; the primary key would
            # reject the pair, so quantities are summed and the strictest
            # retain wins.
            aggregate: "OrderedDict[str, Tuple[int, int]]" = OrderedDict()
            for component in entry["components"]:
                tag = component["tag"]
                quantity_value = int(component["qty"])
                retain_value = int(component["retain_on_fail"])
                retain_ok_value = int(component.get("retain_on_success", 0))
                if tag in aggregate:
                    old_quantity, old_retain, old_retain_ok = aggregate[tag]
                    aggregate[tag] = (old_quantity + quantity_value,
                                          max(old_retain, retain_value),
                                          max(old_retain_ok, retain_ok_value))
                else:
                    aggregate[tag] = (quantity_value, retain_value, retain_ok_value)
            # A biproduct returns an item the recipe also consumes, so it is a
            # reusable tool rather than an extra output. It becomes a retain on
            # the matching component instead of a row of its own.
            returned_tag = None
            returned_on_success = 0
            returned_on_fail = 0
            biproduct = entry["biproduct"]
            if biproduct:
                returned_tag = biproduct["tag"]
                if returned_tag not in aggregate:
                    raise ValueError(
                        f"Recipe {display_name!r} returns {returned_tag!r}, which it "
                        "does not consume; a biproduct that is not a component "
                        "needs a real output row, not a retain"
                    )
                returned_on_success = int(biproduct["qty"])
                returned_on_fail = int(biproduct["on_fail_qty"])

            components = []
            for tag, values in aggregate.items():
                quantity_value, retain_value, retain_success = values
                if tag == returned_tag:
                    retain_success = max(retain_success,
                                         min(returned_on_success, quantity_value))
                    retain_value = max(retain_value, min(returned_on_fail, quantity_value))
                components.append(
                    Component(tag, quantity_value, retain_value, retain_success)
                )
            level = entry["level"]
            recipes.append(
                RecipeSource(
                    station=station,
                    category_id=category[0],
                    category_name=category[1],
                    display_name=display_name,
                    legacy_code=legacy_code,
                    output_quantity=int(entry["output_qty"]),
                    components=components,
                    legacy_level=int(level) if level is not None else 1,
                    pre_craft_script=entry["pre_crafting_script"],
                    enabled=entry.get("enabled", True),
                    literal_resref=entry.get("base_resref"),
                    property_set=entry.get("property_set"),
                    extra_resref=(entry.get("extra_output") or {}).get("resref"),
                    extra_quantity=int((entry.get("extra_output") or {}).get("qty", 0)),
                    variant_group=entry.get("variant_group"),
                )
            )
            station_counts[station.source] += 1

    AUTHORED_COMPONENT_NAMES.update(authored_component_names)
    return category_sql, recipes, station_counts


def material_from_name(name: str, candidates: Iterable[str]) -> Optional[str]:
    normalized_name = normalize(name)
    ordered = sorted(candidates, key=lambda value: len(normalize(value)), reverse=True)
    return next((value for value in ordered if normalize(value) in normalized_name), None)


def leather_type(category_name: str, legacy_code: Optional[str]) -> Optional[str]:
    # A recipe authored here has no legacy key, and that is not an error: it
    # only means its properties cannot be looked up by the old code.
    if not legacy_code:
        return None
    if legacy_code.startswith("ropa_cuero_"):
        return "Ropa"
    if legacy_code.startswith("armaduraacol_cuero_"):
        return "Armadura de Cuero Ligera"
    if legacy_code.startswith("armaduraint_cuero_"):
        return "Armadura de Cuero Intermedia"
    if legacy_code.startswith("armaduraref_cuero_"):
        return "Armadura de Cuero Reforzada"
    if legacy_code.startswith("armadura_cuero_"):
        return "Armadura de Cuero Ligera"
    category_map = {
        "cinturon": "Cinturón de cuero",
        "capa": "Capa de piel",
        "botas": "Botas de cuero",
        "brazales": "Brazales de cuero",
        "guantes": "Guantes de cuero",
    }
    normalized_category = normalize(category_name)
    return next(
        (value for token, value in category_map.items() if token in normalized_category),
        None,
    )


def leather_base_identifier(leather_row: dict, item_type: str) -> str:
    if item_type in {
        "Ropa",
        "Armadura de Cuero Ligera",
        "Armadura de Cuero Intermedia",
        "Armadura de Cuero Reforzada",
    }:
        for row in leather_row["armadura"]["tags"]:
            if normalize(row["nombre"]) == normalize(item_type):
                return row["tag"]
        raise ValueError(f"Leather JSON has no base object for {item_type!r}")
    key_by_type = {
        "Cinturón de cuero": "cinturon",
        "Capa de piel": "capa",
        "Botas de cuero": "botas",
        "Brazales de cuero": "brazales",
        "Guantes de cuero": "guantes",
    }
    return leather_row[key_by_type[item_type]]["tag"]


def build_materials(
    source_recipes: Sequence[RecipeSource],
    smith_json: Sequence[dict],
    leather_json: Sequence[dict],
    jewelry_json: Sequence[dict],
    carpentry_json: Sequence[dict],
    property_materials: Sequence[str],
) -> Tuple[List[Material], Dict[Tuple[int, str], Material], Dict[str, str]]:
    materials: List[Material] = []
    by_key: Dict[Tuple[int, str], Material] = {}
    by_normalized_key: Dict[Tuple[int, str], Material] = {}

    def add(profession_id: int, code: str, display_name: str, tier: int) -> None:
        key = (profession_id, code)
        if key in by_key:
            return
        normalized_key = (profession_id, normalize(code))
        if normalized_key in by_normalized_key:
            by_key[key] = by_normalized_key[normalized_key]
            return
        sort_order = 1 + sum(1 for material in materials if material.profession_id == profession_id)
        material = Material(profession_id, code, display_name, tier, sort_order)
        materials.append(material)
        by_key[key] = material
        by_normalized_key[normalized_key] = material

    smith_names = list(OrderedDict((row["material"], None) for row in smith_json))
    smith_tiers = tier_sequence(smith_names, SMITH_TIER_COUNTS)
    for name in smith_names:
        add(1, name, name, smith_tiers[name])

    leather_names: List[str] = []
    leather_row_to_material: Dict[str, str] = {}
    for row in leather_json:
        candidate = "Cuero de " + re.sub(r"^Piel de\s+", "", row["piel"], flags=re.IGNORECASE)
        canonical = material_from_name(candidate, property_materials) or candidate
        leather_names.append(canonical)
        leather_row_to_material[normalize(row["piel"])] = canonical
    leather_tiers = tier_sequence(leather_names, LEATHER_TIER_COUNTS)
    for name in leather_names:
        add(3, name, name, leather_tiers[name])
        # Sastreria cuts the same hides; a recipe's tier comes from its own
        # profession's material row, so the ten exist under both.
        add(7, name, name, leather_tiers[name])

    # Carpentry. The wood's own name is the material code, as in smithing. The
    # cnr_m_le_*/cnr_m_ta_* tags name the wood the player sees, but the binding lives
    # in carpinteria.json and must never be re-derived from a tag.
    for row in carpentry_json:
        add(2, row["madera"], row["madera"], row["tier"])

    # Jewelry is gems and nothing else. It used to carry the fifteen smithing
    # metals as materials too, for thirty recipes that turned nuggets into the
    # same plain ring; the smith now forges the four blanks that exist, so a
    # jewellery recipe is always identified by its stone.
    # The tier is authored per gem in joyeria.json, not derived from position:
    # it is what decides which metal the gem is set into, and the mix is
    # deliberate so no single tier grants a whole family of properties.
    for row in jewelry_json:
        add(5, row["tag"], row["gema"], row["tier"])

    return materials, by_key, leather_row_to_material


def generate_seed(
    materials: Sequence[Material],
    blueprints_by_tag: Dict[str, Blueprint],
    module_names: Dict[str, str],
) -> str:
    lines = [
        "-- CNR catalogue seed: professions, stations, station tools and materials.",
        "-- Generated by migration/build_catalogue.py; do not edit by hand.",
        "--",
        "-- Apply 03_catalogue.sql straight after this file. Reseeding materials",
        "-- and stations invalidates every recipe that points at them, so the",
        "-- catalogue is cleared here in dependency order and rebuilt there.",
        "-- Without this, DELETE FROM cnr_material fails on fk_recipe_material.",
        "",
        "START TRANSACTION;",
        "",
        "DELETE FROM cnr_recipe_property;",
        "DELETE FROM cnr_recipe_component;",
        "DELETE FROM cnr_recipe;",
        "DELETE FROM cnr_category;",
        "DELETE FROM cnr_station_tool;",
        "DELETE FROM cnr_material;",
        "DELETE FROM cnr_station;",
        "DELETE FROM cnr_profession;",
        "",
    ]
    for row in PROFESSIONS:
        lines.append(
            "INSERT INTO cnr_profession "
            "(profession_id,code,display_name,skill_index,ability_1,ability_2,id_block) "
            f"VALUES ({','.join(sql_value(value) for value in row)});"
        )
    lines.append("")
    for station in STATIONS:
        lines.append(
            "INSERT INTO cnr_station "
            "(tag,profession_id,display_name,produces,anim_script) VALUES "
            f"({sql_value(station.tag)},{station.profession_id},{sql_value(station.display_name)},"
            f"{sql_value(station.output_kind)},{sql_value(station.animation)});"
        )
    lines.append("")
    for row in STATION_TOOLS:
        station_tag, tool_tag, access_mode, breakage, sort_order = row[:5]
        if len(row) > 5 and row[5]:
            # Categories do not exist yet in this file; a tool scoped to one is
            # written by the catalogue, after they have been created.
            continue
        tool_blueprint = blueprints_by_tag.get(normalize(tool_tag))
        tool_name = tool_blueprint.name if tool_blueprint else module_names.get(tool_tag)
        lines.append(
            "INSERT INTO cnr_station_tool "
            "(station_id,tool_tag,display_name,access_mode,breakage_chance,sort_order) "
            f"SELECT station_id,{sql_value(tool_tag)},{sql_value(tool_name)},"
            f"{sql_value(access_mode)},{breakage},{sort_order} "
            f"FROM cnr_station WHERE tag={sql_value(station_tag)};"
        )
    lines.append("")
    for material in materials:
        lines.append(
            "INSERT INTO cnr_material "
            "(profession_id,code,display_name,tier,sort_order,enabled) VALUES "
            f"({material.profession_id},{sql_value(material.code)},{sql_value(material.display_name)},"
            f"{material.tier},{material.sort_order},1);"
        )
    lines.append("")
    lines.append("COMMIT;")
    return "\n".join(lines) + "\n"


def write_or_check(path: Path, content: str, check_only: bool) -> None:
    if check_only:
        current = path.read_text(encoding="utf-8") if path.exists() else ""
        if current != content:
            raise ValueError(f"{path.relative_to(ROOT)} is stale; regenerate the catalogue")
        return
    path.write_text(content, encoding="utf-8", newline="\n")


# -----------------------------------------------------------------------------
#                        Catalogue regression guard
# -----------------------------------------------------------------------------
#
# The recurring failure of this generator has never been a bad number; it has
# been a recipe that quietly stopped existing, or one whose components or
# blueprint changed under a rewrite meant for something else. Adding the
# forty-five alchemy recipes on 2026-08-26 renumbered 448 recipe_ids and 172
# public_ids, and nothing in the build could say whether anything had been lost
# in the process - it had to be proven afterwards by hand, again.
#
# So the build proves it itself now. The last committed 03_catalogue.sql is the
# accepted state; every generated catalogue is compared against it, recipe by
# recipe, keyed by what identifies a recipe to a player rather than by any row
# id. Numbers that the progression owns - recipe_id, public_id, tier, min_level,
# dc, xp_award, gold_value - are free to move. Losing a recipe, or changing the
# blueprint, output tag, quantity, menu category, components or properties of
# one that already exists, is a build error.
#
# When such a change is the point of the work, --accept-recipe-changes says so
# out loud and prints exactly what is being accepted.
IDENTITY_FIELDS = ("base_resref", "output_tag", "output_qty", "category")


def _sql_rows(text: str, table: str) -> List[Dict[str, str]]:
    """Read back the INSERT ... VALUES rows this generator writes."""
    header = re.search(rf"INSERT INTO {re.escape(table)} \((.*?)\) VALUES", text)
    if not header:
        return []
    columns = header.group(1).split(",")
    rows = []
    for body in re.findall(rf"INSERT INTO {re.escape(table)} \(.*?\) VALUES \((.*?)\);", text):
        values = next(csv.reader([body], quotechar="'", skipinitialspace=True))
        rows.append(dict(zip(columns, [value.strip() for value in values])))
    return rows


def catalogue_fingerprint(text: str) -> Dict[Tuple[str, str], dict]:
    """Describe every recipe in a catalogue by what a player would recognise.

    The key is the displayed name plus the blueprint it creates, which survives
    any renumbering. Category ids move when a station gains a submenu, so the
    category is carried by name.
    """
    categories = {}
    for match in re.finditer(
        r"INSERT INTO cnr_category \(category_id,[^)]*\) SELECT (\d+),[^,]*,[^,]*,"
        r"('(?:[^']|'')*'),",
        text,
    ):
        categories[match.group(1)] = match.group(2)

    components = defaultdict(list)
    for row in _sql_rows(text, "cnr_recipe_component"):
        components[row["recipe_id"]].append(
            (row["component_tag"], row["qty"], row["retain_on_fail"], row["retain_on_success"])
        )
    properties = defaultdict(list)
    for row in _sql_rows(text, "cnr_recipe_property"):
        properties[row["recipe_id"]].append(
            (row["property_type"], row["subtype"], row["value1"], row["value2"])
        )

    fingerprint: Dict[Tuple[str, str], dict] = {}
    for row in _sql_rows(text, "cnr_recipe"):
        key = (row["display_name"], row["base_resref"])
        if key in fingerprint:
            raise ValueError(
                f"Two recipes share name and blueprint: {key}; the regression "
                "guard cannot tell them apart"
            )
        fingerprint[key] = {
            "base_resref": row["base_resref"],
            "output_tag": row["output_tag"],
            "output_qty": row["output_qty"],
            "category": categories.get(row["category_id"], row["category_id"]),
            "components": sorted(components[row["recipe_id"]]),
            "properties": sorted(properties[row["recipe_id"]]),
        }
    return fingerprint


def accepted_catalogue() -> Optional[str]:
    """The last committed catalogue, or None when there is nothing to compare."""
    try:
        result = subprocess.run(
            ["git", "show", f"HEAD:{CATALOGUE_PATH.relative_to(ROOT).as_posix()}"],
            cwd=ROOT,
            capture_output=True,
            text=True,
        )
    except OSError:
        return None
    return result.stdout if result.returncode == 0 and result.stdout else None


def verify_no_recipe_regression(catalogue_sql: str, accept: bool) -> None:
    baseline = accepted_catalogue()
    if baseline is None:
        print("regression guard : skipped, no committed catalogue to compare against")
        return

    old = catalogue_fingerprint(baseline)
    new = catalogue_fingerprint(catalogue_sql)

    problems: List[str] = []
    for key in sorted(set(old) - set(new)):
        problems.append(f"lost recipe {key[0]!r} ({key[1]})")
    for key in sorted(set(old) & set(new)):
        before, after = old[key], new[key]
        for field in IDENTITY_FIELDS:
            if before[field] != after[field]:
                problems.append(
                    f"{key[0]!r} changed {field}: {before[field]} -> {after[field]}"
                )
        if before["components"] != after["components"]:
            problems.append(
                f"{key[0]!r} changed components: {before['components']} -> {after['components']}"
            )
        if before["properties"] != after["properties"]:
            # Row counts alone say nothing when a value moved rather than a row
            # appearing, which is the common case: the mithril helmet went from
            # 10% to 15% slashing and read as "2 rows -> 2 rows".
            gone = [row for row in before["properties"] if row not in after["properties"]]
            new_rows = [row for row in after["properties"] if row not in before["properties"]]
            problems.append(
                f"{key[0]!r} changed properties: {gone or 'nothing'} -> {new_rows or 'nothing'}"
            )

    gained = len(set(new) - set(old))
    if not problems:
        print(f"regression guard : {len(old)} recipes intact, {gained} added")
        return

    report = "\n".join("  - " + problem for problem in problems[:40])
    if len(problems) > 40:
        report += f"\n  - ... and {len(problems) - 40} more"
    if accept:
        print(f"regression guard : ACCEPTED {len(problems)} change(s) to existing recipes")
        print(report)
        return
    raise ValueError(
        f"{len(problems)} existing recipe(s) would be lost or altered:\n{report}\n"
        "  Rerun with --accept-recipe-changes when this is the point of the work."
    )


def _read_gff(path: Path) -> dict:
    for encoding in ("utf-8", "cp1252"):
        try:
            return load_json(path, encoding)
        except (UnicodeDecodeError, json.JSONDecodeError):
            continue
    raise ValueError(f"{path.relative_to(ROOT)} is not readable GFF JSON")


def _strip_nss_comments(text: str) -> str:
    text = re.sub(r"/\*.*?\*/", "", text, flags=re.S)
    return re.sub(r"//[^\n]*", "", text)


_CNR_MATERIAL_VALUE = re.compile(
    r'"Name":\s*\{\s*"type":\s*"cexostring",\s*"value":\s*"CNR_MATERIAL"\s*\},\s*'
    r'"Type":\s*\{[^}]*\},\s*"Value":\s*\{\s*"type":\s*"cexostring",\s*"value":\s*"([^"]*)"',
    re.S,
)
_TEMPLATE_RESREF = re.compile(r'"TemplateResRef":\s*\{\s*"type":\s*"resref",\s*"value":\s*"([^"]*)"')
_PALETTE_RESREF = re.compile(r'"RESREF":\s*\{\s*"type":\s*"resref",\s*"value":\s*"([^"]+)"')


def verify_naming_contract(recipe_rows: Sequence[Recipe]) -> None:
    """Refuse a tree that breaks the CNR naming contract.

    Slices 2 to 4 of the naming normalisation each found a rule that kept
    working after a rename and silently stopped matching: a generator filter on
    "bru_", a script concatenating "cnr_cristal" + n, a Python
    row["metal"] + "_aro". Names alone are not enough; what names them is
    checked too.
    """
    errors: List[str] = []

    items: Dict[str, str] = {}      # resref -> tag, CNR items
    item_tags: set = set()
    for path in sorted(CNR_UTI.glob("*.uti.json")):
        data = _read_gff(path)
        stem = path.name[: -len(".uti.json")]
        resref = data.get("TemplateResRef", {}).get("value", "")
        tag = data.get("Tag", {}).get("value", "")
        items[stem.lower()] = tag
        item_tags.add(tag)
        if resref != ITEM_TEMPLATE_ALIASES.get(stem, stem):
            errors.append(f"item {stem}: TemplateResRef {resref!r} differs from its file name")
        if len(resref) > RESREF_MAX:
            errors.append(f"item {resref}: longer than {RESREF_MAX} characters")
        if resref.startswith(POTION_PREFIX):
            continue
        if not resref.startswith("cnr_"):
            errors.append(f"item {resref}: CNR items are named cnr_*")
        expected = SHARED_TOOL_TAGS.get(resref, resref)
        if tag != expected:
            errors.append(f"item {resref}: tag {tag!r} should be {expected!r}")
    for resref in SHARED_TOOL_TAGS:
        if resref not in items:
            errors.append(f"shared-tool exception {resref} names no blueprint")

    placeables: Dict[str, str] = {}
    for path in sorted(CNR_UTP.glob("*.utp.json")):
        data = _read_gff(path)
        stem = path.name[: -len(".utp.json")]
        resref = data.get("TemplateResRef", {}).get("value", "")
        tag = data.get("Tag", {}).get("value", "")
        placeables[resref.lower()] = tag
        # A cnr_* placeable is named exactly as its file. The engine's CamelCase
        # stations cannot be: unpacking writes file names in lower case, so their
        # file name is the resref lower-cased.
        expected_stem = resref.lower() if ENGINE_PLACEABLE.match(resref) else resref
        if stem != expected_stem:
            errors.append(f"placeable {stem}: TemplateResRef {resref!r} does not match its file name")
        if len(resref) > RESREF_MAX:
            errors.append(f"placeable {resref}: longer than {RESREF_MAX} characters")
        if tag != resref:
            errors.append(f"placeable {resref}: tag {tag!r} should equal its resref")
        if not (resref.startswith("cnr_") or ENGINE_PLACEABLE.match(resref)):
            errors.append(f"placeable {resref}: CNR placeables are named cnr_* or cnr + CamelCase")

    # Location: nothing of the trade's is left in src/shared. The potion prefix
    # counts for items only: sute_her_mesamez is a static decoration.
    for folder, prefixes in ((SHARED_UTI, ("cnr_", POTION_PREFIX)), (SHARED_UTP, ("cnr_",))):
        for path in sorted(folder.glob("*.json")):
            match = _TEMPLATE_RESREF.search(path.read_bytes().decode("latin-1"))
            names = {path.name.split(".")[0].lower(), (match.group(1) if match else "").lower()}
            if any(name.startswith(prefixes) for name in names):
                errors.append(f"{path.relative_to(ROOT)}: CNR blueprints live under src/cnr")

    # What the catalogue, the stations, the store and the nodes name must exist there.
    def need_resref(value: Optional[str], where: str) -> None:
        if value and value.lower() not in items:
            errors.append(f"{where} names resref {value!r}, which is no item under src/cnr/uti")

    def need_tag(value: Optional[str], where: str) -> None:
        if value and value not in item_tags:
            errors.append(f"{where} names tag {value!r}, which no item under src/cnr/uti carries")

    for recipe in recipe_rows:
        where = f"recipe {recipe.display_name!r}"
        need_resref(recipe.base_resref, where)
        need_resref(recipe.source.extra_resref, where)
        for component in recipe.source.components:
            need_tag(component.tag, where)
    for row in STATION_TOOLS:
        need_tag(row[1], f"station tool of {row[0]}")
    store_text = STORE_LIST.read_bytes().decode("latin-1")
    for resref in re.findall(r'"sTagIngOficio", \d+, "([^"]+)"', store_text):
        need_resref(resref, "material store")
    node_sources = sorted(CNR_UTP.glob("*.utp.json")) + sorted(MODULE_GIT.glob("*.git.json"))
    for path in node_sources:
        text = path.read_bytes().decode("latin-1")
        for value in _CNR_MATERIAL_VALUE.findall(text):
            for material in filter(None, value.split(";")):
                if material.lower() not in items and material not in item_tags:
                    errors.append(f"{path.relative_to(ROOT)}: CNR_MATERIAL {material!r} names no CNR item")

    # Palette: every CNR blueprint can be found, and no CNR entry points at nothing.
    item_palette = {r.lower() for r in _PALETTE_RESREF.findall(read_text(ITEM_PALETTE, "utf-8"))}
    placeable_palette = {r.lower() for r in _PALETTE_RESREF.findall(read_text(PLACEABLE_PALETTE, "utf-8"))}
    for resref in sorted(set(items) - item_palette):
        errors.append(f"item {resref}: no entry in the item palette")
    for resref in sorted(set(placeables) - placeable_palette):
        errors.append(f"placeable {resref}: no entry in the placeable palette")
    for resref in sorted(r for r in item_palette if r.startswith(("cnr_", POTION_PREFIX)) and r not in items):
        errors.append(f"item palette entry {resref!r} names no CNR item")

    # Scripts: a name built by concatenation must still prefix something, and a
    # literal in an item namespace must still name something.
    all_resrefs = set(items) | set(placeables)
    # Every script under src, not only */nss: the NUI scripts live in src/cnr/nui.
    for path in sorted((ROOT / "src").rglob("*.nss")):
        if path.name == STORE_KEY_MIGRATION:
            continue
        code = _strip_nss_comments(path.read_bytes().decode("latin-1"))
        for prefix in re.findall(r'"((?:cnr_|sute_her_)[A-Za-z0-9_]*)"\s*\+', code):
            if not any(r.startswith(prefix.lower()) for r in all_resrefs):
                errors.append(f'{path.relative_to(ROOT)}: "{prefix}" + ... builds no existing blueprint name')
        for literal in re.findall(r'"([^"\n]*)"', code):
            if ITEM_NAMESPACE.match(literal) and literal.lower() not in items and literal not in item_tags:
                errors.append(f"{path.relative_to(ROOT)}: {literal!r} names no CNR item")

    # The generators: a family recognised by prefix, or named literally. Only
    # real string tokens are read, so comments cannot trip it; a literal ending
    # in "_" is a prefix and must prefix something.
    for script in (ROOT / "migration" / "build_catalogue.py", ROOT / "migration" / "build_arcane.py"):
        with script.open(encoding="utf-8") as handle:
            strings = {
                ast.literal_eval(token.string)
                for token in tokenize.generate_tokens(handle.readline)
                if token.type == tokenize.STRING and not token.string.lstrip("rRbBuU").startswith(("f", "F"))
            }
        for literal in sorted(value for value in strings if isinstance(value, str)):
            if literal.startswith(("cnr_", POTION_PREFIX)) and literal.endswith("_"):
                if not any(r.startswith(literal.lower()) for r in all_resrefs):
                    errors.append(f"{script.name}: prefix {literal!r} matches no blueprint")
            elif ITEM_NAMESPACE.match(literal) and literal not in items and literal not in item_tags:
                errors.append(f"{script.name}: {literal!r} names no CNR item")

    if errors:
        shown = "\n  - ".join(errors[:40])
        more = f"\n  ... and {len(errors) - 40} more" if len(errors) > 40 else ""
        raise ValueError(f"CNR naming contract broken ({len(errors)}):\n  - {shown}{more}")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--check",
        action="store_true",
        help="validate sources and fail when generated SQL differs without writing files",
    )
    parser.add_argument(
        "--accept-recipe-changes",
        action="store_true",
        help="allow existing recipes to be lost or altered, and print what changed",
    )
    args = parser.parse_args()

    smith_json = load_json(DOCS / "herreria.json")
    jewelry_json = load_json(DOCS / "joyeria.json")
    leather_json = load_json(DOCS / "peleteria.json")
    alchemy_json = load_json(DOCS / "alquimia.json")
    carpentry_json = load_json(DOCS / "carpinteria.json")
    carpentry_by_wood = {row["madera"]: row for row in carpentry_json}
    validate_design_sources(smith_json, jewelry_json, leather_json, alchemy_json)
    blueprints_by_tag, blueprints_by_resref = load_blueprints()
    module_tags = load_module_tags()
    module_names = load_module_names()

    # cnr_sql_init.nss was emptied once the catalogue moved to the database;
    # its statements live on as an archive, which is UTF-8, not cp1252.
    legacy_sql = read_text(LEGACY_SEED_PATH, encoding="utf-8")
    metadata_rows = parse_sql_rows(legacy_sql, "recipe_metadata")
    metadata = {
        row[0]: dict(zip(("material", "type", "gem", "base", "display", "tag"), row[1:7]))
        for row in metadata_rows
        if len(row) >= 7
    }
    metadata_by_display = {
        normalize(row[5]): dict(
            recipe_id=row[0],
            material=row[1],
            type=row[2],
            gem=row[3],
            base=row[4],
            display=row[5],
            tag=row[6],
        )
        for row in metadata_rows
        if len(row) >= 7 and row[5]
    }
    properties: Dict[Tuple[str, str, str], List[Tuple[str, int, int, int]]] = defaultdict(list)
    for row in parse_sql_rows(legacy_sql, "material_properties"):
        if len(row) >= 7 and row[0] != "Gem":
            properties[(row[0], row[1], row[2])].append(
                (row[3], int(row[4]), int(row[5]), int(row[6]))
            )
    # Gem properties come from joyeria.json, not from the legacy archive. The
    # archive had eight of the ten spellcasting classes wrong - cleric and druid
    # swapped, sorcerer landing on paladin, wizard on fighter, which is not a
    # caster at all and so granted nothing.
    for row in jewelry_json:
        for entry in row.get("propiedades", []):
            for item_type in ("Anillo", "Colgante"):
                properties[("Gem", item_type, row["tag"])].append(
                    (entry["type"], int(entry["subtype"]),
                     int(entry["value1"]), int(entry["value2"]))
                )

    property_materials = list(OrderedDict((key[0], None) for key in properties if key[0]))
    property_types = {row[0] for rows in properties.values() for row in rows}
    # Two consumers carry the same if-chain: cnr_i_prop.nss, which the engine
    # actually calls from cnr_i_craft, and the standalone cnr_apply_prop.nss.
    # Validating only one lets them drift, so both are read and required to
    # agree - a type handled by just one is a bug in whichever lacks it.
    def consumer_branches(name: str) -> Dict[str, str]:
        """Map each handled property type to its normalized branch body.

        Comparing the names alone would let the two files handle the same type
        with different constructors, which is the drift that actually breaks
        items, so the body is compared too.
        """
        text = read_text(NSS / name)
        starts = [
            (match.group(1), match.end())
            for match in re.finditer(r'sType\s*==\s*"([^"]+)"\s*\)', text)
        ]
        branches: Dict[str, str] = {}
        for index, (property_type, begin) in enumerate(starts):
            end = starts[index + 1][1] if index + 1 < len(starts) else len(text)
            body = text[begin:end]
            # The last branch would otherwise run to the end of the file and
            # drag the chain's fallback and whatever follows it into the
            # comparison. That is not a branch body, and the two consumers are
            # allowed to differ there: cnr_i_prop is a function that reports
            # whether the property landed, cnr_apply_prop is a void main. Cut at
            # the fallback both of them carry.
            sentinel = body.find("propertyType sin soporte")
            if sentinel != -1:
                body = body[:body.rfind("else", 0, sentinel)]
            # Drop the trailing "else if (sType" of the next branch, then
            # normalize spacing so reformatting is not mistaken for a change:
            # collapse runs of whitespace, then strip it around punctuation, so
            # "f( x )" and "f(x)" compare equal.
            body = re.sub(r'else\s+if\s*\(\s*$', "", body)
            body = " ".join(body.split())
            body = re.sub(r'\s*([(),;=<>!+*/{}-])\s*', r'\1', body)
            branches[property_type] = body
        return branches

    engine_branches = consumer_branches("cnr_i_prop.nss")
    standalone_branches = consumer_branches("cnr_apply_prop.nss")
    missing = sorted(set(engine_branches) ^ set(standalone_branches))
    if missing:
        raise ValueError(
            "cnr_i_prop.nss and cnr_apply_prop.nss disagree on: " + ", ".join(missing)
        )
    differing = sorted(
        property_type
        for property_type, body in engine_branches.items()
        if standalone_branches[property_type] != body
    )
    if differing:
        raise ValueError(
            "cnr_i_prop.nss and cnr_apply_prop.nss implement these differently: "
            + ", ".join(differing)
        )
    supported_types = set(engine_branches)
    unsupported_types = sorted(property_types - supported_types)
    if unsupported_types:
        raise ValueError(f"Property consumer does not handle: {', '.join(unsupported_types)}")

    category_sql, source_recipes, station_counts = parse_station_recipes()
    if station_counts != EXPECTED_RECIPE_COUNTS:
        raise ValueError(f"Recipe inventory changed: {dict(station_counts)}")
    expected_total = sum(EXPECTED_RECIPE_COUNTS.values())
    if len(source_recipes) != expected_total:
        raise ValueError(
            f"Expected {expected_total} recipes, found {len(source_recipes)}"
        )
    # A station that outgrows its block would start handing out numbers that
    # belong to the next station of the same profession, and the unique index on
    # public_id would reject the catalogue at apply time - or worse, the two
    # blocks would merely swap owners. Fail here instead, where the fix is to
    # raise the next base once and say so.
    if set(PUBLIC_ID_BASES) != {station.source for station in STATIONS}:
        raise ValueError("PUBLIC_ID_BASES and STATIONS disagree on the station list")
    stations_by_source = {station.source: station for station in STATIONS}
    for source, base in PUBLIC_ID_BASES.items():
        profession_id = stations_by_source[source].profession_id
        if base // 1000 != profession_id:
            raise ValueError(
                f"{source} has base {base}, outside profession {profession_id}"
            )
    ordered_bases = sorted(PUBLIC_ID_BASES.items(), key=lambda item: item[1])
    for index, (source, base) in enumerate(ordered_bases):
        last = base + station_counts[source]
        following = ordered_bases[index + 1] if index + 1 < len(ordered_bases) else None
        # A base is never handed out: the first id of a station is base + 1, so
        # reaching the next base exactly is still legal.
        if following and last > following[1]:
            raise ValueError(
                f"{source} reaches public id {last}, which belongs to "
                f"{following[0]} from {following[1] + 1}"
            )
    unsupported_pre_craft = sorted(
        {
            source.pre_craft_script
            for source in source_recipes
            if source.pre_craft_script not in (None, "cnr_sql_c_item")
        }
    )
    if unsupported_pre_craft:
        raise ValueError(
            "Legacy recipes contain pre-craft hooks not replaced by the generic engine: "
            + ", ".join(unsupported_pre_craft)
        )
    forge_sources = [
        source for source in source_recipes if source.station.source == "cnrforgepublic"
    ]
    for source in forge_sources:
        component_quantities = {
            component.tag: component.quantity for component in source.components
        }
        if component_quantities.get("cnr_m_pe_carbon") != 1:
            raise ValueError(f"Forge recipe {source.display_name!r} must consume one coal nugget")
        metal_quantities = [
            quantity
            for tag, quantity in component_quantities.items()
            # Coal is the fuel and the smith's oil is a reagent; neither is the
            # metal this guard counts.
            if tag not in ("cnr_m_pe_carbon", "cnr_p_aceite")
        ]
        # The forge does two things. It smelts three nuggets into an ingot, which
        # is every recipe here bar one, and it alloys one nugget into another -
        # steel, the only metal with no vein in the map. The two shapes are
        # guarded separately rather than by loosening the first, so a smelting
        # recipe that lost two of its nuggets is still caught.
        if (source.legacy_code or "").lower().startswith("cnr_m_pe_"):
            if metal_quantities != [1]:
                raise ValueError(
                    f"Forge alloy {source.display_name!r} must consume one metal nugget"
                )
        elif metal_quantities != [3]:
            raise ValueError(
                f"Forge recipe {source.display_name!r} must consume three metal nuggets"
            )

    materials, materials_by_key, leather_materials = build_materials(
        source_recipes,
        smith_json,
        leather_json,
        jewelry_json,
        carpentry_json,
        property_materials,
    )
    seed_sql = generate_seed(materials, blueprints_by_tag, module_names)

    alchemy_by_name = {normalize(row["resultado"]): row for row in alchemy_json}
    poison_rows = load_csv(DOCS / "Oficios Basicos - Etapa 2 - 2025 - Venenos.csv")
    poison_handling_by_name = {
        normalize(row["Resultado"]): int(row["Manejo"])
        for row in poison_rows
    }
    alchemy_design_order = {
        normalize(row["resultado"]): index for index, row in enumerate(alchemy_json)
    }
    selected_alchemy_names = [
        normalize(source.display_name)
        for source in source_recipes
        if source.station.source == "cnralchemytable"
    ]
    if len(set(selected_alchemy_names)) != len(selected_alchemy_names):
        raise ValueError("Selected alchemy recipe names must be unique")
    ordered_alchemy_names = sorted(
        selected_alchemy_names,
        key=lambda name: (
            alchemy_authored_difficulty(
                alchemy_by_name[name], poison_handling_by_name
            ),
            alchemy_design_order[name],
        ),
    )
    alchemy_progression = {
        name: (position, len(ordered_alchemy_names))
        for position, name in enumerate(ordered_alchemy_names, 1)
    }
    jewelry_by_name = {normalize(row["gema"]): row for row in jewelry_json}
    jewelry_by_tag = {row["tag"]: row for row in jewelry_json}
    # A setting recipe consumes the cut gem, not the raw stone, but the material
    # a jewellery recipe belongs to is the stone either way.
    jewelry_raw_by_cut = {row["tallada"]: row["tag"] for row in jewelry_json}
    leather_by_material = {
        leather_materials[normalize(row["piel"])]: row for row in leather_json
    }
    leather_component_material: Dict[str, str] = {}
    for source in source_recipes:
        if source.station.source != "cnrcuringtub":
            continue
        comparable_name = re.sub(
            r"^Cuero curtido de\s+", "Cuero de ", source.display_name, flags=re.IGNORECASE
        )
        material = material_from_name(comparable_name, leather_by_material.keys())
        if material:
            leather_component_material[source.legacy_code] = material

    local_alchemy_bases = []
    for row in alchemy_json:
        resref, local = resolve_resref(row["sPocionBase"], blueprints_by_tag, blueprints_by_resref)
        if not local:
            raise ValueError(f"Alchemy base {row['sPocionBase']!r} has no local UTI blueprint")
        local_alchemy_bases.append(resref)
    for row in jewelry_json:
        if normalize(row["tag"]) not in blueprints_by_tag:
            raise ValueError(f"Jewelry tag {row['tag']!r} has no local UTI blueprint")
        # The whole chain is named here, so a missing blueprint is caught once
        # rather than 84 times as an unresolvable recipe.
        blank = JEWELRY_BLANK_METAL[row["metal"]]
        chain = [row["tallada"], row["anillo"], row["colgante"],
                 "cnr_p_ar_" + blank, "cnr_p_ca_" + blank]
        if row.get("arenilla"):
            chain.append(row["arenilla"])
        for resref in chain:
            if normalize(resref) not in blueprints_by_resref:
                raise ValueError(
                    f"Gem {row['tag']!r} names {resref!r}, which has no local UTI blueprint"
                )

    recipe_rows: List[Recipe] = []
    component_sql: List[str] = []
    property_sql: List[str] = []
    recipe_property_counts: Dict[int, int] = defaultdict(int)
    public_id_by_station: Dict[str, int] = {}
    property_id = 0
    external_resrefs = set()
    mapping_counts: Dict[str, int] = defaultdict(int)

    for source in source_recipes:
        for component in source.components:
            if component.tag.startswith("cnr_t_mo_") and component.tag not in module_tags:
                raise ValueError(
                    f"Recipe {source.display_name!r} references mold tag "
                    f"{component.tag!r}, which is absent from module area inventories"
                )

    smith_names = [material.code for material in materials if material.profession_id == 1]
    jewelry_gem_names = [
        material.code
        for material in materials
        if material.profession_id == 5 and material.code.startswith("cnr_g_")
    ]
    # This list orders the jewellery recipes by gem. Filtered by a name prefix,
    # it went silently empty when the rough gems were renamed from bru_* to
    # cnr_g_*, and every jewellery recipe fell back to its position on the bench
    # for tier, level, DC and XP: a cut emerald went from level 16 to level 4.
    # An empty list is not a valid state, so it is not allowed to be one.
    if len(jewelry_gem_names) != 28:
        raise ValueError(
            f"Expected 28 jewellery gem materials named cnr_g_*, found {len(jewelry_gem_names)}"
        )
    leather_names = [material.code for material in materials if material.profession_id == 3]
    carpentry_names = [material.code for material in materials if material.profession_id == 2]
    sewing_names = [material.code for material in materials if material.profession_id == 7]
    station_recipe_counts: Dict[str, int] = defaultdict(int)
    for source in source_recipes:
        station_recipe_counts[source.station.source] += 1
    station_recipe_positions: Dict[str, int] = defaultdict(int)

    for recipe_id, source in enumerate(source_recipes, 1):
        station_recipe_positions[source.station.source] += 1
        profession_id = source.station.profession_id
        station_source = source.station.source
        public_id_by_station[station_source] = public_id_by_station.get(
            station_source, PUBLIC_ID_BASES[station_source]
        ) + 1
        public_id = public_id_by_station[station_source]

        md = metadata.get(source.legacy_code) or metadata_by_display.get(normalize(source.display_name))
        marks_socketed = 0
        material_code: Optional[str] = None
        property_key: Optional[Tuple[str, str, str]] = None
        output_tag: Optional[str] = None
        display_name = source.display_name
        local_output = False

        if profession_id == 5:
            # Jewellery is identified by its stone at every step: cutting
            # consumes the raw stone, setting consumes the cut gem and a blank
            # the smith forged. Both name their result outright, because every
            # one of them is a distinct local blueprint.
            gem_tag = next(
                (
                    jewelry_raw_by_cut.get(component.tag, component.tag)
                    for component in source.components
                    if component.tag in jewelry_by_tag
                    or component.tag in jewelry_raw_by_cut
                ),
                None,
            )
            if not source.literal_resref:
                raise ValueError(
                    f"Jewelry recipe {source.display_name!r} must state its base_resref"
                )
            # A blank has no stone in it yet: it belongs to no gem material and
            # takes its tier from the recipe's own level, like any other item.
            gem = jewelry_by_tag[gem_tag] if gem_tag else None
            material_code = gem_tag
            base_resref = source.literal_resref
            local_output = normalize(base_resref) in blueprints_by_resref
            # Only the set piece carries the gem's properties. The cut gem is a
            # material: it grants nothing until it is set into a blank.
            if gem and base_resref == gem["anillo"]:
                property_key = ("Gem", "Anillo", gem_tag)
            elif gem and base_resref == gem["colgante"]:
                property_key = ("Gem", "Colgante", gem_tag)
            if property_key:
                # A set piece is finished. Nothing may take it apart or set it
                # a second time, so the engine marks it on creation.
                marks_socketed = 1
                mapping_counts["jewelry_json"] += 1
            elif gem:
                mapping_counts["jewelry_cut"] += 1
            else:
                mapping_counts["jewelry_blank"] += 1
            tier = (
                materials_by_key[(5, material_code)].tier
                if material_code
                else min(4, max(1, (source.legacy_level - 1) // 5 + 1))
            )
        elif source.literal_resref:
            # Authored recipes may name the output resref outright. Nothing is
            # resolved: PDB carries unique named blueprints that keep a base
            # item's TAG, so resolving "nw_wbwln001" finds "Arco de Anirin" and
            # the recipe would craft that instead of a plain longbow.
            base_resref = source.literal_resref
            local_output = normalize(base_resref) in blueprints_by_resref
            # Stating the resref bypasses resolution, not the final identity:
            # a recipe may still rename the result's tag, as alchemy does for
            # potions. It comes only from an authored metadata tag - legacy_code
            # is an internal recipe key like "recipe_hierro_weapon" and must
            # never end up as an item's tag.
            output_tag = (md["tag"] or None) if md else None
            # Only resolution is bypassed. Material and properties still come
            # from the metadata row when the recipe has one.
            if md:
                material_code = md["material"] or material_code
                if md["material"] and md["type"]:
                    property_key = (md["material"], md["type"], md["gem"])
            if profession_id == 1 and material_code is None:
                material_code = material_from_name(display_name, smith_names)
            if profession_id == 2:
                material_code = material_from_name(display_name, carpentry_names)
            elif profession_id in (3, 7):
                # Leatherworking and tailoring share peleteria.json. Only the
                # resref is stated here; the item type and its property row are
                # still derived exactly as the leather branch does, or the
                # moved recipes would silently lose their properties.
                nombres = leather_names if profession_id == 3 else sewing_names
                material_code = next(
                    (
                        leather_component_material[component.tag]
                        for component in source.components
                        if component.tag in leather_component_material
                    ),
                    None,
                ) or material_from_name(source.display_name, nombres)
                item_type = leather_type(source.category_name, source.legacy_code)
                if item_type and material_code:
                    property_key = (material_code, item_type, "")
                    mapping_counts["leather_json"] += 1
            tier = (
                materials_by_key[(profession_id, material_code)].tier
                if material_code
                else min(4, max(1, (source.legacy_level - 1) // 5 + 1))
            )
            mapping_counts["literal_resref"] += 1
        elif profession_id == 4 and source.station.source == "cnralchemytable":
            alchemy = alchemy_by_name.get(normalize(source.display_name))
            if not alchemy:
                raise ValueError(f"Alchemy recipe {source.display_name!r} is absent from alquimia.json")
            base_resref, local_output = resolve_resref(
                alchemy["sPocionBase"], blueprints_by_tag, blueprints_by_resref
            )
            output_tag = alchemy["sCustomTag"]
            display_name = alchemy["resultado"]
            mapping_counts["alchemy_json"] += 1
        elif profession_id == 3 and source.station.source == "cnrcuringtub":
            comparable_name = re.sub(
                r"^Cuero curtido de\s+", "Cuero de ", display_name, flags=re.IGNORECASE
            )
            material_code = material_from_name(comparable_name, leather_names)
            if material_code is None:
                raise ValueError(f"Curing recipe {display_name!r} has no material")
            base_resref, local_output = resolve_resref(
                source.legacy_code, blueprints_by_tag, blueprints_by_resref
            )
            tier = materials_by_key[(3, material_code)].tier
            mapping_counts["curing_material"] += 1
        elif profession_id == 3 and source.station.source == "cnrtailorstable":
            item_type = leather_type(source.category_name, source.legacy_code)
            material_code = next(
                (
                    leather_component_material[component.tag]
                    for component in source.components
                    if component.tag in leather_component_material
                ),
                None,
            ) or material_from_name(source.display_name, leather_names)
            if item_type and material_code:
                leather_row = leather_by_material[material_code]
                base_identifier = leather_base_identifier(leather_row, item_type)
                base_resref, local_output = resolve_resref(
                    base_identifier, blueprints_by_tag, blueprints_by_resref
                )
                property_key = (material_code, item_type, "")
                mapping_counts["leather_json"] += 1
            else:
                base_resref, local_output = resolve_resref(
                    source.legacy_code, blueprints_by_tag, blueprints_by_resref
                )
                mapping_counts["direct_legacy"] += 1
            tier = materials_by_key[(3, material_code)].tier if material_code else min(
                4, max(1, (source.legacy_level - 1) // 5 + 1)
            )
        elif md:
            base_resref, local_output = resolve_resref(
                md["base"], blueprints_by_tag, blueprints_by_resref
            )
            output_tag = md["tag"] or None
            display_name = md["display"] or display_name
            material_code = md["material"] or material_from_name(display_name, smith_names)
            if md["material"] and md["type"]:
                property_key = (md["material"], md["type"], md["gem"])
            tier = materials_by_key[(profession_id, material_code)].tier if material_code else min(
                4, max(1, (source.legacy_level - 1) // 5 + 1)
            )
            mapping_counts["legacy_metadata"] += 1
        else:
            base_resref, local_output = resolve_resref(
                source.legacy_code, blueprints_by_tag, blueprints_by_resref
            )
            if profession_id == 1:
                material_code = material_from_name(display_name, smith_names)
                if (
                    source.station.source == "cnrforgepublic"
                    and source.legacy_code == "cnr_m_li_enardec"
                ):
                    material_code = "Hierro Enardecido"
            elif profession_id == 2:
                material_code = material_from_name(display_name, carpentry_names)
            elif profession_id == 3:
                material_code = material_from_name(display_name, leather_names)
            elif profession_id == 7:
                material_code = material_from_name(display_name, sewing_names)
            tier = materials_by_key[(profession_id, material_code)].tier if material_code else min(
                4, max(1, (source.legacy_level - 1) // 5 + 1)
            )
            mapping_counts["direct_legacy"] += 1

        # Every branch above ends here, whichever way it named the blueprint,
        # so this is the one place where a stock base item becomes ours.
        mapped = apply_cnr_base_item(base_resref)
        if mapped != base_resref:
            base_resref = mapped
            local_output = normalize(base_resref) in blueprints_by_resref

        if not local_output:
            external_resrefs.add(base_resref)
        if not base_resref or len(base_resref) > 16:
            raise ValueError(f"Recipe {source.display_name!r} has invalid resref {base_resref!r}")

        # The second product is looked up here so the recipe list can name it.
        # An extra with no local blueprint is a data error, not a fallback: it
        # would print a resref at the player, which is what display names exist
        # to prevent.
        extra_name: Optional[str] = None
        if source.extra_resref:
            if len(source.extra_resref) > 16 or source.extra_quantity <= 0:
                raise ValueError(
                    f"Recipe {source.display_name!r} has an invalid extra output"
                )
            extra_blueprint = blueprints_by_resref.get(normalize(source.extra_resref))
            if not extra_blueprint or not extra_blueprint.name:
                raise ValueError(
                    f"Recipe {source.display_name!r} declares extra output "
                    f"{source.extra_resref!r}, which has no named local blueprint"
                )
            extra_name = extra_blueprint.name
        elif source.extra_quantity:
            raise ValueError(
                f"Recipe {source.display_name!r} states an extra quantity with no resref"
            )
        if output_tag and len(output_tag) > 32:
            raise ValueError(f"Recipe {source.display_name!r} has an overlong output tag")
        if material_code is not None and (profession_id, material_code) not in materials_by_key:
            raise ValueError(
                f"Recipe {source.display_name!r} references missing material {material_code!r}"
            )
        if material_code is not None:
            material_code = materials_by_key[(profession_id, material_code)].code

        progression_values: Sequence[str]
        if profession_id == 1 and material_code is not None:
            progression_values = smith_names
        elif profession_id == 2 and material_code is not None:
            progression_values = carpentry_names
        elif profession_id == 3 and material_code is not None:
            progression_values = leather_names
        elif profession_id == 7 and material_code is not None:
            progression_values = sewing_names
        elif profession_id == 5 and material_code is not None:
            progression_values = jewelry_gem_names
        else:
            progression_values = ()
        # A family filtered by name that matches nothing is not "no progression":
        # it is a rename the filter did not follow (slice 3 emptied the gems).
        if material_code is not None and profession_id in (1, 2, 3, 5, 7) and not progression_values:
            raise ValueError(
                f"Recipe {source.display_name!r} has material {material_code!r} but its "
                f"profession's progression list is empty"
            )

        if profession_id == 4 and source.station.source == "cnralchemytable":
            progression_position, progression_total = alchemy_progression[
                normalize(source.display_name)
            ]
            tier = min(4, ((progression_position - 1) * 4) // progression_total + 1)
        elif progression_values:
            progression_position = progression_values.index(material_code) + 1
            progression_total = len(progression_values)
        else:
            progression_position = station_recipe_positions[source.station.source]
            progression_total = station_recipe_counts[source.station.source]
            tier = min(4, ((progression_position - 1) * 4) // progression_total + 1)

        dc = progression_value(progression_position, progression_total, DC_MIN, DC_MAX)
        gold = dc * GOLD_PER_DC
        if tier == 4:
            dc -= TIER4_DC_RELIEF
        min_level = progression_value(
            progression_position, progression_total, LEVEL_MIN, LEVEL_MAX
        )
        base_xp = progression_value(progression_position, progression_total, XP_MIN, XP_MAX)
        xp_multiplier = MATERIAL_XP_FACTOR if source.station.output_kind == "material" else 1.0
        xp = max(1, int(base_xp * xp_multiplier + 0.5))
        recipe = Recipe(
            recipe_id=recipe_id,
            public_id=public_id,
            source=source,
            material_code=material_code,
            tier=tier,
            min_level=min_level,
            crafted_by=0,   # resolved once every recipe is known
            display_name=display_name,
            base_resref=base_resref,
            output_tag=output_tag,
            dc=dc,
            xp=xp,
            gold=gold,
            enabled=1 if source.enabled else 0,
            extra_name=extra_name,
            marks_socketed=marks_socketed,
        )
        recipe_rows.append(recipe)

        for sort_order, component in enumerate(source.components):
            blueprint = blueprints_by_tag.get(normalize(component.tag))
            component_name = (
                AUTHORED_COMPONENT_NAMES.get(component.tag)
                or (blueprint.name if blueprint else None)
                or module_names.get(component.tag)
            )
            component_sql.append(
                "INSERT INTO cnr_recipe_component "
                "(recipe_id,component_tag,display_name,qty,retain_on_fail,"
                "retain_on_success,sort_order) VALUES "
                f"({recipe_id},{sql_value(component.tag)},{sql_value(component_name)},"
                f"{component.quantity},{component.retain_on_fail},"
                f"{component.retain_on_success},{sort_order});"
            )

        carpentry_rows: List[Tuple[str, int, int, int]] = []
        if source.property_set:
            wood = carpentry_by_wood.get(material_code or "")
            if wood is None:
                raise ValueError(
                    f"Recipe {source.display_name!r} has property_set but no design wood"
                )
            texto = wood["propiedades"].get(source.property_set)
            if not texto:
                raise ValueError(
                    f"Recipe {source.display_name!r} asks for the {source.property_set!r} "
                    f"properties of {material_code!r}, which the design leaves empty"
                )
            for clausula in texto.split(","):
                clausula = clausula.strip()
                if not clausula:
                    continue
                parsed = parse_carpentry_clause(clausula)
                if parsed is None:
                    raise ValueError(
                        f"Recipe {source.display_name!r}: cannot map design clause "
                        f"{clausula!r}"
                    )
                carpentry_rows.extend(parsed)
            for sort_order, (property_type, subtype, value1, value2) in enumerate(carpentry_rows):
                property_id += 1
                recipe_property_counts[recipe_id] += 1
                property_sql.append(
                    "INSERT INTO cnr_recipe_property "
                    "(recipe_property_id,recipe_id,property_type,subtype,value1,value2,sort_order) "
                    f"VALUES ({property_id},{recipe_id},{sql_value(property_type)},"
                    f"{subtype},{value1},{value2},{sort_order});"
                )
            mapping_counts["carpentry_design"] += 1

        if property_key:
            property_rows = properties.get(property_key, [])
            if not property_rows:
                raise ValueError(
                    f"Recipe {source.display_name!r} has no numeric properties for {property_key!r}"
                )
            for sort_order, (property_type, subtype, value1, value2) in enumerate(property_rows):
                property_id += 1
                recipe_property_counts[recipe_id] += 1
                property_sql.append(
                    "INSERT INTO cnr_recipe_property "
                    "(recipe_property_id,recipe_id,property_type,subtype,value1,value2,sort_order) "
                    f"VALUES ({property_id},{recipe_id},{sql_value(property_type)},"
                    f"{subtype},{value1},{value2},{sort_order});"
                )

    if len(recipe_rows) != expected_total:
        raise ValueError(
            f"Generated {len(recipe_rows)} recipes instead of {expected_total}"
        )
    if mapping_counts["alchemy_json"] != EXPECTED_RECIPE_COUNTS["cnralchemytable"]:
        raise ValueError("Not every alchemy recipe was mapped through alquimia.json")
    if mapping_counts["leather_json"] != 100:
        raise ValueError("Not every leather product was mapped through peleteria.json")
    if mapping_counts["legacy_jewelry_without_etapa2_property"] != 0:
        raise ValueError(
            "Every gem recipe must resolve an Etapa-2 property. The legacy "
            "recipes asked for 22 gems no blueprint has; they were rebuilt from "
            "documentation/oficios/joyeria.json, so an unresolved gem now means "
            "a real mistake rather than inherited damage."
        )
    # 381 before the gem recipes were rebuilt from joyeria.json. The 36 extra
    # rows are the 36 gem recipes that used to reference a gem no blueprint had
    # and therefore resolved no property at all.
    # 417 before Carpentry. The 174 extra rows are its 78 bench recipes: the
    # arcos, ballestas and escudos design columns each serve two families, so
    # the seven columns yield more rows than their 54 wood/column cells.
    # 591 before padded armour; its ten recipes share the armadura design row.
    # 609 until Piedra picara stopped being one row: it grants a third and a
    # fourth sphere slot, which is two rows, on the ring and on the necklace.
    # The whip adds none: leather properties are looked up by garment type and
    # a whip is not one, so its ten recipes come out plain. Noted in
    # base-items.md rather than invented here.
    # 611 before the 4 AC tier-4 pieces: 18 recipes of two rows each, an
    # armour class and the material's own second property.
    if len(property_sql) != 647:
        raise ValueError(f"Generated {len(property_sql)} property rows instead of 647")
    # A base blueprint shared by several recipes must be one of the trade's own.
    #
    # The rule exists because the opposite was believed to be true for six days
    # and was not. base-items.md said its table was "todo lo que el CNR puede
    # fabricar" and AGENTS.md said every weapon, armour, shield and ammunition
    # type had its own cnr_b_*, while the scale mail, the full plate, the
    # pavise, the helmet, the gloves, the boots, the belt, the bracers and the
    # cloak were still built from named blueprints the rest of the module uses -
    # guantesdecuero is handed out by the treasure scripts, capadepiel is worn by
    # four NPCs. Nothing checked, so the claim outlived the fact.
    #
    # Sharing is the tell. A blueprint that serves one recipe is that recipe's
    # own product: a potion, a cut gem, a plank, an ingot, the ring a single gem
    # sets into. A blueprint that serves several is a *type*, and a type belongs
    # to the trade. Potions and grenades are exempt: fifty alchemy recipes and
    # thirty poisons share a handful of consumable blueprints on purpose, and
    # differ only in name and effect.
    # A base object nobody can import is a base object nobody will use. The
    # palette is what puts it in the toolset, and it is the step most easily
    # forgotten, because nothing in the catalogue depends on it: the recipes
    # keep working and the builder simply cannot find the blueprint.
    palette_text = read_text(ROOT / "src" / "shared" / "itp" / "itempalcus.itp.json",
                             encoding="utf-8")
    # Matched between the quotes of the JSON value, and with the underscore in
    # the character class. Reading the bare name stopped at the next underscore,
    # so a palette entry for "cnr_b_lsword_x" was read as "cnr_b_lsword"
    # and an object that does not exist passed the check.
    in_palette = set(re.findall(r'"(cnr_b_[a-z0-9_]+)"', palette_text))
    on_disk = {path.name[: -len(".uti.json")]
               for path in (ROOT / "src" / "cnr" / "uti").glob("cnr_b_*.uti.json")}
    missing_from_palette = sorted(on_disk - in_palette)
    missing_from_disk = sorted(in_palette - on_disk)
    if missing_from_palette:
        raise ValueError(
            "These base objects are not in itempalcus.itp: "
            + ", ".join(missing_from_palette)
        )
    if missing_from_disk:
        raise ValueError(
            "itempalcus.itp lists base objects that do not exist: "
            + ", ".join(missing_from_disk)
        )

    #
    # A variant counts as shared whatever its tally: a group's product is
    # offered by every material recipe in that group, so one variant naming a
    # borrowed blueprint would make it craftable through fifteen recipes at
    # once. Variants are read here rather than at their own block below, which
    # runs after this point.
    SHARED_CONSUMABLE_BASE_ITEMS = {49, 81}   # potions, grenade
    shared_bases: Dict[str, int] = defaultdict(int)
    for recipe in recipe_rows:
        shared_bases[recipe.base_resref] += 1
    variants_doc_for_check = json.loads(
        (ROOT / "migration" / "catalogue" / "variants.json").read_text(encoding="utf-8")
    )
    variant_bases = {
        variant["base_resref"]: group["code"]
        for group in variants_doc_for_check["groups"]
        for variant in group["variants"]
    }
    borrowed = []
    for resref, uses in sorted(shared_bases.items()):
        if uses < 2 or resref.startswith("cnr_b_"):
            continue
        blueprint = blueprints_by_resref.get(normalize(resref))
        if blueprint and blueprint.base_item in SHARED_CONSUMABLE_BASE_ITEMS:
            continue
        borrowed.append(f"{resref} ({uses} recipes)")
    for resref, code in sorted(variant_bases.items()):
        if resref.startswith("cnr_b_"):
            continue
        blueprint = blueprints_by_resref.get(normalize(resref))
        if blueprint and blueprint.base_item in SHARED_CONSUMABLE_BASE_ITEMS:
            continue
        borrowed.append(f"{resref} (variant of {code})")
    if borrowed:
        raise ValueError(
            "These base blueprints are shared by several recipes and are not the "
            "trade's own; give each type a cnr_b_* copy: " + ", ".join(borrowed)
        )

    copper_recipes = [
        recipe
        for recipe in recipe_rows
        if recipe.material_code == "Cobre"
        and recipe.source.station.source
        in ("cnranvilsmith", "cnrforgepublic", "cnrjewelersbench")
    ]
    copper_station_counts = {
        station: sum(recipe.source.station.source == station for recipe in copper_recipes)
        for station in ("cnranvilsmith", "cnrforgepublic", "cnrjewelersbench")
    }
    expected_copper_counts = {
        "cnranvilsmith": 8,
        "cnrforgepublic": 1,
        # The jeweller no longer works metal at all; its materials are the 28
        # stones, and the smith forges the blanks.
        "cnrjewelersbench": 0,
    }
    if copper_station_counts != expected_copper_counts:
        raise ValueError(f"Copper practice inventory changed: {copper_station_counts}")
    copper_with_properties = [
        recipe.display_name
        for recipe in copper_recipes
        if recipe_property_counts[recipe.recipe_id] != 0
    ]
    if copper_with_properties:
        raise ValueError(
            "Copper practice recipes must be property-free: "
            + ", ".join(copper_with_properties)
        )
    alchemy_output_tags: Dict[str, List[str]] = defaultdict(list)
    for recipe in recipe_rows:
        if recipe.source.station.source == "cnralchemytable" and recipe.output_tag:
            alchemy_output_tags[recipe.output_tag].append(recipe.display_name)
    duplicate_alchemy_tags = {
        tag: names for tag, names in alchemy_output_tags.items() if len(names) > 1
    }
    if duplicate_alchemy_tags:
        raise ValueError(f"Selected alchemy recipes share output tags: {duplicate_alchemy_tags}")

    # A crafted piece is stamped with the trade that made it, so a later
    # enchanting table can tell one from anything else the player carries.
    # Three things disqualify a recipe: it is alchemy, its station makes
    # materials, or another recipe eats what it produces - a ring band and a
    # cut gem come off a product bench but are still material.
    consumed = {
        component.tag
        for recipe in recipe_rows
        for component in recipe.source.components
    }
    for recipe in recipe_rows:
        station = recipe.source.station
        if (station.output_kind == "product"
                and station.profession_id != ALCHEMY_PROFESSION_ID
                and recipe.base_resref not in consumed
                and (recipe.output_tag or "") not in consumed):
            recipe.crafted_by = station.profession_id

    # Variants are resolved here, before any recipe is serialized. They used
    # to be read after recipe_sql had already been built, so assigning the
    # group's fallback back onto recipe.base_resref changed nothing that was
    # emitted. It went unnoticed because the sources happen to name the same
    # resref as the first variant; the first reorder would have shipped the
    # wrong fallback in silence.
    # --- product variants -----------------------------------------------------
    # A recipe with a group makes the variant the player picks instead of its
    # own base_resref. Every blueprint named here has to exist, for the same
    # reason a base_resref does: a resref nobody can create is a recipe that
    # charges the crafter and hands back nothing.
    variants_path = ROOT / "migration" / "catalogue" / "variants.json"
    variants_doc = json.loads(variants_path.read_text(encoding="utf-8"))
    variant_sql: List[str] = []
    variant_first: Dict[str, str] = {}
    variant_id = 0
    for group in variants_doc["groups"]:
        code = group["code"]
        for order, variant in enumerate(group["variants"], start=1):
            resref = variant["base_resref"]
            if normalize(resref) not in blueprints_by_resref:
                raise ValueError(
                    f"Variant {resref!r} of group {code!r} has no local blueprint"
                )
            variant_first.setdefault(code, resref)
            variant_id += 1
            variant_sql.append(
                "INSERT INTO cnr_variant "
                "(variant_id,group_code,base_resref,display_name,sort_order) "
                f"VALUES ({variant_id},{sql_value(code)},{sql_value(resref)},"
                f"{sql_value(variant['display_name'])},{order});"
            )

    # A recipe that names a group makes that group's first variant when nothing
    # is picked, so base_resref is never empty and never someone else's product.
    for recipe in recipe_rows:
        group = recipe.source.variant_group
        if not group:
            continue
        if group not in variant_first:
            raise ValueError(
                f"Recipe {recipe.display_name!r} names variant group {group!r}, "
                "which variants.json does not define"
            )
        recipe.base_resref = variant_first[group]

    recipe_sql = []
    for recipe in recipe_rows:
        material_expression = "NULL"
        if recipe.material_code is not None:
            material_expression = (
                "(SELECT material_id FROM cnr_material WHERE profession_id="
                f"{recipe.source.station.profession_id} AND code={sql_value(recipe.material_code)})"
            )
        recipe_sql.append(
            "INSERT INTO cnr_recipe "
            "(recipe_id,public_id,category_id,material_id,tier,min_level,crafted_by,display_name,"
            "base_resref,output_tag,output_qty,output_kind,"
            "extra_resref,extra_qty,extra_name,marks_socketed,"
            "dc,xp_award,gold_value,enabled,variant_group,legacy_code) "
            f"VALUES ({recipe.recipe_id},{recipe.public_id},{recipe.source.category_id},"
            f"{material_expression},{recipe.tier},{recipe.min_level},{recipe.crafted_by},"
            f"{sql_value(recipe.display_name)},"
            f"{sql_value(recipe.base_resref)},{sql_value(recipe.output_tag)},"
            f"{recipe.source.output_quantity},{sql_value(recipe.source.station.output_kind)},"
            f"{sql_value(recipe.source.extra_resref)},{recipe.source.extra_quantity},"
            f"{sql_value(recipe.extra_name)},{recipe.marks_socketed},"
            f"{recipe.dc},{recipe.xp},{recipe.gold},{recipe.enabled},"
            f"{sql_value(recipe.source.variant_group)},"
            f"{sql_value(recipe.source.legacy_code)});"
        )

    catalogue_lines = [
        "-- CNR catalogue migrated from the legacy workstation scripts.",
        "-- Generated by migration/build_catalogue.py; do not edit by hand.",
        "",
        "START TRANSACTION;",
        "",
        "DELETE FROM cnr_variant;",
        "DELETE FROM cnr_recipe_property;",
        "DELETE FROM cnr_recipe_component;",
        "DELETE FROM cnr_recipe;",
        # Deleting a category cascades onto any tool scoped to it, so those
        # rows are rewritten here too, after the categories exist again.
        "DELETE FROM cnr_station_tool WHERE category_id IS NOT NULL;",
        "DELETE FROM cnr_category;",
        "",
    ]
    for label, rows in (
        ("categories", category_sql),
        ("recipes", recipe_sql),
        ("components", component_sql),
        ("properties", property_sql),
        ("variants", variant_sql),
    ):
        catalogue_lines.append(f"-- {label}: {len(rows)}")
        catalogue_lines.extend(rows)
        catalogue_lines.append("")
    scoped = []
    for row in STATION_TOOLS:
        if len(row) <= 5 or not row[5]:
            continue
        station_tag, tool_tag, access_mode, breakage, sort_order, category = row
        tool_blueprint = blueprints_by_tag.get(normalize(tool_tag))
        tool_name = tool_blueprint.name if tool_blueprint else module_names.get(tool_tag)
        scoped.append(
            "INSERT INTO cnr_station_tool "
            "(station_id,tool_tag,display_name,category_id,access_mode,"
            "breakage_chance,sort_order) "
            f"SELECT s.station_id,{sql_value(tool_tag)},{sql_value(tool_name)},"
            f"c.category_id,{sql_value(access_mode)},{breakage},{sort_order} "
            "FROM cnr_station s JOIN cnr_category c ON c.station_id = s.station_id "
            f"WHERE s.tag={sql_value(station_tag)} "
            f"AND c.display_name={sql_value(category)};"
        )
    if scoped:
        catalogue_lines.append("-- station tools scoped to one category")
        catalogue_lines.extend(scoped)
        catalogue_lines.append("")
    catalogue_lines.append("COMMIT;")
    catalogue_lines.append("")
    catalogue_sql = "\n".join(catalogue_lines)

    verify_naming_contract(recipe_rows)
    verify_no_recipe_regression(catalogue_sql, args.accept_recipe_changes)

    write_or_check(SEED_PATH, seed_sql, args.check)
    write_or_check(CATALOGUE_PATH, catalogue_sql, args.check)

    print(f"materials     : {len(materials)}")
    print(f"categories    : {len(category_sql)}")
    print(f"recipes       : {len(recipe_sql)}")
    print(f"components    : {len(component_sql)}")
    print(f"properties    : {len(property_sql)}")
    print(f"external refs : {len(external_resrefs)}")
    for label in sorted(mapping_counts):
        print(f"{label:38}: {mapping_counts[label]}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, KeyError, json.JSONDecodeError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        raise SystemExit(1)
