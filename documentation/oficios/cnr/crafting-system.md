# Crafting System — Implementation

What was built, file by file, so it can be ported to production without
reverse-engineering it. Design rationale lives in
the original rework specification; the tables in
[`schema.md`](schema.md).

Status 2026-08-15: **implemented and built.** The module compiles and runs;
in-game validation is under way through the tester round. Stations route to the
generic engine, crafting consumes materials and creates items, and tradeskill
XP persists. Recipe authorship has
moved out of NWScript into `migration/catalogue/*.json` — see
`build_catalogue.py` for the completed
authoring record. The engine runs each station's migrated animation and sound
and enforces the tools in `cnr_station_tool`.

---

## 1. What replaces what

| Before | After |
|--------|-------|
| 7 station `.nss`, 3499 lines of hand-written recipes | `cnr_device_ou` and the generic `cnr_i_craft` engine |
| Recipes declared in NWScript | Rows in `cnr_recipe` |
| Submenus as module local variables | `cnr_category`, a tree |
| `cnr_c_recipe` conversation | `cnr_c_station` |
| Properties resolved by `material + type + gem` | `cnr_recipe_property`, per recipe |

The migrated station scripts, their legacy conversation, and its 17 handlers
were removed after every source-controlled station instance was audited. There
is no fallback to the old recipe engine.

---

## 2. Files

### Database (migration/)

| File | Purpose |
|------|---------|
| `01_schema.sql` | Eight catalogue tables including station tools. Drops and recreates catalogue only, never player state |
| `02_seed.sql` | 7 professions, 10 stations, 11 station tools and 77 materials with tiers |
| `03_catalogue.sql` | The generated catalogue: 36 categories, 487 recipes, 993 components, 591 properties |
| `build_catalogue.py` | Validates CSV/JSON/UTI inputs and regenerates both seed and catalogue SQL |
| `catalogue/*.json` | **The authored recipe source.** Ten registered stations, including two Carpentry stations and the empty Sastrería scaffold; legacy recipe `.nss` files are no longer read |
| `extract_catalogue_json.py` | Retired one-shot extractor retained as migration provenance; its station-script inputs no longer exist |

DEV application is recorded in the catalogue audit log. Production must apply
the numbered SQL through the approved migration workflow and validate the
generated counts; never infer production state from the DEV record.

### NWScript (src/cnr/nss/)

| File | Role |
|------|------|
| `cnr_i_craft.nss` | **The engine.** Station lookup, category and recipe listing, detail, materials check, roll, craft |
| `cnr_i_prop.nss` | Property helpers: weapon physical type, opposite type, die translation |
| `cnr_device_ou.nss` | Inventory-station adapter. Bound to `OnUsed`; opens `cnr_c_station` after inventory closes |
| `cnr_apply_prop.nss` | Applies one property row to the crafted item |
| `cnr_c_start.nss` | Conversation gate; refreshes header tokens |
| `cnr_c_slot.nss` | Shows list line `idx` when the page has one |
| `cnr_c_next.nss` / `cnr_c_prev.nss` | Pagination visibility |
| `cnr_a_browse.nss` | Enter the category list |
| `cnr_a_pick.nss` | Select line `idx`: descend, or open detail |
| `cnr_a_page.nss` | Page forward or back |
| `cnr_a_back.nss` | Up one level |
| `cnr_a_byid.nss` | Open detail for the id typed in chat |
| `cnr_a_craft.nss` | Run the attempt |
| `cnr_a_inv.nss` | Open the station inventory |

### Conversation (src/cnr/dlg/)

`cnr_c_station.dlg.json` — 4 entries, 23 replies.

| Entry | Screen |
|-------|--------|
| 0 | Root: create / create by ID / inventory / done |
| 1 | Categories, five slots plus navigation |
| 2 | Products, five slots plus navigation |
| 3 | Detail: craft / back / inventory / done |

The five slots are **reused** between screens through `ScriptParams` (`idx`
0-4), rather than ten separate scripts.

### Modified

`src/shared/nss/pb_chat.nss` — a hook at the very top of `main()` captures a
bare number as a recipe id while a station is open.

---

## 3. Conversation tokens

| Token | Content |
|-------|---------|
| 5000-5004 | The five list lines |
| 5010 | Station display name |
| 5011 | `Nivel de oficio: N` |
| 5012 | Detail screen |
| 5020-5032 | The reply buttons, one token per reply |

Set by `CnrCraft_SetHeaderTokens`, `CnrCraft_SetSlotTokens`,
`CnrCraft_SetDetailToken` and `CnrCraft_SetButtonTokens`.

### Material counts in detail

The detail entry condition rebuilds its token from the current shared station
inventory whenever that entry is evaluated. This applies to every crafting
table using `cnr_c_station`, including return after success, failure or a
material-shortage refusal. Components are consumed before animation starts,
so the next entry already reads the remaining quantities. No delayed callback
writes detail tokens, avoiding writes into a different selection after
navigation. Counts are snapshots on entry, rather than continuously refreshed
while another player changes inventory. Client display after node re-entry
still requires in-game validation; no forced restart or polling is used.

### Why the buttons are tokens

An NWN colour code is not text: it is the literal byte `<`, then `c`, then
**three raw bytes** for R, G and B, then `>`. The engine does not read one
inside dialogue text — it takes it for a token it does not know and prints
`UNRECOGNIZED TOKEN` around every label. Writing the colour into the `.dlg` was
tried in game on 2026-08-19 and left the whole menu unreadable; the bytes reach
the GFF perfectly intact, so checking them proves nothing about this.

The menu body was never affected because NWScript builds it at runtime with
`ColorToken()`, which the engine does read. So the replies use the same
mechanism: the `.dlg` holds a bare `<CUSTOM50xx>` with no colour of its own,
and `CnrCraft_SetButtonTokens` fills it already coloured.

### One token per reply — 2026-08-20

Thirteen replies, thirteen tokens, even where two of them read the same word.

They used to share by label, eight tokens for thirteen replies, and the three
labels that appear on more than one screen — `[Atras]`, `Abrir inventario` and
`Terminar` — were the ones that intermittently came up blank. The shared
numbering was the only difference between the two groups, so it is gone. Five
extra tokens is the whole cost.

**It did not fix it, and two claims here were wrong.** A tester reported on
2026-08-23 that a blank reply is still *there*: its number works, 6 pages
forward and 7 goes back. So a reply whose text resolves empty **is** shown, and
shared numbering was not the difference that mattered. What the reasoning missed
is that custom tokens are expanded by the client, not by the server, so thirteen
unique tokens ask a client for more than the eight they replaced. Read
[`open-issues.md`](open-issues.md) D5 before touching this: it carries the
corrected counts, what is established and what is still only a hypothesis.

`build_station_dlg.py` owns the order and prints the number-to-label map every
time it runs; `CnrCraft_SetButtonTokens` fills them in that same order.

**Custom tokens are refilled on every node.** `SetButtonTokens`
therefore runs from `cnr_c_start` *and* from each screen conditional
(`cnr_c_cat`, `cnr_c_prod`, `cnr_c_det`, `cnr_c_var`), not only when the
conversation opens. For the same reason **every entry link now carries a
condition**: a link with none paints its screen without running anything, and
that screen shows whatever the tokens last held. The fallbacks into the action
menu use `cnr_c_start`, and `[Crear nueva produccion]` uses `cnr_c_cat`.

Colour policy: buttons, station name, `Nivel de oficio:` and the detail labels
are green; the product list stays default, so the eye separates the data from
the controls.

---

## 3b. Pagination

`[Pagina siguiente]` must be hidden on the last page, and the only honest way to
know a page is the last one is to look past it. `CnrCraft_ListRecipes` and
`CnrCraft_ListCategories` therefore ask the database for **one row more** than
they can display:

```nwscript
NWNX_SQL_PreparedInt(3, CNR_PAGE_SIZE + 1);
...
if (nCount >= CNR_PAGE_SIZE) { bHayMas = TRUE; continue; }
...
SetLocalInt(oPC, CNR_VAR_HAYMAS, bHayMas);
```

The extra row is counted, never stored in a slot. `cnr_c_next` shows its reply
only when `CNR_VAR_HAYMAS` is set.

Before this, the next-page reply was always visible and the menu paged forever
into empty screens.

---

## 4. Player state during the menu

All on the PC, cleared naturally at logout.

| Variable | Meaning |
|----------|---------|
| `CNR_STATION_ID` | Station being used |
| `CNR_PLACEABLE` | The placeable, for inventory reads |
| `CNR_CATEGORY_ID` / `CNR_PARENT_ID` | Position in the tree |
| `CNR_PAGE` | Current page |
| `CNR_LIST_MODE` | Which list is on screen: 0 none, 1 categories, 2 recipes, 3 variants |
| `CNR_RECIPE_ID` | Selected recipe |
| `CNR_RECIPE_PAGE` | Recipe-list page restored from variant selection or detail |
| `CNR_VARIANT_GROUP` | Products the selected recipe offers, empty when it has a fixed one |
| `CNR_VARIANT_ID` | Which of those products the crafter picked |
| `CNR_TYPED_ID` | Id captured from chat |
| `CNR_SHOW_ALL` | Level filter toggle |
| `CNR_LIST_COUNT`, `CNR_LIST_n`, `CNR_LIST_ID_n` | Current page cache |
| `CNR_CRAFT_ACTIVE` | Prevents a second attempt while an animation is running |

