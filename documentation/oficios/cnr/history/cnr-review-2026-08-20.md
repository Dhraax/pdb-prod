# CNR Review Follow-up — 2026-08-20

Status: **implemented, 2026-08-20.** Every finding below was corrected in its
own slice, each one externally audited before its commit:

| ID | Commit | Audit id | Verdict |
|----|--------|----------|---------|
| CNR-1, CNR-4 | `50275db25` | `listmode` | PASS, one advisory fixed |
| CNR-2 | `c74f7bab7` | `danofisico` | closed by regenerating the catalogue |
| CNR-3 | `9c3f2d8a2` | `nodoplot` | two blockers fixed |
| CNR-5 | `631791d07` | `nodomod` | one blocker fixed |
| CNR-6 | `0727702ee` | `varfallback` | PASS, no findings |
| CNR-7 | this slice | `docsclean` | see below |

The manual runtime validation listed at the end of this document is **not**
covered by any of that and is still owed. The text below is kept as written, as
the record of what was found.

## Purpose

This document records the actionable findings from the review of the CNR work
committed between 2026-08-17 and 2026-08-20. The reviewed range was
`71fe902df..b571eb38c`, together with the local working tree as it existed on
2026-08-20.

The implementation should treat the first three findings as release blockers.
The remaining findings should be completed in the same correction slice when
possible because they affect the same menu, harvesting, catalogue, and
documentation boundaries.

## Protected Local Change

`haks-2da/baseitems.2da` is intentionally outside this correction slice.

The committed changes from `24b4c6efc` and `e159558be` raise the stack size of
the relevant miscellaneous material base items from 1 to 10. That behavior is
intentional and must remain. The current uncommitted difference is only a
whole-file LF-to-CRLF representation change; ignoring carriage returns produces
an empty semantic diff. Do not stage, rewrite, normalize, or revert this file
while implementing the findings below.

## Priority Summary

| ID | Priority | Finding | Main consequence |
|----|----------|---------|------------------|
| CNR-1 | Blocker | Variant pagination uses the recipe-list route | Variant pages after the first contain invalid IDs |
| CNR-2 | Blocker | `migration/03_catalogue.sql` is stale | Corrected material names are not deployable through the migration |
| CNR-3 | Blocker | Harvesting nodes are destructible | A permanent node can disappear and cannot refill |
| CNR-4 | High | Typed recipe IDs bypass variant selection | Variant recipes cannot be completed through the ID route |
| CNR-5 | Medium | Negative ability modifiers truncate toward zero | Low ability scores receive an incorrect harvesting bonus |
| CNR-6 | Medium | Variant fallback is assigned after recipe SQL generation | Future catalogue changes can serialize the wrong fallback blueprint |
| CNR-7 | Medium | Documentation and technical comments are stale or non-English | Repository documentation no longer describes the implemented system |

## CNR-1 — Variant Pagination Uses the Recipe-list Route

### Evidence

`src/cnr/nss/cnr_i_craft.nss:520-570` loads a page of variants using
`CNR_VAR_PAGE`, `CNR_VAR_ITEM*`, `CNR_VAR_HAYMAS`, and `CNR_VAR_COUNT`. It does
not record that the active list is a variant list.

`src/cnr/nss/cnr_a_page.nss:21-29` recognizes only two list states:

- `CNR_VAR_INPRODUCTS != 0`: call `CnrCraft_ListRecipes()`;
- otherwise: call `CnrCraft_ListCategories()`.

The variant screen is entered from the recipe list, so
`CNR_VAR_INPRODUCTS` remains true. Pressing next or previous on that screen
therefore replaces the variant slots with recipe rows.

`src/cnr/nss/cnr_a_pick.nss:23-32` then sees a selected recipe with a non-empty
variant group and no selected variant, and stores the slot ID as
`CNR_VAR_VARIANT`. The slot now contains a recipe ID rather than a variant ID.
`CnrCraft_ResolveProduct()` rejects it unless an accidental numeric collision
selects a valid variant.

