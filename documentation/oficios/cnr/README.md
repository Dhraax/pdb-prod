# CNR Crafting System

Canonical index and current implementation status for the database-backed CNR
crafting system. Detailed database ownership and deployment prerequisites live
under `documentation/database/`; this directory owns crafting behaviour,
catalogue design, station integration, and production promotion notes.

## Current status

Status reviewed 2026-09-03. The implementation and the DEV data migration are
complete and the module is built and running, but it is **not production-ready**
until the entries in [`open-issues.md`](open-issues.md) and the gates in the
promotion runbook are closed.

| Area | State | Evidence |
|------|-------|----------|
| PWDB identity and character ownership | Complete in DEV | `documentation/database/`, `src/pwdb/nss/` |
| MySQL schema and generated catalogue | Generated: 71 materials, 39 categories, 559 recipes, 1287 components, 647 properties. First applied to DEV on 2026-08-15; every later regeneration is applied with `db-apply.sh` | `migration/01_schema.sql` through `04_drop_legacy.sql` |
| Generic station browser and craft attempt | Implemented | [`crafting-system.md`](crafting-system.md), `cnr_i_craft.nss` |
| Tier, DC, XP, ability/skill roll, tools, animation and sound | Implemented | [`crafting-system.md`](crafting-system.md) |
| Profession limit | Implemented: two non-Alchemy professions at level 2 or above; Alchemy exempt | `cnr_i_skill.nss` |
| Source-controlled CNR station routing | Eleven trade-station blueprints are normalized with tag, resref and filename aligned; ten are catalogue stations and Arcane uses its own runtime | `src/cnr/utp/`, `cnr_device_ou`, `cnr_c_station` |
| Peletería/Sastrería split | Done: 70 recipes on `cnrTailorsTable` (Peletería) and 30 on `cnrSewingTable` (Sastrería), scaling independently | `cnr_recipe`, [`tailoring-base-items.md`](tailoring-base-items.md) |
| Legacy station conversation and handlers | Removed | [`legacy-removal-and-production-promotion.md`](legacy-removal-and-production-promotion.md) |
| Legacy non-CNR profession runtime | Removed from DEV source | [`legacy-removal-and-production-promotion.md`](legacy-removal-and-production-promotion.md) |
| Crafted `sute_her*` activation | Isolated in `pb_potion_inc` | [`legacy-removal-and-production-promotion.md`](legacy-removal-and-production-promotion.md) |
| Build and package | Done: the module is built and running as of 2026-08-15 | `linux_build-dev.sh` |
| In-game regression and persistence validation | Pending | Promotion runbook |
| Resource collection (harvesting) | Implemented: 44 nodes, tools, cooldown and refill; unproven in game | [`harvesting-nodes.md`](harvesting-nodes.md) |

## What is not built

Kept in one place so it does not drift: every finding, every piece of
unfinished work and every parked idea lives in
[`open-issues.md`](open-issues.md). In short — harvesting is built but has never
been played through, carpentry's four property types are unproven on an item, a
station's materials are shared by everyone using it, and the arcane trade leaves
the old system's dead station and wand still standing in the areas.

Do not promote to production before working through that file and the gates in
[`legacy-removal-and-production-promotion.md`](legacy-removal-and-production-promotion.md),
which owns the order, backups, validation and rollback.

## Documents

