# CNR Catalogue Migration Correction Notes

Status 2026-08-11: **historical first-migration baseline.** The corrected
seven-station baseline was applied to DEV on 2026-08-09, but later catalogue
and Carpentry slices superseded its counts and source inventory. Use
[`../oficios/cnr/README.md`](../oficios/cnr/README.md) for current status and
[`../oficios/cnr/legacy-removal-and-production-promotion.md`](../oficios/cnr/legacy-removal-and-production-promotion.md)
for release gates. Compilation and in-game validation remain pending.

This note is the handoff for the database-driven CNR catalogue work. Read it
before changing `migration/`, the generic crafting scripts, or the future
catalogue editor.

## Objective

Preserve every recipe declared by the seven legacy workstation scripts while
moving catalogue ownership to MySQL. The migration must not silently discard a
recipe merely because its legacy `recipe_metadata` row is missing or malformed.

The authoritative inputs have distinct responsibilities:

| Input | Responsibility |
|-------|----------------|
| Etapa-2 CSV files | Approved design tables for materials, properties and poisons |
| Profession JSON files | Structured form of the Etapa-2 design |
| Legacy workstation `.nss` files | Existing recipe, category and component inventory |
| UTI blueprints | Authoritative `Tag` to `TemplateResRef` relationship |
| `cnr_sql_init.nss` | Audited numeric property rows and legacy dynamic-item metadata |
| `02_seed.sql` / `03_catalogue.sql` | Generated output; never edit these files by hand |

## Defects in the previous generation

1. The generator read only `joyeria.json`, and only to infer some gem names.
2. It emitted 239 recipes with `base_resref`, `base_tag` and `output_tag` all
   `NULL`.
3. Successful crafting consumed components and granted XP before attempting to
   create an item from the empty identifier.
4. Alchemy metadata confused the creation resref with the final item tag.
   `sPocionBase` is the blueprint resref; `sCustomTag` is the final tag.
5. Jewelry stored `NW_IT_MRING022silver` and
   `NW_IT_MNECK021silver` as resrefs. They are tags. The real local blueprint
   resrefs are `it_mring037` and `it_mneck041`.
6. `bru_picar` did not match the approved/local `bru_picara` identifier.
7. The lightning-dragon bracer properties existed, but its legacy metadata row
   did not.
8. Smithing pavise recipes used `NW_ASHTO001` as their recipe key, so direct
   metadata lookup could not select the material-specific row.
9. Station configuration lost tools, access modes and animations. Tailoring
   declares `aguja_cost` and then `sapo_kitcuero`, but the legacy single-value
   API overwrites the first declaration. Both declarations are preserved for
   review; the source does not establish whether the intended rule is both,
   either, or only the currently effective second tool.
10. The implementation documentation reported 197 properties while the SQL
    contained 284.
11. Thirty leather recipes used shortened type names (`Botas`, `Capa` and
    `Cinturón`) that did not match the audited numeric property keys. Their
    output blueprints were valid, but all 52 applicable property rows were
    silently omitted.
12. All 14 full-plate recipes requested the non-existent component tag
    `molde_armorcompleta`. The merchant item and the legacy anvil implementation
    use the engine-compatible tag `molde_armorcompl`, so the database consumer
    always counted the inserted mold as zero.
13. Jewelry material discovery added `Hierrofrío` after the canonical
    `Hierrofrio`, and `Metal vivo` after `Metal Vivo`. Those Python strings are
    distinct, but MySQL's catalogue collation treats each pair as equal. The
    seed therefore failed on its first duplicate key after rebuilding the
    schema.
14. The in-game recipe query filtered out any recipe above an incorrectly
    calculated maximum reachable DC. It passed profession id `0`, so the
    calculation ignored profession level and profession abilities. The
    `CNR_SHOW_ALL` override had no caller or menu action. This silently hid 90
    enabled recipes, including the adamantite longsword. An interim correction
    exposed every enabled recipe, but that removed the intended player choice
    instead of repairing it.

## Corrected generation contract

`migration/build_catalogue.py` now:

- validates the four CSV/JSON pairs before generating SQL;
- compares every smithing, jewelry and leather property cell after normalizing
  documented server-vocabulary aliases and harmless formatting differences;
- parses exactly 394 legacy recipes and 787 aggregated component rows;
- resolves every output to a non-empty resref of at most 16 characters;
- resolves alchemy through `alquimia.json`;
- resolves 90 leather products through `peleteria.json`;
- resolves jewelry base objects through the actual UTI blueprints;
- resolves smithing metadata by legacy key and, where required, display name;
- verifies every mold component tag against item instances in tracked module
  area inventories;
- expands audited numeric properties onto each recipe and rejects any mapped
  recipe whose property key resolves to no numeric rows;
- accepts `cnr_sql_c_item` as the only legacy recipe hook because its item
  creation and property work is now performed inside the generic engine, and
  rejects any different pre-craft hook instead of silently dropping it;