### Required Behavior

The menu state must distinguish all three list kinds:

1. categories;
2. recipes;
3. variants for the selected recipe.

Page actions must reload the same list kind that is currently displayed.
Entering and leaving the variant screen must set and clear that state
explicitly. A stale recipe, category, or variant ID must never be interpreted
as an ID from another list kind.

Prefer one explicit list-mode variable over adding more overlapping Boolean
flags. If the existing Boolean is retained for compatibility, add a distinct
variant-list state and define its precedence in the page, pick, and back
actions.

### Files to Inspect

- `src/cnr/nss/cnr_i_craft.nss`
- `src/cnr/nss/cnr_a_page.nss`
- `src/cnr/nss/cnr_a_pick.nss`
- `src/cnr/nss/cnr_a_back.nss`
- `src/cnr/nss/cnr_a_browse.nss`
- `src/cnr/nss/cnr_c_var.nss`
- `migration/build_station_dlg.py`
- `src/cnr/dlg/cnr_c_station.dlg.json`

### Acceptance Criteria

- Next and previous on a variant screen load variants from the same group.
- The first, middle, and last pages expose the expected products without
  duplicates or recipe IDs.
- Selecting a product from every page resolves its `base_resref` and display
  name through the selected recipe and group.
- Previous is unavailable or harmless on page zero; next is unavailable or
  harmless after the last page.
- Back from the variant screen returns to the recipe list, not to categories or
  an unrelated detail screen.
- Returning to browsing clears the prior recipe, variant, and variant-group
  state.

## CNR-2 — The Generated Catalogue Is Stale

### Evidence

The deterministic check currently fails:

```text
$ python3 migration/build_catalogue.py --check
ERROR: migration/03_catalogue.sql is stale; regenerate the catalogue
```

`migration/03_catalogue.sql:281-282` and `:1084-1085` still contain the old
color codes for obsidian and jet material names. The authoritative blueprint
names now use the corrected neutral color:

- `src/cnr/uti/bru_obs.uti.json:47`;
- `src/cnr/uti/bru_aza.uti.json:47`;
- `src/cnr/uti/polvo_obs.uti.json:46`;
- `src/cnr/uti/polvo_aza.uti.json:46`.

A temporary regeneration showed only `migration/03_catalogue.sql` as stale;
`migration/02_seed.sql` matched its generated output.

### Required Change

Regenerate the catalogue with `migration/build_catalogue.py`. Review the exact
diff before accepting it. The expected semantic change is limited to the four
corrected obsidian and jet display names unless another source change is made
as part of this correction slice.

Do not apply the migration to a live database as part of this task. Running
`db-apply.sh` remains an explicit user-controlled deployment action.

### Acceptance Criteria

- `python3 migration/build_catalogue.py --check` exits successfully.
- `migration/02_seed.sql` remains unchanged unless a separately justified
  source correction requires it.
- The four recipe/component names in `migration/03_catalogue.sql` match their
  authoritative blueprint names.
- No recipe IDs, public IDs, component quantities, base resrefs, or variant
  group assignments change accidentally.

## CNR-3 — Harvesting Nodes Are Destructible

### Evidence

All 44 harvesting node blueprints under `src/cnr/utp/` were found with
`Plot.value = 0`. For example:

- `src/cnr/utp/cnr_veta_hierro.utp.json:47-50` gives the node 10,000 HP;
- `src/cnr/utp/cnr_veta_hierro.utp.json:97-100` leaves `OnDeath` empty;
- `src/cnr/utp/cnr_veta_hierro.utp.json:117-120` assigns
  `OnMeleeAttacked = cnr_node_hit`;
- `src/cnr/utp/cnr_veta_hierro.utp.json:149-152` sets `Plot = 0`.

The 49 harvesting-node instances placed in
`src/module/git/testarea_oficios.git.json` also have 10,000 HP and `Plot = 0`.
Placed instances carry their own fields, so correcting only the blueprints
would not correct the existing test-area nodes.