### One list mode instead of two booleans — 2026-08-20

`CNR_LIST_MODE` is written by whatever builds a list — `CnrCraft_ListCategories`,
`CnrCraft_ListRecipes`, `CnrCraft_ListVariants` — and by `CnrCraft_ClearList`,
which sets it back to none. That is the only place the kind of a list is known
for certain, so it is the only place allowed to say.

It replaced `CNR_IN_PRODUCTS` and `CNR_AT_MENU`, which between them could not
describe the third screen. The variant list is entered **from** the recipe list,
so "browsing recipes" stayed true while it was up: `[Pagina siguiente]` refilled
the slots with recipes while the screen still asked which product to make, and
picking a line then stored a **recipe** id as the chosen variant.
`CnrCraft_ResolveProduct` rejected it, unless a numeric collision happened to
land on a real variant of the right group. A second flag had been bolted on to
mean "no list at all", because the category screen otherwise claimed every turn
nothing else wanted.

Each screen now reads the mode:

| Mode | Screen | Paging reloads | Picking a line means |
|--:|---|---|---|
| 0 | action menu, or a recipe's detail | — | — |
| 1 | categories | categories under the same parent | descend, or list that leaf's recipes |
| 2 | recipes | recipes of the same category | select that recipe |
| 3 | variants | variants of the same group | choose that product |

Choosing a product sets the mode back to none, because the detail screen is not
a list. `[Atras]` climbs by mode: variants to the recipe list, detail to the
recipe list it was picked from, recipes to categories, categories out to the
action menu.

**`CNR_RECIPE_ID` is a database id and the database can renumber it.**
`recipe_id` is assigned by `build_catalogue.py` in iteration order, so
rebuilding the catalogue moves rows: "Zafiro tallado" was 951 on 2026-08-17 and
is 246 now. Applying the catalogue to a live server therefore invalidates every
id a player is carrying, and the next craft attempt answers *"Esa receta ya no
esta disponible. Vuelve a elegirla."* — which is the recovery instruction:
picking the recipe again fixes it, and a restart fixes it for everyone. This
happened on the test server on 2026-08-19.

Both failures used to share one branch in `CnrCraft_Attempt`, so a real SQL
error looked exactly like a stale id. They are separate now and each writes its
own line to the engine log, `[CNR] Recipe lookup failed` against
`[CNR] Recipe N no longer resolves`. The detail joins the recipe category to recheck station ownership; the attempt
also joins station and profession. A missing station/profession relationship
can therefore still leave a detail whose attempt does not resolve.

---

### Output recipe and tier

Every main or extra output receives `CNR_CRAFT_RECIPE` and `CNR_CRAFT_TIER`,
including intermediate materials whose recipe does not set `CNR_OFICIO`.
Both values are captured before animation. Outputs are identified and stolen;
the copied main output is stamped again after inventory handoff. The dedicated
recycler consumes these locals under the contract in [`recycling.md`](recycling.md).

### Returning from detail or product selection

Recipe selection saves the current recipe-list page before the product picker
resets its own page. Back from product selection or detail restores that saved
page and reloads the recipe IDs and labels together. A typed selection from a
different category starts at page zero of its recipe's category. This change
preserves navigation context and does not alter button labels, custom-token
rendering or conversation destinations. The disappearing-label cause remains
unestablished and requires owner consultation before changes to that behavior.

### Cached recipe ownership

Detail and craft-attempt queries recheck that the selected `recipe_id` belongs
to the station currently open, using its `cnr_category.station_id`. Selection
already applies the same condition. A cached recipe from another station
cannot be described or executed; the attempt clears a selection that no longer
resolves and asks the player to choose again before any crafting costs. A valid
recipe with depleted materials stays selected and reports the missing materials.
This closes a source-level ownership gap; it does not establish the cause of
the tester's apparent Alchemy jump after socketing the last gem.

## 4b. Recipes that offer several products

A recipe row normally names its product in `base_resref`. A recipe with
`variant_group` set does not: it offers the products of that group and makes
the one the crafter picks.

It exists because a dagger of steel and a mace of steel are the same recipe.
Same ingot, same mould, same level, DC, experience, gold and properties - the
properties come from the metal. Fifteen recipes with forty-eight variants
replace the seven hundred and five rows that spelling it out required.

The menu gains one screen between the recipe list and the detail, and only for
these recipes:

```
categories -> recipes -> products -> detail -> craft
                          ^ only when the recipe names a group
```

- `cnr_c_var` is the screen's condition: a recipe is selected, it names a
  group, and nothing has been picked from it yet.
- `cnr_a_pick` reads the list line as a variant when that is the screen it is
  on, as a recipe when browsing products, and as a category otherwise.
- `cnr_a_back` from that screen returns to the recipe list, not to the
  categories.
- The detail heading shows the product, so the crafter reads "Daga de acero"
  and not "Arma de acero".

**How the choice is validated.** `CnrCraft_ResolveProduct` joins `cnr_recipe`
to `cnr_variant` on `group_code` and filters by `recipe_id` and `variant_id`
together, so the question asked is "does this recipe offer this product" and
not "does this product exist". A variant id from another group resolves to
nothing, and `CnrCraft_Start` refuses the attempt **before any gold or material
is taken**. Nothing the client sends is ever used as a resref.

The product name is composed from the variant and the recipe's material:
"Daga" plus "Acero" reads as "Daga de acero", which is what the row it replaces
was called.


---

## 4c. Current tradeskill progression

Since 2026-09-23, all seven professions share a cumulative curve reaching
level 20 at **6500 XP**. `cnr_trade_init.nss` initializes the twenty
`CnrTradeXPLevel<n>` module locals used by XP persistence, profession-limit
checks, the tradeskill book and administrative level helpers, and
`cnr-editor/backend/app/tradeskills.py` holds the same thresholds for the
panel. The curve is the 2026-09-18 5000-XP curve with every threshold raised
by 30%, rounded half up; recipe XP and DC are unchanged.

**The level is derived, never trusted from storage.** `CnrSkill_GetLevel`
applies the curve to the cached experience, and `CnrSkill_Load` caches the
same derived level, so a curve change takes effect at the next bench. The
stored `cnr_tradeskill.skill_level` is not rewritten on load; the next
experience gain writes the right value, and the owner corrects rows by hand
until then. The profession-limit query still reads that column. Until 2026-09-24 the
stored column was cached as is, which left characters at a mastered level 20
that the new curve put at 17 and that, being mastered, could never earn the
experience that would have corrected it.

| Level | Cumulative XP | Level | Cumulative XP |
|--:|--:|--:|--:|
| 1 | 0 | 11 | 1495 |
| 2 | 33 | 12 | 1820 |
| 3 | 65 | 13 | 2178 |
| 4 | 130 | 14 | 2568 |
| 5 | 228 | 15 | 3114 |
| 6 | 358 | 16 | 3705 |
| 7 | 520 | 17 | 4342 |
| 8 | 715 | 18 | 5018 |
| 9 | 943 | 19 | 5720 |
| 10 | 1203 | 20 | 6500 |

### Experience by level band (since 2026-09-24)

A crafter is in a **band** by profession level, and a recipe or arcane property
of a tier below that band pays less, through `CnrCraft_GetXPBand` and
`CnrCraft_GetXPPercent` in `cnr_i_craft.nss`:

| Band | Levels | Tier 1 | Tier 2 | Tier 3 | Tier 4 |
|--:|---|--:|--:|--:|--:|
| 1 | 1-6 | 100% | 100% | 100% | 100% |
| 2 | 7-11 | 50% | 100% | 100% | 100% |
| 3 | 12-16 | 25% | 25% | 100% | 100% |
| 4 | 17-20 | 0% | 0% | 25% | 100% |

