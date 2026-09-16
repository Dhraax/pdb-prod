# CNR Schema

Status 2026-08-11: **implemented in DEV.** This document explains the schema
design; `migration/01_schema.sql`, `migration/02_seed.sql`, and
`migration/03_catalogue.sql` are authoritative for executable DDL/data.

The schema was built fresh: legacy recipe/property rows were re-derived into
the current catalogue rather than inherited in place. The eight disposable
catalogue tables are owned by `migration/01_schema.sql`; the two
character-owned tables are created idempotently by
`migration/cnr/00_player_state_schema.sql` after PWDB identity exists.

Companion: the original rework specification (behaviour).

---

## 1. Principles

1. **The tier belongs to the material**, and comes from the order already fixed
   in the Etapa-2 design tables — top to bottom is easy to hard.
2. **Properties belong to the recipe.** One recipe, one set of properties. No
   resolution through `material + type + gem`; that indirection is what made
   gems silently fail.
3. **Surrogate keys for joins, a short public id for players**, blocks of 1000
   per profession.
4. **Creation always uses a blueprint resref.** `base_resref` is required;
   `output_tag` is applied to the created item when the final tag differs.

---

## 2. Shape

```text
cnr_profession ──< cnr_station ──< cnr_category (tree)
                         └──< cnr_station_tool
      │                                  │
      └──< cnr_material                  │
                  └──────< cnr_recipe >──┘
                                │
                                ├──< cnr_recipe_component
                                └──< cnr_recipe_property

pwdb_character ──< cnr_tradeskill
               ──< cnr_character_setting
```

---

## 3. DDL

### 3.1 Professions