| Document | Current role |
|----------|--------------|
| [`crafting-system.md`](crafting-system.md) | Current runtime implementation, station contract, roll, tools, animations, sounds, and production port notes |
| [`schema.md`](schema.md) | Implemented catalogue and player-state schema design; migration SQL remains authoritative |
| [`legacy-removal-and-production-promotion.md`](legacy-removal-and-production-promotion.md) | Canonical production promotion, validation, and rollback runbook |
| [`base-items.md`](base-items.md) | **Léelo antes de escribir una receta.** Los 17 objetos base del CNR: qué resref usar para cada arma, armadura, escudo y munición, y por qué nunca se coge uno del juego |
| [`harvesting-nodes.md`](harvesting-nodes.md) | **Activo.** El sistema de recolección: los 44 nodos, sus herramientas, el enfriamiento, el agotamiento y la recarga. Implementado el 2026-08-18 y **sin validar en juego** |
| [`weapon-variants-plan.md`](weapon-variants-plan.md) | **Historical implementation record.** One recipe per material with a product variant selector; current behavior lives in `crafting-system.md` section 4b |
| [`open-issues.md`](open-issues.md) | **Running log of findings, technical debt and parked ideas.** Add to it as things are discovered; delete entries when they are closed |
| [`plan-de-pruebas.md`](plan-de-pruebas.md) | Tester-facing test plan in Spanish, split by profession, with what each tester must be given to start |
| [`jewellery.md`](jewellery.md) | Current jewellery: three steps, three metal tiers, where the gem properties live and why the metal is cosmetic |
| [`jewellery-exported-items.md`](jewellery-exported-items.md) | The 99 blueprints exported from `contenedor_engar`, Name/tag/resref, and their cross-check against the jewellery recipes |
| [`carpentry-plan.md`](carpentry-plan.md) | Historical Carpentry implementation record. Current behavior and anything still open are owned elsewhere in this index |
| [`arcane-build-log.md`](arcane-build-log.md) | **Active.** What is built, what is pending, what still has to be checked in game, and the decisions already taken |
| [`arcane-plan.md`](arcane-plan.md) | **Active.** How the arcane trade works: crystal as catalyst, essences as quantity, the per-family scaling, the tier taken from loot rarity, and what the engine still cannot do |
| [`arcane-fix-plan.md`](arcane-fix-plan.md) | Historical implementation record for the 2026-08-23 Arcane corrections; in-game regression remains tracked in the active build log and changelog |
| [`arcane-unused-blueprints.md`](arcane-unused-blueprints.md) | The 53 `cnr_esen*` / `cnr_cristal*` blueprints no arcane material claims. A list to delete from once the profession is built and played, not before |
| [`material-properties-reference.md`](material-properties-reference.md) | Numeric item-property contracts used to audit and generate recipe properties |
| [`history/`](history/README.md) | Completed CNR investigations retained for provenance, not current behavior |
| [`../../../migration/legacy-catalogue-seed.sql`](../../../migration/legacy-catalogue-seed.sql) | Archive of the retired legacy seed; never apply it to a live database |

## Runtime ownership map

| Responsibility | Current owner |
|----------------|---------------|
| Authored recipes | `migration/catalogue/*.json` plus the reviewed design sources consumed by `build_catalogue.py` |
| Runtime catalogue | MySQL `cnr_*` catalogue tables |
| Station entry | `cnr_device_ou` |
| Station UI | `cnr_c_station.dlg.json` and its `cnr_a_*` / `cnr_c_*` handlers |
| Craft attempt, components, properties, tools and effects | `cnr_i_craft.nss` |
| Tradeskill XP and profession limit | `cnr_i_skill.nss` |
| Per-character crafting settings | `cnr_i_setting.nss` |
| Character identity | `src/pwdb/nss/` and the module hooks documented under `documentation/database/` |
| Crafted `sute_her*` activation | `pb_mod_activate.nss` -> `pb_potion_inc.nss` |

The old `cnr_recipe_utils` and `cnr_recipe_init` code still supports retained
stock CNR consumers outside the database station path. It is not the owner of
the migrated station catalogue and must not be used as evidence that recipes
still load from module locals.

## Documentation rules

- Record current behaviour from source and database evidence; mark inference as
  inference.
- A finished plan is folded into the document that owns current behavior and
  deleted, or moved under `history/` when its investigation remains useful as
  provenance. It must not remain labelled active.
- `open-issues.md` is the single place for anything unfinished. Delete an entry
  when it closes instead of annotating it, and do not restate its contents in
  another document.
- NWScript source is Windows-1252. Search it as text and preserve its encoding.
- Compilation, packaging, server startup, database execution, and in-game
  validation are performed only when explicitly authorized by the release
  owner.