A tier at or above the band always pays in full. The band limits are
`CNR_XP_BAND_2_LEVEL` (7), `_3_` (12) and `_4_` (17), mirrored by `TIER_BANDS`
in both catalogue generators. The percentage applies to `xp_award` (or the
arcane step's XP), truncated, before the failure share, so a failure pays 12%
of the reduced figure; the profession-limit check reads the reduced XP; the
arcane window shows the reduced figure. When a reduction applies, the line
after the roll names the recipe's tier, the crafter's level and the
percentage; it does not name the band, because the exceptions below hold some
professions in a band below their level.

**The two-trade limit reads the stored level.** `CnrSkill_CanSetXP` counts
trained professions from `cnr_tradeskill.skill_level`, which is not rewritten
when the curve changes. A row stored at level 2 with 25-32 XP, level 1 on the
current curve, still occupies a slot until its next experience gain or a manual
correction. Rows out of step with the curve can be listed read-only by
comparing `skill_xp` against the thresholds in the table above.

This replaced, on 2026-09-24, the level-distance fall-off (100/50/25/12% by
five-level gaps) and the level-17 top-tier rule of 2026-09-23, after players
kept levelling on old recipes. Tier-4 recipes still roll against a DC 3 lower
than their progression position (`TIER4_DC_RELIEF`), gold on the unrelieved
DC.

**Every tier opens inside its band.** A band whose tier had no recipe yet would
pay nothing in full: a smith at 11 with tier 3 opening at 12 needed about 42
attempts for that level instead of 9. The bands were placed where the crafting
catalogue's tiers already open (smithing 5/12/17, carpentry 6/12/17, alchemy
6/11/15, leatherworking and tailoring 5/9/14); `align_tier_starts` in
`build_catalogue.py` brings a late tier's first recipes down to its band.
Jewellery, which had no tier 4 and a tier 3 with every other trade's tier-4
numbers, is laid out again by `rebalance_jewellery` (see "Second gem" below).
The herb cauldron's eight reagents are all tier 1 and open at level 1
(`open_herb_reagents`, since 2026-09-24): the alchemy table mixes each of them
into potions from level 1 to 3, so a spread over 1..20 left most low-level
potions asking for a reagent the alchemist could not make.
Arcane was
realigned in `arcano.json`: each tier's properties are spread over their band in
their authored order (tier 1 levels 1-6, nine per level; tier 2 7-11; tier 3
12-16; tier 4 17-20), 96 of 105 changed level, DC and XP unchanged, and
`build_arcane.py` fails if a property falls outside its tier's band.

**Exceptions.**
- Leatherworking and tailoring are held at band 3 (`CNR_XP_TOP_TIER_EXEMPT_1`
  and `_2`) because their tier 4 is made from dragon hides the world barely
  provides: see F10 in `open-issues.md`.
- A profession whose catalogue stops below the band counts its own top tier
  as the current one (`CnrCraft_GetTopTier`). Since jewellery gained its tier 4
  on 2026-09-24 no profession is in that case; the rule stays so that one added
  without a tier 4 is not stranded.

### Expected attempts

Source-model estimates from zero to level 20, with prepared components
available and, at each level, the reachable recipe or arcane step with the best
expected XP per attempt:

| Profession | Attempts, help +2 | Attempts, help +3 | Always 5 levels behind, help +2 |
|---|--:|--:|--:|
| Smithing | 179 | 168 | 567 |
| Carpentry | 180 | 169 | 588 |
| Leatherworking | 170 | 161 | 277 |
| Alchemy | 171 | 161 | 494 |
| Jewellery | 172 | 162 | 551 |
| Tailoring | 170 | 161 | 277 |
| Arcane | 170 | 156 | 472 |

No level of any profession is without a recipe or property that pays in full.
The leatherworking and tailoring rows assume dragon hides are available, which
today they are not (F10); their "behind" column is low because they are held at
band 3.

These are attempts, not output units or measured player runs. Natural 1 fails,
natural 20 succeeds, and failed attempts pay truncated 12% XP. The final help
contribution is the capped ability part plus the capped Artesania part
(section 5). Materials, tools, travel, node availability and preparing one's
own inputs add separate costs. The two non-Alchemy-profession limit and the
Alchemy exemption are unchanged.

For each XP state x, let A be the effective success XP, F = floor(0.12*A), p
the actual success probability and T remaining expected attempts. With
T(x >= 6500) = 0, solve downward: T(x) = 1 + p*T(x+A) + (1-p)*T(x+F) when
F > 0, or T(x) = 1/p + T(x+A) when F = 0. The model records the numbers; host
behavior still needs the runtime acceptance listed in the September changelog.
The change introduces no character-data migration.

---

## 5. The craft roll

```nwscript
int nRoll  = d20();
int nTotal = nRoll + CnrCraft_GetRollBonus(oPC, nProfession);
int bOk    = (nRoll == 20) || (nRoll != 1 && nTotal >= nDC);
```

`CnrCraft_GetRollBonus` calculates:

- `craft_bonus = min(2, base Artesania ranks / 8)`, using ranks only and no
  item bonuses;
- `best_modifier` = the better of the two profession abilities' modifiers,
  each computed from the **base** score, `floor((GetAbilityScore(oPC, n, TRUE)
  - 10) / 2)`, so items, spells and potions do not count;
- `ability_bonus = clamp(best_modifier / 2, 0, 2)`;
- `help_bonus = ability_bonus + craft_bonus`, always 0..4;
- final roll bonus = profession level + `help_bonus`.

Without a profession, or when the profession row cannot be read, the help is
`craft_bonus` alone. The constants are `CNR_CRAFT_RANKS_PER_BONUS` (8) and
`CNR_HELP_PART_CAP` (2).

| Best base modifier | Ability part | | Base Artesania ranks | Artesania part |
|--:|--:|---|--:|--:|
| +1 or less | 0 | | 0-7 | 0 |
| +2, +3 | 1 | | 8-15 | 1 |
| +4 or more | 2 | | 16 or more | 2 |

The help is deliberately small and flat (decided 2026-09-23). The previous
formula, `floor((floor((mod1 + mod2) / 2) + ranks / 5) / 2)`, could go negative
with low abilities, averaged a mismatched pairing down, and read ability
modifiers with item and spell bonuses, so a buffed character could exceed +4.
Taking the better ability stops punishing a character who fits half the
pairing; the two caps keep a maxed and buffed character at +4.

| Profession | Abilities |
|------------|-----------|
| Herrería | Strength, Constitution |
| Carpintería | Dexterity, Strength |
| Peletería | Dexterity, Constitution |
| Alquimia | Wisdom, Intelligence |
| Joyería | Charisma, Wisdom |
| Arcano | Intelligence, Wisdom |
| Sastrería | Dexterity, Charisma |

The message shows the roll broken into its parts - `d20 + level (oficio) +
help (ayuda)` - because a single total hides whether the help bonus
contributed anything: it is zero until one ability reaches 14 base or
Artesania reaches 8 base ranks.

**The skill read is `SKILL_CRAFT_TRAP`, and that is deliberate.** This module
reassigned the stock craft skill rows in `haks-2da/skills.2da`: row 22, whose
constant is `SKILL_CRAFT_TRAP`, is Artesania, while rows 25 and 26 - Craft
Armor and Craft Weapon in a stock installation - are Nadar and Saltar. Reading
`SKILL_CRAFT_WEAPON` here measures the crafter's jumping, which is what the
code did until 2026-09-20 and why ranks of Artesania added nothing to any
trade. Any future edit to this function checks `skills.2da` before trusting a
`SKILL_*` name.

Failure pays `CNR_XP_FAILURE_PERCENT` (12%) of the recipe's XP, truncated by
the integer division: a recipe worth 21 pays 2, not 3. Success pays it
in full and creates the item after the station animation finishes. Both read
the XP after the band reduction of section 4c.

**Experience stops at level 20.** `PersistDetermineTradeskillLevel` counts down
from 20, so past its threshold experience only accumulated and the level never
moved. `CnrSkill_IsMaxLevel` gates the award and the player is told the
profession is mastered instead of being promised experience that does nothing.

**Gold is not charged** (since 2026-09-24). An attempt costs its materials
only. `cnr_recipe.gold_value` stays in the catalogue, still DC x 12, as the gold
the recycler returns for a piece that gives back no material; the station menu
no longer shows it.

Tunable constants live at the top of `cnr_i_craft.nss`; nothing is copied into
recipes.

### Profession limit

A profession occupies a character slot only at level 2 or above. A character
may have at most two such non-Alchemy professions; any number may remain at
level 1. Alchemy is excluded from both the count and the block.

`CnrSkill_CanSetXP` enforces the rule in the write-through persistence API, so
legacy XP paths cannot bypass it. The generic crafting engine also performs the
same check before a roll, animation, tool breakage, or material consumption if
a successful attempt could raise a third profession to level 2. Existing
characters already at level 2 in a profession may continue progressing it.
Lowering one trained profession to level 1 frees its slot.

**A third profession is closed, not merely capped** (2026-09-23). With two
trained non-Alchemy professions, `CnrSkill_IsProfessionClosed` refuses any
attempt at a bench of a third one, and `cnr_i_apply.nss` refuses an arcane
application, before anything is charged. Before this, the XP gate only stopped
the step to level 2, so a character with two trained professions could keep
making level-1 pieces of every other one. The check reads the session cache;
the database-backed `CnrSkill_CanSetXP` still guards the level itself.

The character editor applies the same validation when an administrator saves
tradeskill XP.

### Arcano is for spellcasters

Since 2026-09-23 `CnrSkill_CanSetXP` refuses any increase of Arcano experience
to a character without `CNR_ARCANE_CASTER_LEVELS` (3) levels in one of:

| Class | `classes.2da` row | Highest spell level at class level 16 / 20 |
|---|--:|---|
| Bard | 1 | 5 / 6 |
| Cleric | 2 | 8 / 9 |
| Druid | 3 | 8 / 9 |
| Sorcerer | 9 | 8 / 9 |
| Wizard | 10 | 8 / 9 |
| Warlock (Brujo) | 57 | no spell table; included by name |
| Favored soul (Alma predilecta) | 59 | 8 / 9, sorcerer table |
| Artificer (Artifice) | 64 | 5 / 6 |

The rule is "a class that reaches sixth-level spells by class level 16 or 20",
plus the warlock. Every other class with a spell table stops at fourth level:
the four paladins, ranger, assassin, blackguard and Soldado de la Luz.
Prestige classes have no spell table of their own and require a base caster
to enter. Spell levels were read from `haks-2da/cls_spgn_*.2da` and, for the
tables the hak does not override (bard, cleric, sorcerer, wizard, ranger),
from the installed game with `nwn_resman_cat` on 2026-09-23.

The arcane table refuses a non-caster outright in `cnr_i_apply.nss`, before
anything is spent. The XP check sits in the one function every XP write passes,
so the test lever, a DM tool and the legacy level conversion obey it too.
Keeping or lowering the figure is allowed, and a character who already had
Arcano above level 1 keeps it but gains no more. The character editor does not
know a character's classes and does not apply this rule.

---

### A station is shared, and that is safe

Components are counted and consumed from the **placeable's** inventory, not the
crafter's: `CnrCraft_CountInStation` and `CnrCraft_ConsumeFromStation`. Several
players may therefore load and use the same bench, and anything left in one
stays there for whoever comes next.

There is no window between checking and consuming. `CnrCraft_HasMaterials` runs
at `cnr_i_craft.nss:1054` and the components are destroyed at `:1235`, both
inside one `CnrCraft_Attempt` call, and NWScript runs an event to completion
before any other script starts. Nobody can empty the bench between the check
that passed and the consumption that follows, so a recipe can never complete on
materials that are no longer there.

The same reasoning covers the animation. `oCnrCraftingPC` is written on the
station at `:1244` and read by the animation script that `ExecuteScript` calls
six lines later, still inside that one run. Everything the delayed
`CnrCraft_Finish` needs is passed to it **by value** rather than re-read from a
local afterwards, which is why a second crafter starting during the delay
changes nothing about the first one's result. Every other piece of state -
station, skill, category, page, chosen recipe, listed rows, roll parts - lives
on the player.

## 6. Creating the item

**The piece is built away from every inventory and handed over when it is
finished.** `CreateItemOnObject` straight onto the crafter makes the client
print `Objeto adquirido:` with the blueprint's own name, before `SetName` has
run — a copper scale mail announced itself as *Atuendo de Maestro Carpintero*,
the blueprint it reuses.

It is not built inside the station either, and that distinction is the whole
point. `CreateItemOnObject` **merges with a matching stack already in the
target and returns the merged pile**, which would then be renamed, enchanted,
copied to the crafter whole and destroyed: a station holding five ingots would
hand over six and keep none. The same trap is documented for the blueprint
probe further down, and it is the one that ate cut gems in August.

A location holds no stacks, so nothing can merge with it:

```nwscript
object oItem = CreateObject(OBJECT_TYPE_ITEM, sResRef, GetLocation(oStation));
if (nQty > 1)
{
    SetItemStackSize(oItem, nQty);
}

// … named, tagged, flagged, stamped, enchanted here …

object oFinished = CopyItem(oItem, oPC, TRUE);
DestroyObject(oItem);
```

The copy carries name, tag, flags, properties and local variables, so what the
crafter is told they acquired is what they made, and the destroyed original
never belonged to an inventory. Fixed 2026-08-20.

Every recipe carries a blueprint `base_resref`. Alchemy uses `sPocionBase` as
that resref and applies `sCustomTag` through `output_tag` after creation. Then
the engine sets the name and runs one `cnr_apply_prop` call per property row.

Properties are applied **one helper call per row** after collecting the SQL
rows: the NWNX_SQL result set cannot be held open while the engine builds item
properties.

**On-hit save DCs are a fixed table, and not every number is in it** —
2026-08-20. `IP_CONST_ONHIT_SAVEDC_*` is **seven constants and no more**: 14,
16, 18, 20, 22, 24 and 26, indices 0 to 6. The installed `nwscript.nss` declares
them at lines 4825-4831 and declares nothing above 26; the same table is in
[`material-properties-reference.md`](material-properties-reference.md). There is
no odd DC and no DC above 26, so the generator cannot produce either, and
anything authored that names one has to be rounded deliberately with the choice
recorded here.

`CARP_SAVEDC` in `build_catalogue.py` maps 28 to 34 as well, indices 7 to 10,
which no constant backs. Nothing reaches them today - the highest DC any design
CSV asks for is 16 - but a clause naming DC 28 would emit an index the engine
has no name for.

Platinum ammunition used to be the one clause asking for an odd DC,
`Silencio CD15`, in both design sources. It was stale in both: the live design
sheet says **DC 14**, which is what the catalogue has always shipped. A tester
reported the difference against the written design, not against the game.
`herreria.json` and the smithing CSV now say CD 14 as well, so nothing in the
repository asks for a DC the engine cannot produce.

Those two files are cross-checked against each other by `build_catalogue.py`,
including the ammunition column. Editing one and not the other fails generation
with `Smithing CSV/JSON mismatch`, which is how the half-edit was caught.

**Three carpentry blueprints were named after a wood nobody else uses.** A
recipe called `Tablones de Cedro` produced an item called *Tablones de ciprés*,
and `Tablones de Leñocaso` produced *Tablones del crepúsculo* out of a *Leño del
crepúsculo*. Neither ciprés nor crepúsculo is one of the eight woods the design
names. The chain always worked, because it is joined by tags, but the menu asked
for one thing and handed over another; a tester read it as the cedar recipes
consuming cypress planks. All eight woods were compared against the design: the
other five agreed, and these three now do. Fixed 2026-08-23.

**A recipe's name is the name of what it makes.** The forge listed
`Lingote derretido`, an item that does not exist: the blueprint behind that
recipe is named *Lingote de hierro enardecido*, which is what the chest holds
and what the anvil asks for. Nothing was broken - it was always the same item -
but the menu described a trade between two things that were one. All fifteen
forge recipes were checked against the blueprint they create; that was the only
one that disagreed, and it was renamed to match. Fixed 2026-08-20.

The result is always identified and flagged stolen. Nothing did that before, so
an item arrived identified only if its blueprint happened to be, which is why
potions and several weapons came out unknown.

A recipe may deliver a **second product** through `extra_resref` / `extra_qty`,
created on success only and never instead of the main one - a jeweller cutting
a stone keeps the gem and also gets its dust. `extra_name` is what the recipe
list shows, because a resref is not something a player should read. A bad extra
resref is logged and reported but never turns the craft into a failure: the
main product is already in the player's hands by then.

Recipes with `marks_socketed` set `CNR_ENGARZADO` on what they create, and both
`CnrCraft_CountInStation` and `CnrCraft_ConsumeFromStation` skip any item
carrying it. The gate is general rather than a list, so a finished piece is
invisible to every recipe, whatever gets authored later.

### What a crafted piece carries, for the enchanting table

Every result of a trade recipe is stamped with `CNR_OFICIO`, a local int
holding the `profession_id` that made it. It is written from
`cnr_recipe.crafted_by`, which the generator resolves once the whole catalogue
is known.

**This is the contract the arcane table will read.** A piece is enchantable if
and only if `GetLocalInt(oItem, "CNR_OFICIO") > 0`, and the value says which
trade, so the table can narrow further - arcane armour from leatherworking
only, say - without a second list to maintain.

A recipe is stamped when all three hold:

1. its station `produces = 'product'`;
2. its profession is not Alchemy - a potion is not a piece of equipment;
3. **nothing else in the catalogue consumes what it makes.**

The third rule is what makes the other two enough. A band and a cut gem are
half-finished: the setting recipes eat them, so they stay unmarked, and only
the ring or necklace that comes out of setting is enchantable. That is the
intended design, and it is derived rather than listed - if a recipe is ever
written that consumes finished rings, they stop being marked on their own.

Current split, from the applied catalogue:

| Stamped | Recipes | | Unstamped | Recipes |
|---|---:|---|---|---:|
| Smithing | 120 | | Potions | 65 |
| Carpentry | 78 | | Material benches | 41 |
| Leatherworking | 70 | | Bands, chains, cut gems | 34 |
| Jewellery | 56 | | | |
| Tailoring | 30 | | | |
| **Total** | **354** | | **Total** | **140** |

The mark is invisible to the player and has no effect today. It exists so the
arcane work does not have to reopen every recipe to decide what it may touch.

`CNR_ENGARZADO`, above, is a separate mark with a separate job: it stops a
finished piece being counted as material. An item can carry both.

### Second gem (jewellery tier 4, since 2026-09-24)