This contradicts the permanent-node contract in
`documentation/oficios/cnr/harvesting-nodes.md:212`: the node refills after two
hours and is not replaced or removed. Sustained attacks can exhaust its HP;
with no death handler, it then cannot refill.

### Required Behavior

A harvesting node must receive melee-attack events but must not be removable by
ordinary combat damage. Establish the protection mechanism after confirming
the engine behavior of the selected placeable flags. Apply the resulting field
contract to both:

- every harvesting node blueprint owned by `src/cnr/utp/`;
- every existing harvesting node instance in
  `src/module/git/testarea_oficios.git.json`.

Do not add a heartbeat or repeated repair loop. The existing event-driven
harvesting path must remain event-driven.

### Acceptance Criteria

- All 44 node blueprints and all 49 test-area instances use the same permanent
  node protection contract.
- Repeated attacks still run `cnr_node_hit`.
- Attacks cannot destroy or remove a node before or after depletion.
- Depletion and the two-hour refill timer continue to work.
- No station or unrelated placeable is changed by the bulk edit.

## CNR-4 — Typed Recipe IDs Bypass Variant Selection

### Evidence

`src/cnr/nss/cnr_a_byid.nss:15-21` calls `CnrCraft_SelectRecipe()` and then
immediately calls `CnrCraft_SetDetailToken()`. It does not call
`CnrCraft_ListVariants()`.

The generated dialogue mirrors that behavior. In
`migration/build_station_dlg.py:70`, the `Crear por ID` reply links to the
detail conditional and the start screen, but not to the variant conditional.

The detail conditional in `src/cnr/nss/cnr_c_det.nss:14-21` accepts any
selected recipe. The later craft attempt calls `CnrCraft_ResolveProduct()` and
reports `Elige primero que quieres fabricar` when no variant was selected. The
player has no variant chooser on that route and must back out.

### Required Behavior

Typing the public ID of a fixed-product recipe should continue to open its
detail directly. Typing the public ID of a variant-group recipe should load the
first variant page and open the variant-selection screen before detail.

Use the same state initialization and cleanup as normal recipe browsing. Do not
create a second variant-selection implementation for the typed-ID route.

### Acceptance Criteria

- A valid fixed-product ID opens the existing detail screen.
- A valid variant recipe ID opens the first variant page.
- Selecting a variant then opens detail and crafts the selected product.
- An invalid ID still reports the existing error and does not retain stale
  recipe or variant state.
- The generated dialogue matches `migration/build_station_dlg.py` exactly.

## CNR-5 — Negative Ability Modifiers Truncate Toward Zero

### Evidence

`src/cnr/nss/cnr_i_node.nss:389-395` calculates the harvesting ability
modifier as:

```nwscript
int nMod = (nScore - 10) / 2;
```

NWScript integer division truncates toward zero. The result is therefore wrong
for negative odd dividends: score 9 yields 0 instead of -1, and score 7 yields
-1 instead of -2.

The repository already handles this rule explicitly in
`CnrCraft_FloorDivide()` at `src/cnr/nss/cnr_i_craft.nss:846-859`. Do not add a
dependency from harvesting to the complete crafting include solely to reuse
that helper; keep the include chain shallow.

### Required Behavior

Calculate `floor((score - 10) / 2)` for both positive and negative values. A
small harvesting-local helper is acceptable if it follows the include's
prototype and documentation rules.

### Acceptance Criteria

| Ability score | Modifier |
|---------------|----------|
| 7 | -2 |
| 8 | -1 |
| 9 | -1 |
| 10 | 0 |
| 11 | 0 |
| 12 | +1 |

The roll message and DC comparison must use the same corrected modifier.

## CNR-6 — Variant Fallback Is Assigned After SQL Generation

### Evidence

`migration/build_catalogue.py:1726-1750` serializes every recipe into
`recipe_sql`, including its current `recipe.base_resref`.

The variant document is not loaded until `:1752`. The first variant of each
group is collected into `variant_first`, and `:1779-1790` then assigns that
resref back to each grouped recipe. This mutation occurs after the SQL strings
have already been built, so it cannot change the emitted recipe rows.