- preserves all declared station tools and animations without inventing the
  unresolved multi-tool requirement semantics;
- deduplicates material codes with the same accent- and case-insensitive
  normalization used to compare design data, while retaining aliases for
  legacy recipe lookup;
- regenerates both `02_seed.sql` and `03_catalogue.sql`;
- wraps both generated seed and recipe catalogue reloads in transactions;
- fails instead of producing an unresolved recipe.

Current generated baseline:

| Row type | Count |
|----------|------:|
| Materials | 91 |
| Categories | 25 |
| Recipes | 394 |
| Components | 787 |
| Recipe properties | 381 |

Run from the repository root:

```bash
python3 migration/build_catalogue.py
python3 migration/build_catalogue.py --check
```

The check command validates inputs and proves that the committed SQL matches a
fresh generation without writing files.

## Development database application

The corrected `01_schema.sql`, `02_seed.sql` and `03_catalogue.sql` were applied
to the WSL development database on 2026-08-09. Read-only verification returned:

| Check | Result |
|-------|-------:|
| Materials | 91 |
| Categories | 25 |
| Recipes | 394 |
| Components | 787 |
| Recipe properties | 381 |
| Station tools | 7 |
| Orphan components | 0 |
| Orphan properties | 0 |

The active database contains 14 `molde_armorcompl` component rows and 14
`molde_armorcotae` rows. It contains no `molde_armorcompleta` component row.
This proves the database state and relational integrity only; it does not prove
inventory recognition or crafting behavior in game.

The tradeskill journal opened from `guia_pb.dlg` now owns the recipe visibility
preference. Its top-level level list exposes an ON/OFF action backed by the
`cnr_character_setting.show_above_level` character setting. The default is OFF.

With the preference OFF, the station caches its profession's `skill_index` and
maps the character's profession level onto the catalogue's four progression
tiers: levels 1-5 see tier 1, 6-10 see tier 2, 11-15 see tier 3 and 16-20 see
tier 4. Recipe DC remains the success-chance mechanic; it does not remove a
recipe from a tier the character has unlocked. With the preference ON, every
enabled recipe in the selected category is listed. A level-20 smith therefore
sees every enabled smithing recipe, including the DC 32 adamantite longsword,
even when its success chance is not yet comfortable.

This source correction has not yet been compiled, packaged or validated in
game.

## Preserved legacy data that still needs a design decision

The jewelry workstation contains 30 legacy gems. Only ten gem names map to the
current Etapa-2 JSON property set; this produces 20 property-bearing recipes
(ring and necklace). The other 20 gem names produce 40 legacy recipes.

Those 40 recipes remain present and enabled with valid ring/necklace base
resrefs and their original components. They intentionally have no invented
properties. Do not delete them. Review and assign properties through the future
editor, or explicitly disable individual recipes after a design decision.

Eight output resrefs are not backed by a local UTI and are treated as base-game
or HAK resources. Their length and use are valid, but they require runtime
verification with the server's full resource set.

## JSON corrections

- `Residuo de hoja de cativera` now uses `Saquitodeveneno_016`. The value is
  confirmed by `cierra_herbolari.nss`; `_007` belongs to `Veneno de draco`.
- `Poción Refrescante` now uses the existing `sute_her_con_b` base resref.
- `Piel de hervíboro` was corrected to `Piel de herbívoro` in JSON. The typo
  remains in the source CSV and is accepted only by the validator's compatibility
  normalization.
- `Armadura de Cuero Reforzados` was corrected to
  `Armadura de Cuero Reforzada`.

## Schema corrections

- `cnr_recipe.base_resref` is required and limited to 16 characters.
- `base_tag` was removed. `CreateItemOnObject` creates by resref; `output_tag`
  holds the tag applied after creation.
- `cnr_station_tool` preserves multiple declarations, their equipped/inventory
  access mode and breakage chance. Tailoring's multi-tool rule remains
  deliberately undefined until a design decision is made.
- `enabled` remains the safe way to remove a recipe from player-facing lists.
- Recipe and material tier/quantity checks reject structurally invalid rows.
- Recipe timestamps support future optimistic concurrency and audit work.

## Remaining runtime work

The corrected database preserves station tools and animation scripts, but the
new generic crafting engine does not yet enforce or execute them. It also does
not reproduce `cnr_sql_c_item`'s one-percent masterwork checks for gem jewelry
and adamantite or its generated item description. Do not call the new system
feature-complete until those parity decisions are implemented and tested.

Placeables still point at the legacy station scripts. Do not switch them before:

1. applying the corrected schema and generated catalogue to a disposable DB;
2. verifying all foreign keys and row counts;
3. compiling the new NWScript;
4. testing output creation, failure consumption, XP, tools, animations,
   masterwork behavior and crafted descriptions;
5. validating all eight external resrefs in the live resource set.