`CNR_ENGARZADO` is a count: 1 once a gem is set, 2 after a second one, never
more. `cnr_recipe.marks_socketed` is the same count, so the 56 setting recipes
carry 1 and the 28 second-gem recipes, one per gem in the "Segundo engarce"
category of the jeweller's bench, carry 2. Nothing else marks a second-gem
recipe: no schema change, and the control panel, which validates
`output_kind`, is untouched.

**Catalogue.** `build_catalogue.py` appends the 28 recipes after every station's
own, so no existing recipe id moves: ids are stamped on crafted items and read
back by the recycler. Each consumes one cut gem, carries the properties of that
gem's ring recipe, and names the gem in `extra_name` as it reads inside a
jewel's name. `base_resref` is the cut gem only because the column cannot be
empty; nothing is created, the blueprint probe is skipped and the shared-base
rule does not count it. `rebalance_jewellery` then places all 118 jewellery
recipes like any other trade: ordered by tier and current level, each tier is
spread over its band, and DC, gold and XP follow the position through
`progression_value`, tier 4 keeping the DC relief.

| Tier | Recipes | Levels | DC | XP |
|--:|--:|---|---|---|
| 1 | 36 | 1-6 | 10-17 | 21-39 |
| 2 | 27 | 7-11 | 18-23 | 39-53 |
| 3 | 27 | 12-16 | 23-29 | 53-67 |
| 4 | 28 | 17-20 | 26-32 | 67-81 |

**Engine** (`CnrCraft_Attempt`, `CnrCraft_Finish`):

1. Before any material, tool or roll, `CnrCraft_FindSocketJewel` needs exactly
   one jewel on the bench: a ring or necklace with `CNR_OFICIO` = jewellery and
   one gem, identified, without `CNR_ENCANTADO` and not already targeted.
   Otherwise the attempt is refused with the reason.
2. `CnrCraft_SocketConflict` compares the recipe's properties with the jewel's
   own item properties, not with a list: armour class, spell resistance and
   regeneration at most once; a saving throw or an elemental damage immunity
   once per subtype; the three physical immunities once in all, because their
   cap is far below the elemental one; spell slots always, the same gem
   included. A property type it does not know is refused and logged, so a
   catalogue edit cannot open a stacking hole.
3. Once the roll is committed the jewel carries `CNR_SOCKET_PENDING`, which
   keeps any other attempt at the shared bench from targeting it. The cut gem is
   consumed as a normal component; the jewel, being marked, never is.
4. `CnrCraft_Finish` releases the jewel first, even if the crafter logged out,
   and checks it is still on the bench with one gem. If it is not, nothing is
   set, no experience is paid and the gem is lost. On failure the jewel is
   destroyed by `CnrCraft_Attempt` together with the components, at roll time,
   not after the animation: the player has already seen the roll, and
   neither logging out nor taking the jewel off the bench may save it. On
   success the gem's properties are applied, the
   count becomes 2, the name gains " y <gema>" inside its colour, and the jewel
   is copied to the crafter and the bench copy destroyed.

The recipe stamp is left as the first setting's, so the recycler returns that
gem's materials only; a jewel with two gems can still be enchanted. The bench is
shared, as every station is: a jewel left on it can be targeted by another
player's attempt.

### More than three properties: level 17 and above (since 2026-09-24)

`wrap_on_equip_it` unequips an item carrying `masNivel15` from a character of
level 16 or lower: such a character may wear three properties at most. The
loot generators `pb_tesoro_sorteo` and `pb_tesoros_inc` set it on loot
generated with more than three (`pb_tesoros_inc` asked for more than four,
`iCalidad > 4`, until 2026-09-24). `iCalidad` counts attempted additions, and
`IPSafeAddItemProperty` replaces a property of the same type and subtype, so
`FinalizarObjetoCreado` also calls `CnrProp_UpdateHighLevel` half a second
later, once the additions queued at 0.2 seconds have landed, and the item's
own count sets or clears the mark. Sr. Ponpaipa's antimagic machine (`use_antimagia`) clears it when a removal brings the item back to
three. No recipe carries more than three property rows (22 bows,
crossbows and ammunition carry three), but an arcane enchantment adds one, so a
three-property piece became a four-property piece anyone could wear.

`CnrProp_MarkHighLevel` (`cnr_i_prop.nss`) now sets the mark after every
crafted product, every second gem and every arcane enchantment when
`CnrProp_CountLimitedProperties` exceeds three. It counts permanent properties
except the use limitations (alignment group, class, racial type, specific
alignment, gender - row 150 of `itempropdef.2da`), light and quality, the
same exclusions `use_antimagia` intended. It never clears the mark. Pieces
enchanted before this change are not marked retroactively.

`CnrProp_ClearHighLevel` clears it by the same count, and `use_antimagia`
calls it half a second after removing a property. Until 2026-09-24 the machine
counted inline: its exclusions were written `iTotLimit+1;`, which discards the
sum, so use limitations, light and quality were counted after all; and it
counted in the same script that called `RemoveItemProperty`. Whether a
removal is visible to the same script is not stated by `nwscript.nss`; running
the count after the script makes the answer irrelevant.

### Crafted potion activation

**One potion per craft — 2026-08-23.** `CnrCraft_Finish` now calls
`SetItemStackSize(oItem, nQty)` unconditionally. It used to do it only above
one, which was harmless while the result came from `CreateItemOnObject`, whose
count overrides the blueprint. `CreateObject`, which replaced it on 2026-08-20
so the piece is built outside every inventory, **inherits the blueprint's own
`StackSize`** instead. Potion blueprints stack to ten, so one potion's materials
produced ten potions; Pure Water was the only one that behaved, because its
blueprint stacks to one. Reported from the test server.

**The potion no longer has potentiated or extended variants.** `pb_potion_inc`
read a suffix off the tag - `d` doubled the duration, `p` selected a stronger
branch - and eleven cases carried an `if (iPotenciada==0) … else …` pair. All of
it is gone: a potion does what its own case does. The two duration classes, four
and eight turns, are the effect's own and stay.

**The character-level gate is gone.** A character below level 5 could not use
any potion with an id above 70, forty of the ninety-four, whoever made it. It
judged the drinker, not the craft.

**The cooldown is a timelock.** It was `SetLocalInt(oPC, "128", …)`, sixty bare
numeric locals on the character. It is now `SetTimelock` with the potion's own
name, which is what the player reads when it becomes available again. Drinking
early still costs the potion and still hurts: the lock announces, it does not
refuse.

Crafting owns item creation, not OnActivate effects. The module activation path
remains `pb_mod_activate.nss` -> `pb_potion_inc.nss`. The include contains the
36 numeric `sute_her*` effect cases preserved from the former profession
library. Two additional active catalogue outputs deliberately return without a
potion effect: `sute_her_DM1` (Pure Water) and
`sute_her_128_075_n_FoodRICH` (Magic Cookie). Poison outputs retain their
palette resrefs and `Saquitodeveneno*` tags and are not selected by the
`sute_her` branch.

### Alchemy output activation

Crafting and item activation are separate runtime paths. The catalogue creates
the authored blueprint and preserves its `sute_her*` output tag. Later, the
module `OnActivateItem` event reaches `pb_mod_activate.nss`; that dispatcher
routes the `sute_her` namespace to `pb_potion_inc.nss` and calls
`usarPocionHerboristeria()` with the final tag.

`pb_potion_inc` is the self-contained activation boundary retained from the
former herbalism runtime. Its resref is 13 characters and therefore respects
NWN's 16-character resource-name limit. The 36 active numeric potion/poison
tags keep their existing switch effects. Four catalogue outputs intentionally
have no potion effect: `sute_her_DM1` is Pure Water, `sute_her_128_075_n_FoodRICH`
is the food-tagged Magic Cookie, and the two recovered on 2026-08-26 —
`sute_her_002_005_n_FoodNORM`, the Edible Roots, and `sute_her_127_075_n_DrinkHIGH`,
the Magic Juice. The activation include returns before parsing an effect ID for
any of the four. The last two were added to that guard when their recipes were
written: the switch has no `default`, so they already did nothing, but the roots
parse to id 002 and would fire the day someone writes a `case 2`.

The post-cleanup static audit found no change in the retained effect table and
no `.nss` basename longer than 16 characters. A clean compilation and the
activation smoke test remain required before production promotion.

#### Forty-five authored potions were never craftable — 2026-08-26

`documentation/oficios/alquimia.json` authors 110 results. The legacy
`cnrAlchemyTable.nss` wrote 65 of them, and the frozen station JSON inherited
exactly that, so forty-five potions were designed, given a `sPocionBase`
blueprint that exists in `src/cnr/uti/`, given an effect in `pb_potion_inc.nss`,
and had no recipe. Players reported the gap; the 27 poisons of
`Oficios Basicos - Etapa 2 - 2025 - Venenos.csv` and the cauldron's 8 materials
were complete all along.

