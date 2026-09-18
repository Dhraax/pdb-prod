# Legacy Professions Removal and Production Promotion

Status: development cleanup and static catalogue verification performed on
2026-08-11. The generated catalogue check passes. A compile attempt made before
the potion include repair failed only on the invalid
`sute_potion_activate` resref; compilation has not been rerun after the repair.
Packaging, server startup, production database execution, and in-game
validation remain pending.

This document is the operational record for removing the former profession
runtime and promoting the CNR implementation to production.

Use it together with the database-owned
[`pwdb-cnr-production-port.md`](../../database/pwdb-cnr-production-port.md).
That document owns identity/schema transfer; this one owns profession resources,
stations, catalogue release state, potion activation, collection gates, and the
combined smoke test. Both checklists must pass.

## 1. Ownership boundary

The CNR implementation is now the only intended owner of profession creation:

- `src/cnr/nss/cnr_i_craft.nss` owns the craft attempt, component checks, roll,
  XP, item creation, and output properties.
- `src/cnr/dlg/cnr_c_station.dlg.json` and `cnr_c_station` own the station UI.
- `migration/catalogue/*.json` owns recipe definitions. Generated SQL is
  produced from that catalogue.
- CNR station placeables use `cnr_device_ou` on `OnUsed`; that adapter
  explicitly starts `cnr_c_station`. Production station tags are the values
  seeded in `migration/02_seed.sql`.
- `src/cnr/nss/pb_potion_inc.nss` remains live. Its
  `usarPocionHerboristeria()` path is intentionally preserved for activation
  of `sute_her*` potion outputs after crafting. The retained herbalism/alchemy
  potion blueprints and materials remain in `src/shared/uti/`.

The old profession runtime no longer owns creation, recipes, profession
manuals, shops, mining, plant collection, or station open/close behavior.

## 2. Development cleanup performed

The following source families were removed from `src/shared/nss/`:

| Family | Removed responsibility |
|--------|------------------------|
| `carp_*` | Carpentry, lumber, sawing, old carpenter shops and recipes |
| `orf_*`, `eng_*` | Old jewelry, gem cutting and socketing |
| `yunque_*` | Old anvil crafting and repair station handlers |
| `minero*`, `minerogemas`, `recolector*` | Old mining, gem mining and plant collection |
| `abre_*`, `cierra_*` profession handlers | Old alchemy, herbalism, cooking, smelting and leather stations |
| `pb_ofi_*` | Old arcane crafting and infusion runtime |
| `sapo_*` craft runtime | Old leather recipe engine, manuals, sellers and action handlers |
| `sute_her_c_*`, `sute_met_c_*` | Old material/manual purchase conversations and handlers |
| old profession vendor handlers | Old profession-specific shop behavior |

Only profession books/manuals and arcane diagrams were removed from the
resource layer:

- `carp_libro*`, `orf_libro*`, and `pb_ofi_man_artes` books/manuals;
- `pb_ofi_artdiag*` arcane diagrams.

This removal did not delete narrative, quest, reward, poison, summoning, or
other non-profession books. The deleted item-blueprint set contains exactly 28
profession resources: the Carpentry, Jewelry, and Weave Crafting manuals plus
the 25 Weave Crafting diagrams.

### Retained legacy manuals with removed runtime routes

Three profession manual blueprints remain in `src/shared/uti/`, but the cleanup
removed their old acquisition and activation paths:

| Blueprint | Name and tag | Removed legacy routes | Result after cleanup |
|-----------|--------------|-----------------------|----------------------|
| `manualdelcuero.uti.json` | Manual de Peletería; tag `sapocuelib` | `sapo_lib_cue`, `sapo_lib_cue0`, and the `ManualPeleteria()` branch in `pb_mod_activate` | Blueprint remains, but the old leather conversation can no longer grant it and activation no longer displays profession state |
| `libroherborister.uti.json` | Manual de Herboristería; tag `libroHerboristeria` | `sute_her_c_d_lib`, `sute_her_c_t_lib`, and the `ManualHerboristeria()` branch in `pb_mod_activate` | Blueprint remains, but the old herbalism conversation can no longer grant it and activation no longer displays profession state |
| `libroherreria.uti.json` | Manual de Herrería; tag `libroHerreria` | `sute_met_c_d_lib`, `sute_met_c_t_lib`, and the `ManualHerreria()` branch in `pb_mod_activate` | Blueprint remains, but the old smithing conversation can no longer grant it and activation no longer displays profession state |