The current sources happen to name the same base resref as the first variant,
which hides the ordering defect. A future catalogue reorder can silently emit
the wrong fallback while the comment claims the first variant is guaranteed.

### Required Change

Validate and assign variant-group fallbacks before recipe SQL is serialized, or
serialize the recipe rows only after all recipe mutations are complete. Keep
the existing validation that rejects an undefined group or a variant blueprint
that does not exist under `src/cnr/uti/`.

### Acceptance Criteria

- Every grouped recipe emitted in `migration/03_catalogue.sql` uses the first
  variant declared for that group as its fallback `base_resref`.
- Reordering the first variant in a temporary copy of the source data changes
  the generated recipe fallback deterministically.
- Undefined groups and missing blueprints still fail generation clearly.
- The normal generated files remain deterministic and pass `--check`.

## CNR-7 — Documentation and Technical-language Cleanup

### Evidence

`documentation/oficios/cnr/open-issues.md:143` still says "Harvesting does not
exist" and describes harvesting nodes as future work. That statement became
false when the new node system was added. The same document requires closed
entries to be deleted rather than annotated.

`migration/build_station_dlg.py:21-31`, `:48`, `:59`, `:64-65`, and `:74`
contain Spanish technical comments. Player-facing Spanish dialogue text is
correct, but repository code and comments must be written in English.

Several historical commit subjects in the reviewed range are also Spanish.
They violate the repository convention, but existing commit history must not be
rewritten as part of this correction.

### Required Change

- Delete or replace the obsolete harvesting entry in `open-issues.md` according
  to that document's own lifecycle rules.
- Review adjacent CNR documents for statements that harvesting is not yet
  implemented, and update only claims made obsolete by the new system.
- Translate technical comments in `build_station_dlg.py` to English without
  translating Spanish player-facing strings.
- Use English for future commit messages. Do not rewrite existing commits.

### Acceptance Criteria

- Canonical CNR documents consistently describe harvesting as implemented but
  still requiring runtime validation where appropriate.
- No source comment added or materially edited by this slice is in Spanish.
- Player-visible menu and item text remains Spanish.

## Required Static Verification

After implementation:

1. Inspect the focused diff and confirm that `haks-2da/baseitems.2da` was not
   included.
2. Run `python3 migration/build_catalogue.py --check`.
3. Regenerate the station dialogue in a temporary location or with the
   repository generator and confirm that
   `src/cnr/dlg/cnr_c_station.dlg.json` is exact.
4. Parse every changed JSON file.
5. Run Python syntax validation for each changed generator.
6. Run `git diff --check` and resolve new whitespace errors without normalizing
   unrelated legacy files.
7. Search every changed CNR include for direct executable consumers.

Every modified `.nss` file must pass the mandatory focused compilation from
`AGENTS.md`. Pass every changed executable script explicitly. For a changed
include, also pass at least one representative direct executable consumer and
every executable consumer modified in the same slice. `cnr_node_hit.nss` is the
representative consumer for harvesting include changes. Never replace this with
a bare full-source `--check`.

Do not package the module, apply database migrations, start Docker or the
server, or run deployment scripts unless the user explicitly requests those
actions.

## Manual Runtime Validation

Static checks cannot establish engine behavior. The completed correction needs
the following focused in-game checks:

1. Browse a variant group with more than five products through every page,
   select products from the first, middle, and last pages, and craft them.
2. Repeat the fixed-product and variant-product paths using typed public IDs.
3. Use previous and back from every variant page and confirm the menu returns to
   the expected level without stale slot labels or IDs.
4. Attack one node from each family repeatedly before and after depletion.
   Confirm that hit events, tool checks, yields, depletion, and refill work and
   that no node can die or disappear.
5. Compare harvesting rolls for ability scores 7 through 12 against the table
   in CNR-5.
6. Confirm that obsidian and jet recipe/component names display legibly after
   the regenerated catalogue is applied in a separately authorized deployment.