Three of the missing ones read as duplicates of recipes that do exist and are
not: **Poción Blanca** (`sute_her_092_075_n`, `abj_a`) is not Poción Blanquecina
(`sute_her_021_030_n`, `tra_b`), **Poción Furiosa** (`sute_her_023_035_n`,
`tra_b`) is not Poción de Furia (`sute_her_104_095_n`, `tra_a`), and **Poción de
Agua** (`sute_her_108_100_n`, `enc_a`) is not Agua Pura (`sute_her_DM1`).
Different effect ids, different schools, different tiers.

Components come straight from the design's three `componente` columns, mapped to
the cauldron's own output tags and summed when a column repeats. A drinkable
result also consumes `cnr_p_botella`, retained on failure, the way every
authored potion and Pure Water already did; food does not, the way the Magic
Cookie already did not.

**The design's tag for Poción Opaca was a copy of Poción Oscura's.** Both read
`sute_her_094_080_n`, and since `usarPocionHerboristeria()` dispatches on
characters 9-11 of the tag, the two would have fired effect 094 from one bottle
each. The generator refuses duplicate alchemy output tags, which is how it
surfaced. The corrected id is not invented: `pb_potion_inc.nss` already
implements `case 22` and the case is commented `//Opaca`. The difficulty block
follows it — 021 is 030 and 023 is 035, and every other `enc_b` potion sits
between 010 and 035, while 080 belongs to the `nig_a` potion the tag was copied
from. Poción Opaca is `sute_her_022_030_n`; Poción Oscura keeps
`sute_her_094_080_n`.

Spreading 110 recipes over profession levels 1-20 instead of 65 moves every
existing alchemy recipe one to three levels down. Nothing else in the catalogue
changed level, DC or XP.

### Station animation and sound

The attempt reads `cnr_station.anim_script`, exposes the legacy animation
contract (`oCnrCraftingPC`, `bCnrCraftingResult`, and `fCnrAnimationDelay`), and
executes the script on the station. Components are reserved immediately; XP,
item creation, properties and the result message are delayed until the script's
declared duration ends. Each existing station script owns its animation and
sound, so a new station can select a different presentation through data.

**No animation may go through the player's action queue.** The seven scripts in
use called `ActionPlayAnimation`, which is what the original CNR did: seven
seconds of queued actions on the jeweller's bench, dropped on a player who is
standing in an open conversation. That leaves the menu half drawn — the client
keeps showing the last node it received and the clicks stop arriving, which is
what "after crafting, Atras hangs and the menu does not change" turned out to
be. `PlayAnimation` plays the same animation immediately, without touching the
queue, and `DelayCommand` chains the steps the queue used to chain. Same
timings, same sounds, same declared duration.

The rule holds for anything the crafting path executes: the menu is a
conversation and a conversation does not survive being queued around.
`ClearAllActions` is not the answer either, since it aborts conversations
outright.

Eight legacy animation scripts still hold the old pattern — `cnr_brewkeg_anim`,
`cnr_caldron_anim`, `cnr_enchant_anim`, `cnr_gemcut_anim`, `cnr_gempol_anim`,
`cnr_hide_anim`, `cnr_tinker_anim` and the emptied `cnr_recycle_anim`. No
station in `cnr_station.anim_script` names any of them, so none of them runs;
if one is ever wired up, it has to be converted first.

### Station tools

`CnrCraft_CheckStationTools` runs when the player presses **Fabricar**, after
the recipe and materials have been validated but before the craft roll or any
component consumption. Browsing a station therefore does not require its tools,
and an unusable recipe cannot break one.

Every `cnr_station_tool` row is a requirement (**AND semantics**). An
`inventory` tool may be inside a nested container or equipped; an `equipped`
tool must occupy an equipment slot. This deliberately resolves tailoring as
requiring both `cnr_t_aguja` and `cnr_t_kit_cuero`; the legacy module-local API
could store only one inventory tool and silently overwrote the first call.

A tool with `category_id` set is required only by the recipes in that
category; `NULL` still means the whole station. The jeweller's `cnr_t_kit_orfeb`
uses it: cutting a stone needs the kit, setting one does not. The scoped rows
are written by `03_catalogue.sql` rather than `02_seed.sql`, because the
categories they point at do not exist until the catalogue builds them.

All requirements are checked before any breakage roll. Each present tool then
rolls its own `breakage_chance`; a broken tool aborts the attempt without
rolling the recipe or consuming components. A database error fails closed and
asks the player to contact a DM, so a failed lookup cannot bypass a tool.

`breakage_chance` is a percentage and the engine evaluates
`Random(10000) < chance * 100`. Needles use **3.0** in Leatherworking and
Tailoring since 2026-09-18, averaging 33.3 attempts including the breaking roll.
Other tools retain **4.0**, averaging 25 attempts. All needle base-item variants
share the same tag and therefore the same station percentage.

A read-only query of local MySQL `nwnee_baldur_mysql` on 2026-09-18 confirmed
both needle and kit rows at 4.00 before this source adjustment. No deployed
server bytecode was checked. The severe reported three-attempt failure rate is
not explained by that configured percentage alone. Needle survival after three
rolls increases from 88.4736% to 91.2673%; this is a random-life adjustment,
not a minimum guaranteed lifetime. Kits retain their independent roll.

The generator and fresh seed contain 3.0. Existing catalogues can apply
`migration/06_needle_breakage.sql` without rebuilding recipe tables or touching
character progress. That SQL has been prepared, not applied to live MySQL.

The number has moved twice. The legacy values were 0.3 and 0.1, written as if
they were percentages but read by the old engine as a third of one percent and
a tenth, so tools effectively never broke. On 2026-08-14 they were read as
intended and set to 10.0, which is one tool every ten crafts; testers reported
jeweller kits breaking twice in a row, which at 10% is a one percent event and
happens. 4.0 sits between the two.

**The roll has no memory.** A tool does not wear down: each attempt either
survives its roll or the tool is gone, whatever its history. Harvesting tools
work the other way, on a use counter (`CNR_USOS` in `cnr_i_node.nss`), and
moving station tools onto the same footing would remove the streaks entirely.
Not done: it would need the count stamped on every existing tool in the wild.

---

## 7. Create by ID

With a station open, a bare number in chat is captured as the recipe id and the
message is suppressed. Anything that is not a pure number (1-7 digits) passes
through untouched, so normal chat is unaffected.

The hook sits at the top of `pb_chat.nss` and returns immediately, before the
existing tell and DM-shout logic.

**A typed id reaches the product chooser too — 2026-08-20.** `cnr_a_byid` used
to call `CnrCraft_SelectRecipe` and go straight to the detail. Typing the id of
a recipe that offers several products therefore landed on a detail screen with
no product chosen, where `Fabricar` could only answer that one had to be chosen
and the screen offered no way to choose it. It now runs the same two steps the
list route runs: page zero, `CnrCraft_ListVariants`, and the detail only when
there is nothing to choose. The `Crear por ID` reply gained the matching link to
the variant screen through `cnr_c_var`. A rejected id clears any recipe,
variant and group left behind.

**Minimum level is enforced at selection and attempt - 2026-09-18.**
Previously, the recipe list filtered by `min_level`, but selecting a public ID
and executing a cached recipe did not enforce it. `CnrCraft_SelectRecipe` now
loads the recipe requirement and its owning profession's skill index before
caching a selection. Both typed-ID and list actions stop on refusal. The
attempt reads the current `min_level` again and refuses before checking
components, rolling or spending materials, gold or tool wear. A recipe selected
before a requirement change is therefore checked against the current catalogue.

Showing recipes above one's level is a browsing preference, not permission to
craft them. Exact minimum level is accepted. Disabled and foreign-station
recipes remain refused. Refusals report the required level once and do not
change conversation links or button tokens. Runtime acceptance remains owed.

---

## 8. Porting to production

Do not port a manually counted subset of files. Promote the reviewed source
commit, apply PWDB/player-state/catalogue migrations in order, inventory every
production station, and perform a clean package so removed legacy resources
cannot survive from an older cache. The canonical ordered procedure, validation
gates, and rollback steps are in
[`legacy-removal-and-production-promotion.md`](legacy-removal-and-production-promotion.md).

### Sastrería Toolset placeable

Create an inventory-bearing placeable with these exact values:

| Field | Value |
|-------|-------|
| Name | `Mesa de Sastrería` |
| Tag | `cnrSewingTable` |
| ResRef | Any unique valid resref, recommended `cnr_sewing_tbl` |
| Has Inventory | enabled |
| Usable | enabled |
| Static | disabled |
| OnUsed | `cnr_device_ou` |
| OnInventoryDisturbed | empty |
| Conversation | `cnr_c_station` |
| OnOpen / OnClosed | empty |

This mirrors the existing Peletería inventory flow. The station is registered,
uses `cnr_tailor_anim`, and requires both `cnr_t_aguja` and `cnr_t_kit_cuero` in
the player's inventory. It opens successfully but shows no categories until
Sastrería recipes are authored in `migration/catalogue/cnrsewingtable.json`.

---

## 9. Migration results