These are retained profession assets with retired legacy behavior, not
unrelated books accidentally removed by the cleanup. They may be inert unless
another runtime path grants or handles them. Production promotion must make an
explicit per-blueprint decision: remove the obsolete manual, retain it as
non-interactive lore, or connect it to an approved CNR help/status path. Do not
silently preserve an assumed working manual and do not delete it merely because
its old script was removed.

Tools, materials, potion blueprints, profession objects, station blueprints,
vendor/store objects, and collection source objects remain available as
resources. Their old non-CNR handlers are removed or must be replaced by CNR
handlers before the corresponding gameplay is enabled.

Standalone old profession conversations such as `oficios_*`,
`sapo_artes_arca`, `sapo_cmcueros`, `quim_curtidor`, `curtidor`, and the
`sute_*_c_base` conversations were removed.

The generic CNR blueprints were retained. `herreria_yunque` and
`sute_met_forja` were rewired to the generic CNR device path and tags
`cnrAnvilSmith` and `cnrForgePublic`. Existing CNR blueprints such as
`pb_ofi_infusion`, `sute_her_caldero`, `sapo_9_curtidero`, and
`sapo_mesa_marroq` were retained because the catalogue still uses them.

`pb_mod_activate.nss` now retains only the `sute_her*` potion activation branch
from the old profession section. The potion implementation was isolated in
`pb_potion_inc.nss`; its effect table is unchanged from the retained
portion of the former library. The obsolete arcane migration block in
`wrap_bp.nss` and the old manual display functions in `mti_libreria.nss` were
removed. Weapon repair in `dote_romarm4.nss` now reads the CNR smithing level
instead of `NIVELHERRERIA`.

Two active catalogue outputs deliberately do not execute a potion effect:
`sute_her_DM1` is the non-effect Pure Water output, and
`sute_her_128_075_n_FoodRICH` is the food-tagged Magic Cookie output. The
activation include returns immediately for both tags before parsing a potion
ID.

### Post-cleanup potion activation repair

The first full compilation after the legacy cleanup exposed an invalid include
resref: `sute_potion_activate` was 20 characters long, while NWN resource names
are limited to 16. The include was renamed to `pb_potion_inc` (13 characters),
and `pb_mod_activate.nss` was updated to include that boundary. The unused
`mti_libreria` dependency was removed from the potion include; the dependencies
used by the retained effects remain.

Static comparison against the former `sute_libreria.nss` implementation found
the complete 1,561-line effect table unchanged. The active catalogue contains
36 numeric `sute_her` effect tags covered by that table, plus the two explicit
no-effect outputs described above. The source remains Windows-1252, and the
post-repair resref audit found no `.nss` basename longer than 16 characters.

This repair has not yet passed a clean compilation, package inspection, or
in-game activation test. Those checks remain release gates in sections 4 and 5.

## 2a. Consolidated implementation state

The existing CNR documentation records the data-layer migration separately.
This table joins that record to the legacy cleanup so a production promotion
does not confuse completed work with future work:

| Area | Consolidated state | Canonical evidence |
|------|--------------------|--------------------|
| Recipe authorship | The original authoring plan is closed. JSON is the authored source and the generator no longer reads station recipe `.nss` files. The current generated snapshot is 77 materials, 36 categories, 487 recipes, 993 components, and 591 properties. | `catalogue-authoring-plan.md`, `migration/catalogue/`, `migration/03_catalogue.sql` |
| Craft runtime | Generic CNR station UI, craft attempt, components, rolls, output properties, tools, XP and persistence are implemented; clean compile and in-game validation remain pending. | `crafting-system.md`, `cnr_i_craft.nss` |
| Station routing | Ten stations and eleven tool requirements are seeded. All ten placed DEV test-area stations use `cnr_device_ou` and carry `cnr_c_station`; the adapter also names that conversation explicitly. Two retained smithing blueprints have an empty Conversation field and should be normalized before production. Production-only areas still require an inventory. | `crafting-system.md`, this cleanup |
| Carpentry | Two stations, eight woods, and 86 recipes are generated. Recipe properties, their item-level runtime proof, and harvesting remain open. | `carpentry-plan.md` |
| Tailoring | Profession and `cnrSewingTable` station scaffold exist; the catalogue has zero recipes. | `crafting-system.md` |
| Arcane crafting | Profession exists; no current station rows or recipes exist. | `crafting-system.md` |
| Potion activation | `pb_mod_activate` includes the valid 13-character `pb_potion_inc` boundary. Its 36 numeric effects match the former table and two active non-effect outputs return explicitly. Clean compile and runtime activation remain pending. | Section 2 above, `open-issues.md` |
| Legacy scripts | 287 old profession `.nss` scripts were removed. The retained activation boundary is `pb_mod_activate` -> `pb_potion_inc` -> `usarPocionHerboristeria`. | This cleanup and source diff |
| Resource preservation | No profession tools, materials, potion blueprints, profession objects, stores, or station/collection source objects were removed. Only the 28 profession books/manuals/arcane diagrams listed above were deleted; no `.utp` or non-profession book was deleted. The three retained legacy manual blueprints have lost their old acquisition/activation routes and require an explicit production decision. | Section 2 above, source diff, and palette diff |
| Collection | The old non-CNR handlers were removed and this slice deliberately promoted nothing in their place. **Superseded on 2026-08-18**: harvesting was rebuilt on its own nodes and scripts, and the gap in section 3 is closed. | `harvesting-nodes.md` |