```sql
CREATE TABLE cnr_profession (
  profession_id TINYINT UNSIGNED NOT NULL,
  code          VARCHAR(16) NOT NULL,     -- Herreria, Alquimia, Joyeria...
  display_name  VARCHAR(48) NOT NULL,
  skill_index   TINYINT     NOT NULL,     -- GetSkillName(), 0-based
  ability_1     TINYINT     NULL,         -- ABILITY_* constant
  ability_2     TINYINT     NULL,         -- averaged with ability_1 when set
  id_block      MEDIUMINT UNSIGNED NOT NULL,  -- 1000, 2000, 3000...
  PRIMARY KEY (profession_id),
  UNIQUE KEY uq_profession_code (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

`id_block` is the base of that profession's public id range. Blocks of 1000
leave room for future recipes.

| ID | Profession | Skill index | Abilities | Public IDs |
|----|------------|-------------|-----------|------------|
| 1 | Herrería | 0 | Strength, Constitution | 1001-1999 |
| 2 | Carpintería | 1 | Dexterity, Strength | 2001-2999 |
| 3 | Peletería | 2 | Dexterity, Constitution | 3001-3999 |
| 4 | Alquimia | 3 | Wisdom, Intelligence | 4001-4999 |
| 5 | Joyería | 4 | Charisma, Wisdom | 5001-5999 |
| 6 | Arcano | 5 | Intelligence, Wisdom | 6001-6999 |
| 7 | Sastrería | 6 | Dexterity, Charisma | 7001-7999 |

The live skill list uses the same zero-based order. Sastrería is appended, so
existing skill indices and persisted names remain stable.

### 3.2 Stations

```sql
CREATE TABLE cnr_station (
  station_id    SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  tag           VARCHAR(32) NOT NULL,     -- placeable tag: cnranvilsmith
  profession_id TINYINT UNSIGNED NOT NULL,
  display_name  VARCHAR(48) NOT NULL,     -- "Forja"
  produces      ENUM('product','material') NOT NULL DEFAULT 'product',
  anim_script   VARCHAR(16) NULL,
  PRIMARY KEY (station_id),
  UNIQUE KEY uq_station_tag (tag),
  CONSTRAINT fk_station_profession
    FOREIGN KEY (profession_id) REFERENCES cnr_profession(profession_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

`tag` is what the single generic station script looks up:
`GetTag(OBJECT_SELF)` → row → profession, categories, tool, animation. Adding a
station is a placeable plus a row, no compile.

`cnrSewingTable` is the Sastrería station. It uses `cnr_tailor_anim`, requires
the inventory tools `cnr_t_aguja` and `cnr_t_kit_cuero`, and intentionally has no
categories or recipes until its design is authored.

Tools are a child collection rather than columns on `cnr_station`, because the
source can declare more than one tool and distinguishes equipped tools from
inventory tools. The generic runtime treats every row as required (**AND**).
Tailoring therefore requires both inventory tools, correcting the legacy API's
single-value overwrite. Inventory tools may be nested or equipped; equipped
tools must be in an equipment slot. Each row owns an independent percentage
breakage roll when crafting begins. The canonical DDL is
`migration/01_schema.sql`.

### 3.3 Categories

```sql
CREATE TABLE cnr_category (
  category_id  SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  station_id   SMALLINT UNSIGNED NOT NULL,
  parent_id    SMALLINT UNSIGNED NULL,    -- NULL = top level
  display_name VARCHAR(48) NOT NULL,      -- "Armas" / "Espadas Largas"
  sort_order   SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (category_id),
  KEY idx_category_browse (station_id, parent_id, sort_order),
  CONSTRAINT fk_category_station
    FOREIGN KEY (station_id) REFERENCES cnr_station(station_id) ON DELETE CASCADE,
  CONSTRAINT fk_category_parent
    FOREIGN KEY (parent_id) REFERENCES cnr_category(category_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.3b Station tools

```sql
CREATE TABLE cnr_station_tool (
  station_tool_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  station_id      SMALLINT UNSIGNED NOT NULL,
  tool_tag        VARCHAR(32) NOT NULL,     -- matched against GetTag
  display_name    VARCHAR(96) NULL,         -- shown to the player, not the tag
  category_id     SMALLINT UNSIGNED NULL,   -- NULL = the whole station
  access_mode     ENUM('equipped','inventory') NOT NULL,
  breakage_chance DECIMAL(5,2) NOT NULL DEFAULT 0,
  sort_order      TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (station_tool_id),
  UNIQUE KEY uq_station_tool (station_id, tool_tag, category_id),
  CONSTRAINT fk_station_tool_station
    FOREIGN KEY (station_id) REFERENCES cnr_station(station_id) ON DELETE CASCADE,
  CONSTRAINT fk_station_tool_category
    FOREIGN KEY (category_id) REFERENCES cnr_category(category_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Every row is a requirement. `category_id` narrows one to a single menu, which
is how the jeweller's cutting kit is needed for cutting gems and not for
setting them; the table is therefore created **after** `cnr_category`, and its
scoped rows are written by `03_catalogue.sql`.

`breakage_chance` is a percentage. The engine rolls
`Random(10000) < chance * 100`, so `10.0` is one attempt in ten and `0.3` -
what the table used to hold - was three in a thousand.

### 3.4 Materials

```sql
CREATE TABLE cnr_material (
  material_id   SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  profession_id TINYINT UNSIGNED NOT NULL,
  code          VARCHAR(48) NOT NULL,
  display_name  VARCHAR(48) NOT NULL,
  tier          TINYINT NOT NULL,          -- 1..4
  sort_order    SMALLINT NOT NULL,         -- position in the design table
  PRIMARY KEY (material_id),
  UNIQUE KEY uq_material_code (profession_id, code),
  KEY idx_material_tier (profession_id, tier, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Tiers come straight from the Etapa-2 tables, read top to bottom:

| Tier | Herrería | Peletería |
|------|----------|-----------|
| 1 | Cobre, Hierro, Acero | Roedor, Herbívoro |
| 2 | Plata, Hierrofrio, Oro, Platino, H. Enardecido | Bestia salvaje, B. salvaje grande |
| 3 | Aceroscuro, Dlarun, Hizagkuur, Arandur | Bestia mítica, B. mítica gruesa |
| 4 | Metal Vivo, Mithril, Adamantita | Dragón fuego/hielo/ácido/rayo |

**Joyería** follows the same shape as smithing: gems are cut and set into metal
and leather goods, so progression mirrors it — four tiers over the 28 gems in
their listed order.

**Alquimia** is different: potions all draw on the same base reagents, so
difficulty is not a property of the material — it is a property of the potion.
Alchemy recipes therefore take their tier from their **position in the ordered
list**, with poisons interleaved by their `Manejo` DC (9-21, already in the
design CSV). See §3.5 `tier`.

### 3.5 Recipes

```sql
CREATE TABLE cnr_recipe (
  recipe_id    MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  public_id    MEDIUMINT UNSIGNED NOT NULL,   -- typed by the player
  category_id  SMALLINT UNSIGNED NOT NULL,
  material_id  SMALLINT UNSIGNED NULL,        -- NULL for potions and poisons
  tier         TINYINT NOT NULL,              -- from material, or from order
  display_name VARCHAR(96) NOT NULL,          -- keeps palette colour codes
  description  VARCHAR(255) NULL,
  base_resref  VARCHAR(16) NOT NULL,         -- CreateItemOnObject blueprint resref
  output_tag   VARCHAR(32) NULL,             -- tag applied to the result
  output_qty   SMALLINT NOT NULL DEFAULT 1,
  output_kind  ENUM('product','material') NOT NULL DEFAULT 'product',
  extra_resref VARCHAR(16) NULL,             -- second product, on success only
  extra_qty    SMALLINT NOT NULL DEFAULT 0,
  extra_name   VARCHAR(96) NULL,             -- palette name, shown in the list
  marks_socketed TINYINT(1) NOT NULL DEFAULT 0,  -- result holds a gem
  dc           SMALLINT NOT NULL,
  xp_award     MEDIUMINT NOT NULL,
  gold_value   MEDIUMINT NOT NULL DEFAULT 0,
  enabled      TINYINT(1) NOT NULL DEFAULT 1,
  legacy_code  VARCHAR(64) NULL,
  created_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                 ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (recipe_id),
  UNIQUE KEY uq_recipe_public (public_id),
  KEY idx_recipe_browse (category_id, enabled, dc),
  CONSTRAINT fk_recipe_category
    FOREIGN KEY (category_id) REFERENCES cnr_category(category_id),
  CONSTRAINT fk_recipe_material
    FOREIGN KEY (material_id) REFERENCES cnr_material(material_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

`extra_*` is one optional second product - the dust a cut gem drops - kept here
rather than in a child table because one extra is all any recipe needs and a
join would cost the craft-attempt query for nothing. `extra_name` exists so the
recipe list never has to print a resref. `marks_socketed` makes the engine set
`CNR_ENGARZADO` on the result, and a marked item is invisible to every recipe.

`gold_value` is charged, not decorative: the player pays it when the attempt
starts and a failed roll does not refund it.

```

**Creation and final identity are separate.** `base_resref` is always the
blueprint passed to `CreateItemOnObject`; `output_tag` is applied afterwards:

| Case | Creation resref | Final tag |
|------|-----------------|-----------|
| Smithing item | `wswls002` long swords, `ashlw002` large shields | **none** — only alchemy sets `output_tag` |
| Potion | `sute_her_tra_b` | `sute_her_010_015_n` |
| Poison | `cnr_b_veneno_her` | `Saquitodeveneno_001` |

Alchemy still resolves effects by final tag, but that does not change how NWN
creates the item. `sPocionBase` supplies the resref and `sCustomTag` supplies
`output_tag`.

`tier` is denormalised onto the recipe on purpose: for smithing, tailoring and
jewelry it is copied from the material; for alchemy the material carries no
difficulty and the tier comes from list position. One column serves both, and a
recipe can override its tier as an exception.

### `base_resref`: literal, or resolved?

An authored recipe may state `base_resref` outright in its catalogue JSON. When
it does, the generator uses it **verbatim** and resolves nothing.

That escape hatch exists because resolution is genuinely dangerous here.
`resolve_resref()` looks a value up as a resref *and* as a tag, and **PDB carries
unique named blueprints that keep the base item's tag**:

| Tag | ResRef | Item |
|---|---|---|
| `NW_WBWLN001` | `pb_parclaarco01` | Arco de Anirin |
| `NW_WBWLN001` | `pb_sunarco01` | Arco - Arquero de Su Majestad |
| `NW_WDBQS001` | `pb_parclabaston1` | Bastón de Edereth |
| `NW_WDBQS001` | `pb_athestbaston1` | Bastón de Anciano |
| `NW_WBWXH001` | `wbwxh002` | [BAJO] Ballesta pesada |

A carpentry recipe asking for the plain longbow `nw_wbwln001` resolved to
**Arco de Anirin** — a unique magic item — and the recipe count was still
correct, so nothing flagged it. Caught only by reading the generated resrefs
back.

**Rule: when the output is a base game item, state `base_resref` in the JSON.**
Never let a base resref go through tag resolution.

**`output_tag` is not an alternative to `base_resref`.** The resref chooses the
blueprint; `output_tag` is applied afterwards with `SetTag()`. It exists for
alchemy, where potions and poisons are found by tag. Equipment keeps its
blueprint's tag — an internal recipe key such as `recipe_hierro_weapon` must
never become an item's tag. Exactly 65 recipes set it, all alchemy.

---

### 3.6 Components

```sql
CREATE TABLE cnr_recipe_component (
  recipe_id         MEDIUMINT UNSIGNED NOT NULL,
  component_tag     VARCHAR(32) NOT NULL,
  qty               SMALLINT NOT NULL DEFAULT 1,
  retain_on_fail    SMALLINT NOT NULL DEFAULT 0,
  retain_on_success SMALLINT NOT NULL DEFAULT 0,
  sort_order        TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (recipe_id, component_tag),
  CONSTRAINT fk_component_recipe
    FOREIGN KEY (recipe_id) REFERENCES cnr_recipe(recipe_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Components are matched against the station inventory by tag to render
`have/needed`. `retain_on_fail` mirrors today's behaviour: how many survive a
failed attempt (the 239 alchemy vials).

`retain_on_success` is the symmetric case, and it is what replaced the legacy
biproduct mechanic. A component that comes back on success is a **reusable tool
listed as an ingredient**, not an extra output. `cnr_i_craft.nss` reads both:

```nwscript
int nGasta = bOk ? (nNeed - nRetainOk) : (nNeed - nRetain);
```

Seven tailoring recipes use it, all returning `cnrBookPatterns` ×1 whatever the
outcome. The generator derives the column from the JSON `biproduct` block and
**refuses to build** if a biproduct tag is not also a component of the same
recipe — that case would be a genuine extra output and needs its own row, not a
retain.

### 3.7 Properties

```sql
CREATE TABLE cnr_recipe_property (
  recipe_property_id MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
  recipe_id     MEDIUMINT UNSIGNED NOT NULL,
  property_type VARCHAR(32) NOT NULL,   -- DamageBonus, ACBonus, Keen...
  subtype       INT NOT NULL DEFAULT 0,
  value1        INT NOT NULL DEFAULT 0,
  value2        INT NOT NULL DEFAULT 0,
  sort_order    TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (recipe_property_id),
  KEY idx_property_recipe (recipe_id, sort_order),
  CONSTRAINT fk_property_recipe
    FOREIGN KEY (recipe_id) REFERENCES cnr_recipe(recipe_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

One recipe, its own properties. A recipe may legitimately have **none** —
potions and poisons are dummy items whose behaviour comes from their tag.

No `UNIQUE` on `(recipe_id, property_type, subtype)`: the superseded schema had
one and silently collapsed rows that differed only in `value1`/`value2`. A
surrogate key lets a recipe carry two similar properties if the design wants
them.

The column contract per `property_type` is unchanged and documented in
[`material-properties-reference.md`](material-properties-reference.md).

### 3.8 Tradeskill progress

```sql
CREATE TABLE IF NOT EXISTS cnr_tradeskill (
  character_id INT         NOT NULL,
  skill_name   VARCHAR(32) NOT NULL,
  skill_level  INT         NOT NULL DEFAULT 1,
  skill_xp     INT         NOT NULL DEFAULT 0,
  updated_at   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (character_id, skill_name),
  CONSTRAINT fk_tradeskill_character
    FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

This is character-owned state. It is not recreated with the catalogue and is
written through the PWDB-backed tradeskill API.

### 3.9 Character settings

```sql
CREATE TABLE cnr_character_setting (
  character_id  INT NOT NULL,
  setting_name  VARCHAR(32) NOT NULL,
  setting_value INT NOT NULL DEFAULT 0,
  PRIMARY KEY (character_id, setting_name),
  CONSTRAINT fk_setting_character
    FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Holds the "show all recipes" toggle, and future flags without a schema change.
Like tradeskill progress, this table is character-owned and outside the
catalogue drop/reseed lifecycle.

---

## 4. Menu queries

One query per screen, all read-only.

```sql
-- Categories with counts restricted to the player's visible tiers
SELECT c.category_id, c.display_name, COUNT(r.recipe_id) AS products
FROM cnr_category c
JOIN cnr_station s ON s.station_id = c.station_id
LEFT JOIN cnr_recipe r ON r.category_id = c.category_id AND r.enabled = 1
  AND (? = 1 OR r.tier <= ?)
WHERE s.tag = ? AND c.parent_id <=> ?
GROUP BY c.category_id
ORDER BY c.sort_order, c.display_name;

-- Products: tier and progression order, paginated, level filter optional
SELECT r.public_id, r.display_name, r.dc
FROM cnr_recipe r
WHERE r.category_id = ? AND r.enabled = 1
  AND (? = 1 OR r.tier <= ?)
ORDER BY r.tier, r.dc, r.public_id
LIMIT ? OFFSET ?;

-- Detail with components
SELECT r.*, c.component_tag, c.qty, c.retain_on_fail
FROM cnr_recipe r
LEFT JOIN cnr_recipe_component c ON c.recipe_id = r.recipe_id
WHERE r.public_id = ?
ORDER BY c.sort_order;

-- Crafting: properties to apply
SELECT property_type, subtype, value1, value2
FROM cnr_recipe_property
WHERE recipe_id = ?
ORDER BY sort_order;
```

The existing browse index narrows the category and enabled rows. Per-category
lists are small; if catalogue families grow substantially, extend the index to
`(category_id, enabled, tier, dc, public_id)` to cover the full ordering.

---

## 5. What it replaces

| Today | Becomes |
|-------|---------|
| 3499 lines across 7 station `.nss` | `cnr_station`, `cnr_category`, `cnr_recipe`, `cnr_recipe_component` |
| `recipe_metadata` (367) | `cnr_recipe` |
| `material_properties` (339, by material+type+gem) | `cnr_recipe_property`, per recipe |
| Submenus as module local variables | `cnr_category` |
| `baseResRef` mixing resrefs and tags | required `base_resref` + optional `output_tag` |
| Hardcoded XP and level per recipe | `tier` → `dc`, `xp_award`, `gold_value` |

---

## 6. Notes for the migration

- Property rows must be **expanded**: the 339 legacy rows keyed by `material +
  type + gem` become 381 per-recipe rows. Every recipe mapped to an approved
  property key must resolve at least one numeric row; only outputs with no
  approved property design may legitimately remain empty.
- Jewelry currently stores `NW_IT_MRING022silver` / `NW_IT_MNECK021silver`,
  which are **tags**, not resrefs. They migrate to the blueprint resrefs
  `it_mring037` and `it_mneck041` read from the local UTI files.
- Public ids are assigned per profession block on migration, in category then
  DC order, so they stay readable.
- Adamantite's opposite-physical damage uses `propertyType =
  'DamageBonusOpposite'`, resolved at craft time from the base weapon.

---

## `cnr_variant` — los productos que una receta puede dar

Una receta con `variant_group` no fabrica su `base_resref`: fabrica el producto
que el jugador elige de ese grupo. Es lo que evita una fila por producto cuando
lo único que cambia es el producto — 15 recetas de metal con 48 variantes en
lugar de 720 filas.

| Columna | Para qué |
|---|---|
| `variant_id` | lo que el menú manda de vuelta; nunca un resref |
| `group_code` | a qué grupo pertenece, p. ej. `smith_weapon` |
| `base_resref` | el blueprint que se crea |
| `display_name` | "Daga"; el nombre final se compone con el material |
| `sort_order` | orden en el menú |

`cnr_recipe.variant_group` es NULL en todo lo que tiene producto fijo, que es la
mayoría del catálogo y se comporta como siempre.

**La validación es la consulta**: `CnrCraft_ResolveProduct` une `cnr_recipe` con
`cnr_variant` por `group_code` y filtra por `recipe_id` y `variant_id` a la vez,
así que preguntar por una variante de otro grupo no devuelve nada y el intento
se detiene antes de cobrar. El cliente no envía resrefs en ningún momento.