`python3 migration/build_catalogue.py` validates the design files and
regenerates `02_seed.sql` and `03_catalogue.sql` from the profession JSON,
authored catalogue JSON, blueprints and audited property rows. Generated
snapshot checked 2026-08-11. DEV application is recorded separately; the
current snapshot has not been compiled or tested in game by this review:

| | Rows |
|---|---|
| Categories | 36 |
| Recipes | 487 |
| Components | 993 |
| Properties | 417 |
| Materials | 77 |

Per station:

| Station | Categories | Recipes |
|---------|-----------|---------|
| Yunque de herrero | 8 | 120 |
| Mesa de peletero | 9 | 97 (7 disabled) |
| Mesa de joyero | 2 | 86 |
| Mesa de alquimia | 1 | 110 |
| Forja | 1 | 15 |
| Tina de curtido | 3 | 10 |
| Caldero de hierbas | 1 | 8 |
| Mesa de sastrería | 0 | 0 |
| Tabla de serrería | 1 | 8 |
| Banco de carpintero | 10 | 78 |

DC, XP and gold are derived from the recipe's authored progression position,
not copied. The four tiers only control visibility across profession levels
1-5, 6-10, 11-15 and 16-20:

```
DC        = position spread over 10..35, minus 3 in tier 4
XP        = position spread over 21..81, times 0.30 for material outputs
gold      = unrelieved DC * 12
public_id = station block + sequence (anvil 1001.., forge 1501..)
```

The number the player types is allocated from **the station's own base**, listed
as `PUBLIC_ID_BASES` in `migration/build_catalogue.py`, not from a counter the
whole profession shares. Four professions run two stations each, and while a
profession shared one counter, adding a recipe to the first station renumbered
every recipe of the second: the eighteen light tier-4 pieces of 2026-08-23 moved
the forge's fifteen ingots from 1121-1135 to 1139-1153. The forge was given its
own base in the same change, once, and the other three second stations kept the
numbers they already had — 2008, 3010, 4065 — each of them sitting immediately
behind the station in front of it.

**A profession's thousand is now split in half: X000 for the first station,
X500 for the second — 2026-08-26.** Those tight bases meant every second station
was one recipe away from a build error, and the forty-five alchemy recipes
recovered on 2026-08-26 would have run the mesa from 4001 straight through the
cauldron's base at 4065. Raising a base one crisis at a time renumbers a station
each time; five hundred numbers per station is more than any of them will ever
need, so the bases stop moving. The forge went 1200 to 1500, the carpenter's
bench 2008 to 2500, the tailor's table 3010 to 3500 and the cauldron 4065 to
4500. Those four stations renumbered once, on that change; a player who wrote
down a forge id before it will get "esa receta ya no esta disponible" and has to
pick again from the menu.

A base is never handed out: the first recipe of a station is `base + 1`. The
generator refuses to build when a station would reach the next base in its
profession, so an overflow is a build error to be resolved by raising that base
deliberately, rather than a silent renumbering discovered by a tester typing an
id that now belongs to something else.

### The build proves no recipe was lost — 2026-08-26

Renumbering is safe and it does not feel safe, which is the same problem as it
not being safe. Adding the forty-five alchemy recipes moved 448 `recipe_id`s and
172 `public_id`s in one run, and nothing in the build could answer "did anything
disappear" — it had to be proven afterwards, by hand, the way it had been proven
by hand every previous time.

`verify_no_recipe_regression()` answers it during the build. The last **committed**
`03_catalogue.sql` is the accepted state; the generated one is compared against
it recipe by recipe, keyed by displayed name plus the blueprint it creates, which
is what a player recognises and what survives any renumbering.

| Free to move | Build error |
|---|---|
| `recipe_id`, `public_id` | a recipe that no longer exists |
| `tier`, `min_level`, `dc` | a changed `base_resref` or `output_tag` |
| `xp_award`, `gold_value` | a changed `output_qty` or menu category |
| new recipes | a changed component or property list |

It prints one line on success — `regression guard : 513 recipes intact, 45 added`
— and refuses with the specific recipes and the specific fields otherwise. When
altering existing recipes *is* the work, `--accept-recipe-changes` allows it and
prints everything it is accepting, so the change is stated rather than
discovered.

Two things to know about it. The baseline is `HEAD`, so a catalogue change that
has not been committed yet is compared against the last one that was; that is
the intended reading of "accepted", but it means the guard is quiet about a
regression you introduced and committed in the same breath. And the key needs
name and blueprint to be unique together across the catalogue — they are, for
all 558 — so the guard raises rather than guesses if a future recipe collides.

Its own refusals were verified by feeding it three doctored catalogues: a
deleted recipe, a swapped blueprint and a dropped component. It caught all
three and stayed silent on the real one.

Smithing follows the 15-metal design order. Copper is the first step: the forge
creates its ingot and every smithing family creates a property-free copper item
for practice or later socketing. Jewelry likewise includes property-free copper
ring and necklace bases. Gem and metal jewelry use separate progressions;
leather follows its ten materials.

Alchemy uses an explicit mixed progression. Potion and food tags of the form
`sute_her_<effect>_<difficulty>_*` provide their authored difficulty. Poison
recipes use `Manejo` from `Oficios Basicos - Etapa 2 - 2025 - Venenos.csv`.
The selected 65 recipes are sorted by that value, preserving design-file order
as the tie breaker, and then spread across tiers, DC, and XP. `Agua Pura` is the
only utility recipe without a numeric tag and is explicitly the first exercise.
This ordering changes no output identity: `sPocionBase` remains the creation
resref and `sCustomTag` remains the final item tag used by potion and poison
activation scripts.

Stations without a material family otherwise use their authored recipe order.

### Decisions taken during migration

- **Repeated components are summed.** Poison recipes ask for the same reagent
  twice (`Limo Putrefacto + Limo Putrefacto`); that becomes one row with
  quantity 2 rather than two rows, which the primary key would reject anyway.
- **Stations without submenus get a `General` category**, so every recipe has a
  parent.
- **Oversized legacy submenus are split**, driven by `CATEGORY_SPLITS` in
  `build_catalogue.py`. The legacy `Armaduras Intermedias` mixed scale mail with
  full plate; it now yields `Cotas de Escamas` (14) and `Armaduras Completas`
  (14). A split is declared as the source submenu plus a list of
  `(name prefix, target category)` pairs, matched case-insensitively against the
  recipe's display name by `split_category()`. Categories are created on demand,
  so one legacy submenu can produce several and re-running the generator
  reproduces the same tree.
- Recipes without exact `recipe_metadata` are resolved from their direct legacy
  output, profession JSON or display-name metadata. Every migrated recipe now
  has a non-empty creation resref.
- **The gem recipes were rebuilt from the design.** The legacy scripts asked
  for 22 gems no blueprint has — `bru_diamante` where the item was `bru_diam`,
  today `cnr_g_diam` — plus twenty real-world gems this server simply does not
  have, while 20 real gems had no recipe at all.
  `documentation/oficios/joyeria.json` names 28 gems and every one matches a
  blueprint, so the 60 gem recipes became 56, two per
  gem, driven by that file. All 56 now resolve an Etapa-2 property; the count
  used to be 20 of 60.
- **Alchemy progression combines its two authored difficulty sources.** Potion
  difficulty comes from `sCustomTag`; poison difficulty comes from the
  `Manejo` column. The output resref and tag are copied independently and are
  not derived from tier, DC, or XP.

---

## 9b. The legacy seed is retired

`cnr_sql_init.nss` used to run from `cnr_module_oml` (OnModuleLoad) and issue
**706 statements** on every single boot: 367 `recipe_metadata` rows and 339
`material_properties` rows, plus the `CREATE TABLE` for both. With the catalogue
now owned by the database, that work is pure noise — it reseeded tables that
only the retired station scripts read.

What changed:

| File | Change |
|------|--------|
| `src/cnr/nss/cnr_sql_init.nss` | Emptied to a documented `void main() {}` |
| `src/cnr/nss/cnr_module_oml.nss` | The `ExecuteScript("cnr_sql_init")` call removed |
| `migration/legacy-catalogue-seed.sql` | New. The 706 statements, verbatim |

The `cnr_sql_init` stub is kept so that any `ExecuteScript("cnr_sql_init")`
still sitting in a production-only area or placeable resolves to a no-op
instead of erroring. The retired station scripts are different: their
source-controlled consumers were audited and removed, so those scripts were
deleted.

**Consequence:** `recipe_metadata` and `material_properties` are no longer
created or refreshed. Their only consumer is `cnr_sql_c_item.nss`, the
pre-crafting hook of `cnranvilsmith` / `cnrjewelersbench`, which the generic
engine replaced. If a station is ever pointed back at the old scripts, those
two tables must be restored from the archive first.

The archive is a reference, not a migration. Do not apply it to the live
database: it targets the old schema and would reintroduce the very data the
rework replaced.

---

## 10. Not done yet