The data catalogue being complete does not mean the module is production-ready:
the CNR documentation still marks runtime validation as pending. The collection
mapping that this sentence used to defer was built on 2026-08-18 and is
described in `harvesting-nodes.md`; it has not been played through either.

## 3b. Current testing tradeskill curve

The 2026-09-18 balance slice replaces the old 25000-XP curve with a shared
5000-XP level-20 curve. The current thresholds and assumptions are owned by
[crafting-system.md](crafting-system.md), section 4c. The previous August
curve-widening and compensation discussion is superseded; its historical
reasoning remains in Git history.

This testing change introduces no character-data migration. Recipe XP, DC,
profession limits and collection nodes remain unchanged. Packaging and fresh
character validation remain separate host acceptance gates.

## 2b. Verification record — 2026-08-11

The following read-only/static checks were completed during consolidation:

```text
materials     : 77
categories    : 36
recipes       : 487
components    : 993
properties    : 417
external refs : 18
```

- `python3 migration/build_catalogue.py --check` completed successfully and did
  not rewrite generated SQL.
- The active potion switch was compared with the deleted library boundary: all
  1,561 effect-table lines match.
- All `.nss` basenames currently fit NWN's 16-character resref limit.
- `pb_mod_activate.nss` reaches `pb_potion_inc.nss`; no live source includes
  `sute_potion_activate` or the deleted `sute_libreria` boundary.
- The new include remains Windows-1252.

These checks do not prove compilation, packaging, database contents, server
startup, or in-game behaviour. The release owner must perform those gates below.

## 3. Collection gap — closed on 2026-08-18

**This section is history.** It is kept because the promotion record should show
what was owed and how it was settled, not because anything here is still open.

What it described: the repository's classic CNR source scripts registered
generic tags such as `cnrRockIron`, `cnrTreeOak` and `cnrAloePlant`, while the
live development resources used project-specific ones (`sute_met_m*`, `veta_*`,
`sute_her_p*`) with handlers this cleanup removed. The cleanup kept the source
objects and their materials without inventing a replacement mapping, so recipes
could exist in the database while their ore, wood, gem and plant inputs could
not be collected in game. Promotion was blocked on choosing between adapting
CNR's registrations or migrating every map instance to standard CNR tags.

Neither was chosen. Harvesting was rebuilt instead, on 44 nodes of the
project's own (`cnr_*` blueprints, `cnr_i_node` and `cnr_node_hit`), which yield
the material tags the catalogue already consumes. See `harvesting-nodes.md`.

**It still gates promotion, for a different reason:** none of it has been played
through. Built is not validated.

The old test area still contains embedded placeable instances with the removed
event resrefs (`minero`, `minerogemas`, and `recolector2`). The placeable/source
resources themselves remain available, but the area is not a valid promotion
fixture until those instances are replaced by a tested CNR fixture.

The item palette was updated only to remove the 28 book/manual/diagram entries.
The retained carpentry tool entries (`cnr_t_kit_carp`, `cnr_t_kit_serr`,
`cnr_t_sierra`) and the material/potion entries remain available for CNR and for
the later collection decision.

Some remaining NPC/dialog resources still reference deleted historical
conversation scripts: seven `.dlg` files (`cromwell`, `gof_inuslarga`,
`jj_toigan`, `ko_nash_hansen`, `mainah_mda`, `ormc_tienda`, `oro_im`) and 17
`.utc` files reference `sute_met_c_*` or `sute_her_c_*`. This is a real
pre-production blocker. Audit those branches and either remove them or replace
them with the CNR station conversation; do not leave a player-facing branch
pointing at a missing resource.

## 4. Exact production promotion sequence

Run this sequence from a release branch or a production deployment checkout.
Do not run it against production until the collection gap above has an exit
test.

### 4.1 Freeze and backup

1. Announce a maintenance window and stop profession changes during the
   migration.
2. Record the exact source commit and the generated module artifact.
3. Back up the production database, the module file, server configuration, and
   player inventories/character persistence according to the server runbook.
   Never place credentials in this document or in command output.