- **Masterwork remains intentionally dormant.** `cnr_m_utils.nss` still contains
  the adamantite and gem-jewelry property implementations, but nothing includes
  or calls them. The former one-percent caller and generated crafted-item
  description were retired with `cnr_sql_c_item`. Do not connect the helpers to
  `CnrCraft_Finish` until the feature is deliberately enabled and its exact
  trigger and description contract are approved. In the current state it has
  no runtime effect.
- **Carpentry is incomplete, not absent.** Its two stations, eight woods, and 86
  recipes exist. Recipe properties and harvesting remain in slices 4 and 5 of
  [`carpentry-plan.md`](carpentry-plan.md).
- **Tailoring has an empty catalogue.** The profession and
  `cnrSewingTable` station scaffold exist, but it has no recipes.
- **Enchanting has no catalogue.** `cnrEnchantAltar`, `cnrEnchantStatue`, and
  `cnrEnchantPool` have no station row or recipe file.

## 11. Station compatibility boundary

`cnr_device_ou` supports only stations registered in `cnr_station`. An unknown
tag reports a player-facing configuration error and does not enter a legacy
recipe path. Source-controlled station blueprints and placed instances use
`OnUsed = cnr_device_ou` and no `OnInventoryDisturbed`, `OnOpen`, or `OnClosed`
script. `cnr_device_ou` explicitly starts `cnr_c_station`, so the runtime does
not depend on a legacy conversation fallback.

All ten placed DEV test-area instances also set
`Conversation = cnr_c_station`. The retained `herreria_yunque` and
`sute_met_forja` source blueprints currently leave that field empty while the
other six retained station blueprints set it. This does not break the explicit
OnUsed path, but production promotion should normalize every blueprint and
instance to the same visible contract.

Production-only areas must be inventoried before deployment. Any station still
using `cnr_c_recipe`, `cnr_forge_ou`, `cnr_forge_od`, or `cnr_device_od` must be
reconfigured; those resources no longer exist.

The earlier note that `CnrCraft_ListRecipes` estimated an attainable DC as
`10 + bonus + 20` is obsolete. The current function filters only by the four
level tiers and orders enabled recipes by tier, DC, and XP; it contains no
roll-based visibility estimate.

---

## Generic stack increase reverted - 2026-09-18

The eight generic base types changed by DEV commit `24b4c6efc` now have their
original Stacking limit of 1 again: rows 24, 29, 79, 101, 211, 212, 307 and 311.
Only those cells changed; all unrelated current 2DA adjustments are preserved.
Gems, potions and other pre-existing stackable types retain their prior limits.
This removes the unintended stack-10 behavior from unrelated items sharing
those types. CNR materials using the same types also return to stack 1.

**Deferred by the owner:** dedicated stack-10 types for CNR-owned items, their
blueprint/shop reassignment, sale in packs of ten and stacked-tool breakage
handling. No dedicated rows, item remapping or shop quantity changes are
implemented in this slice. Native SetItemStackSize clamps to the item-type
maximum, so initial UTI StackSize cannot independently raise that limit.
The source change requires repacking the owning 2DA HAK before runtime testing.

---

## Infinite test-chest stock remains account-transferable — 2026-08-28

The six infinite material chests in the DEV tradeskill area identify their
replenished items with `CNR_STOCK`. Those items are test infrastructure and are
deliberately exempt from the module's same-account character-transfer guard;
production items without that marker still follow the guard unchanged.

The module acquisition event adds a local variable whose name is the acquiring
player's public CD key. The old chest script called `CopyItem` with `bCopyVars`
enabled after acquisition, so it copied that ownership marker back into the
replacement stock. A different character on the same account then received an
already-owned item and the transfer guard destroyed it.

The native `CopyItem` contract explicitly says that `bCopyVars` copies local
variables. The chest therefore creates its replacement with that option
disabled and restores only the three intentional integer variables found in
the six placed chests: `CNR_STOCK`, `CNR_OFICIO`, and `CNR_LOOT_TIER`. The
acquisition guard exits early for `CNR_STOCK`, which also permits testers to
move those materials between their own test characters without losing them.

This is an explicit allowlist. New test-stock metadata must be added to it
deliberately; arbitrary acquisition, quest, or ownership locals must never be
copied into permanent chest stock.

---

## Las palancas de pruebas — 2026-08-18

Las siete palancas del área de oficios (`cnrTradeLever`) abren ahora una
conversación en vez de subir el nivel de golpe:

```
Palanca de pruebas: Herreria.

Ahora mismo tienes nivel 7.

1. Subir un nivel de oficio.
2. Bajar un nivel de oficio.
3. Salir.
```

Bajar es lo que faltaba: hasta ahora, pasarse de nivel probando obligaba a
llamar a un DM.

Qué oficio mueve cada palanca **se sigue leyendo de su propio nombre** —
"Lever: Herreria"—, que es como estaba y evita tener que mantener una lista
aparte: las siete son el mismo placeable con distinto nombre.

| Fichero | Qué es |
|---|---|
| `cnr_i_lever.nss` | el oficio a partir del nombre, y el movimiento de nivel |
| `cnr_trade_lever.nss` | OnUsed: abre la conversación |
| `cnr_lever_up.nss` / `cnr_lever_down.nss` | las dos acciones, una línea cada una |
| `cnr_c_lever.dlg.json` | el diálogo |

Los topes se avisan sin tocar nada: nivel 20 arriba, nivel 1 abajo. **Son una
herramienta de pruebas y no deben llegar a producción.**

---

## La prueba del blueprint y las pilas — 2026-08-18

Antes de cobrar nada, `CnrCraft_Start` comprueba que el producto de la receta
existe de verdad: crea uno en la estación y lo retira. Eso es lo que evita que
una receta con un resref inexistente se lleve el material y el oro sin dar nada.

Retirarlo **no puede ser un `DestroyObject`**. Si la estación ya tenía ese mismo
objeto, el de la prueba se apila con los suyos y destruir el objeto destruye la
pila entera. Lo reportaron los joyeros: con gemas talladas en la mesa, elegir
una receta se llevaba todas las de ese tipo.

Ahora se mira el tamaño de la pila: si es mayor que uno, se le resta uno; si el
objeto está solo, se destruye. El inventario queda como estaba.

Es el tipo de fallo que solo aparece cuando algo apila, así que apareció el
mismo día en que los materiales pasaron a apilar de diez.

---

## El último peldaño de Atrás no llevaba a ninguna parte — 2026-08-19

Arreglo del arreglo de abajo. `cnr_a_back` calculaba bien el peldaño, pero el
diálogo no le hacía caso: el enlace de la respuesta [Atrás] de las pantallas de
lista apuntaba a la pantalla de categorías **sin condición**, así que iba allí
pasara lo que pasara.

Con el peldaño nuevo eso se volvió un callejón. Desde las categorías, [Atrás]
pone `CNR_AT_MENU` y vacía la lista, y el diálogo volvía a enseñar la pantalla
de categorías: sin líneas, sin paginación, con el texto "Selecciona una
categoria" y nada que seleccionar. Volver a pulsar [Atrás] repetía lo mismo,
así que sólo se salía con Escape.

Las dos respuestas [Atrás] llevan ahora la misma cadena de enlaces, la que ya
usaban las de lista:

| Orden | Pantalla | Condición |
|--:|---|---|
| 1 | productos | `cnr_c_prod` |
| 2 | categorías | `cnr_c_cat` |
| 3 | menú de acciones | sin condición |

De paso arregla otro salto torcido: desde la lista de variantes, [Atrás]
reconstruía la lista de recetas y luego enseñaba el texto de categorías encima.

---

## Atrás sube un peldaño, y el último sale del menú — 2026-08-19

`cnr_a_back` listaba las categorías hiciera lo que hiciera, así que desde la
lista de categorías **no había forma de volver al menú de acciones**: te dejaba
donde estabas. Lo reportaron los testers en todas las mesas.

Ahora sube de uno en uno:

| Dónde estás | Adónde te lleva |
|---|---|
| Lista de productos de una receta con variantes | a la lista de recetas |
| Detalle de una receta | a la lista de recetas de su categoría |
| Lista de recetas | a las categorías |
| Categorías | **al menú de acciones** |

El último peldaño necesita una bandera, `CNR_AT_MENU`: la pantalla de
categorías se muestra siempre que nadie más reclama el turno, así que hay que
decirle que se aparte para que salga la entrada del menú, que no tiene
condición. La bandera se borra al abrir la mesa y al entrar en las categorías.

De paso, el detalle ya no salta hasta las categorías: vuelve a la lista de
recetas de la que salió.

## Profession-only stacks - 2026-09-18

Dedicated base types give inventoried profession materials and consumable
components a maximum stack of ten; original shared base rows retain their
existing limits. Every station and harvesting tool is unitary, including tools
required only in inventory or on a station. Shop copies sell materials in packs
and tools one at a time. Crafted equipment keeps its native limits. The exact
resource and shop inventories, dedicated row mapping and release checks live in
[profession-stacking.md](profession-stacking.md). HAK and module repacking and
runtime acceptance remain pending.