4. Record active crafting sessions and settle or cancel them before deployment.

### 4.2 Database migration

Apply migrations using the repository's approved database workflow, in this
order:

1. PWDB identity schema and hooks from
   [`pwdb-cnr-production-port.md`](../../database/pwdb-cnr-production-port.md).
2. `migration/cnr/00_player_state_schema.sql`.
3. `migration/01_schema.sql`.
4. `migration/02_seed.sql`.
5. `migration/03_catalogue.sql` generated from the reviewed catalogue.
6. Validate counts, station tags, recipe base resrefs, component tags, and
   character tradeskill rows.
7. Apply `migration/04_drop_legacy.sql` only after the validation query set
   passes and the rollback backup is confirmed. This removes obsolete CNR
   catalogue tables; it is not a player-state migration.

Do not apply `migration/legacy-catalogue-seed.sql` to production. It is
provenance for the retired runtime, not a production migration.

### 4.3 Module and placeable promotion

1. Verify every production station instance has the intended CNR tag.
2. Verify every station blueprint/instance uses `cnr_device_ou` on `OnUsed`
   and `cnr_c_station` as its conversation.
3. Verify no production area contains an old `OnOpen`, `OnClosed`,
   `OnMeleeAttacked`, or `OnDeath` profession handler.
4. Verify all CNR output base resrefs and tags still exist in `src/shared/uti/`
   and are present in the package.
5. Verify the module activation event still reaches `pb_mod_activate.nss` and
   that a crafted `sute_her*` potion still reaches
   `pb_potion_inc.nss`.
6. Normalize the Conversation field on `herreria_yunque` and
   `sute_met_forja`, then verify all production blueprints and instances show
   `cnr_c_station` even though the adapter also selects it explicitly.
7. Inventory every deleted `.uti` by visible name and confirm that the removal
   is limited to the same 28 profession manuals/diagrams. Preserve every
   narrative, quest, reward, poison, summoning, and other non-profession book.
8. Decide explicitly whether `manualdelcuero`, `libroherborister`, and
   `libroherreria` are removed, retained as non-interactive lore, or connected
   to a CNR path. Verify that no production dialog or event still expects the
   removed `sapo_lib_*`, `sute_*_c_*_lib`, or old `Manual*()` handlers.

### 4.4 Build and deploy

The release owner must run the normal development-equivalent build with the
production checkout and target configuration:

```bash
./linux_build.sh --check \
  pb_mod_activate.nss \
  cnr_device_ou.nss \
  cnr_a_craft.nss

./linux_build.sh --clean
```

Then inspect the packaged `PB_EE_PGCC.mod`. Confirm that the package contains
the CNR scripts, conversations, station blueprints, catalogue-backed item
blueprints, retained potion blueprints/materials, and
`pb_potion_inc.nss`. Confirm that it does not contain the removed legacy
scripts or the 28 removed profession book/manual/diagram resources. Confirm
that unrelated book resources remain present, and verify the reviewed outcome
for the three retained legacy manuals. Deploy only after the artifact
inspection succeeds.

### 4.5 Smoke test order

Run on a private test character first:

1. Enter with a persisted character and confirm CNR tradeskill levels load.
2. Open each seeded station and browse categories without components.
3. Craft one success and one failure per representative station.
4. Confirm component consumption, tool behavior, XP persistence, and output
   properties.
5. Craft an alchemy output, activate the resulting `sute_her*` item, and
   confirm the potion effect path works.
6. Activate Pure Water and the FoodRICH Magic Cookie and confirm that neither
   applies a potion effect.
7. Test collection only after the project-specific CNR mapping has passed:
   plant, wood, ore, gem, and any special herb source.
8. Confirm repair behavior uses CNR smithing progression.
9. Confirm no old manual, profession shop, or legacy station conversation is
   reachable.
10. Reconnect the character and verify tradeskill state and inventory remain
   correct.

### 4.6 Rollback

1. Stop the server and prevent new logins.
2. Restore the previous module artifact and previous source-backed deployment.
3. Restore the database backup if any migration or data validation failed.
4. Revert only the deployment commit after the external backup is confirmed.
5. Record the failure, affected character IDs or sessions, and the first
   failing smoke test before attempting another promotion.

## 5. Exit criteria

Promotion is complete only when all of these are true:

- clean compile and package completed;
- database migrations and validation queries completed;
- all station instances use CNR routing;
- collection mapping has a tested owner and no old collection handler;
- potion activation through `pb_potion_inc.nss` passed;
- representative craft, failure, XP, tool, persistence, and reconnect tests
  passed;
- rollback artifacts are available and the maintenance record is complete.
