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

Since 2026-09-18, all seven professions share a cumulative curve reaching
level 20 at **5000 XP**. `cnr_trade_init.nss` initializes the twenty
`CnrTradeXPLevel<n>` module locals used by XP persistence, profession-limit
checks, the tradeskill book and administrative level helpers. The curve is
one fifth of the original 25000-XP thresholds; recipe XP and DC are unchanged.

| Level | Cumulative XP | Level | Cumulative XP |
|--:|--:|--:|--:|
| 1 | 0 | 11 | 1150 |
| 2 | 25 | 12 | 1400 |
| 3 | 50 | 13 | 1675 |
| 4 | 100 | 14 | 1975 |
| 5 | 175 | 15 | 2395 |
| 6 | 275 | 16 | 2850 |
| 7 | 400 | 17 | 3340 |
| 8 | 550 | 18 | 3860 |
| 9 | 725 | 19 | 4400 |
| 10 | 925 | 20 | 5000 |

Source-model estimates from zero, with prepared components available and the
highest-XP enabled recipe whose minimum level is reached:

| Profession | Perfect successes | Expected attempts, final help +2 | Expected attempts, final help +3 |
|---|--:|--:|--:|
| Smithing | 90 | 154 | 143 |
| Carpentry | 94 | 150 | 140 |
| Leatherworking | 92 | 151 | 141 |
| Alchemy | 87 | 159 | 147 |
| Jewellery | 88 | 158 | 146 |
| Tailoring | 92 | 151 | 141 |
| Arcane | 66 | 168 | 150 |

These are attempts, not output units or measured player runs. Select by highest
XP, then lowest gold, lowest DC and lowest recipe ID; Arcane uses lowest computed
step DC and property ID for ties. Carry XP overshoot across levels. Natural 1
fails, natural 20 succeeds, and failed attempts pay truncated 12% XP. The final
help contribution is after ability/Craft-rank averaging. Materials, tools,
travel, node availability and preparing one's own inputs add separate costs.

The chosen curve gives approximately 19.75-19.83% fewer attempts with final
help +2 than the prior 6250-XP reference. Copper ingots still pay six XP per
success: four successes give 24 XP and level 1; five give 30 XP and level 2.
The two non-Alchemy-profession limit and Alchemy exemption remain unchanged.
Harvesting and skinning yields, DC, cooldowns, refill and wear are unchanged.

The estimates use the tracked September catalogue: 559 recipes and 484 Arcane
steps. For each XP state x, let A be success XP, F = floor(0.12*A), p the actual
success probability and T remaining expected attempts. With T(x >= 5000) = 0,
solve downward: T(x) = 1 + p*T(x+A) + (1-p)*T(x+F) when F > 0, or
T(x) = 1/p + T(x+A) when F = 0. This records the numerical model; host behavior
and persistence still need the authorized runtime acceptance listed in the
September changelog. The change applies to fresh testing progression and
introduces no character-data migration.

---

## 5. The craft roll

```nwscript
int nRoll  = d20();
int nTotal = nRoll + CnrCraft_GetRollBonus(oPC, nProfession);
int bOk    = (nRoll == 20) || (nRoll != 1 && nTotal >= nDC);
```

`CnrCraft_GetRollBonus` calculates:

- `craft_bonus = floor(base Craft ranks / 5)`, using ranks only and no item
  bonuses;
- `ability_bonus = floor((ability_1 modifier + ability_2 modifier) / 2)`;
- `help_bonus = floor((ability_bonus + craft_bonus) / 2)`;
- final roll bonus = profession level + `help_bonus`.

Mathematical floor is explicit. NWScript's ordinary integer division truncates
negative values toward zero, so `CnrCraft_FloorDivide` handles ability
penalties correctly.

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
contributed anything, and with the double halving above it very often does
not: below 14/14 in both abilities and 10 base Craft ranks it is exactly zero.

Failure pays `CNR_XP_FAILURE_PERCENT` (12%) of the recipe's XP, truncated by
the integer division: a recipe worth 21 pays 2, not 3. Success pays it
in full and creates the item after the station animation finishes.

**Experience stops at level 20.** `PersistDetermineTradeskillLevel` counts down
from 20, so past its threshold experience only accumulated and the level never
moved. `CnrSkill_IsMaxLevel` gates the award and the player is told the
profession is mastered instead of being promised experience that does nothing.

**Gold is charged.** It is the last check and the first cost: nothing is taken
until tools, materials and the profession limit have passed, and once taken the
attempt happens, so a failed roll costs the gold exactly as it costs the
materials.

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

The character editor applies the same validation when an administrator saves
tradeskill XP.

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
DC        = position spread over 10..35
XP        = position spread over 21..81, times 0.30 for material outputs
gold      = DC * 12
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

Dedicated base types now give the inventoried profession materials and tools a
maximum stack of ten; original shared base rows retain their existing limits.
Shop copies sell selected supplies and tools in packs of ten. Crafted equipment
retains its existing types and limits. The exact scope, identities, type map,
compatibility boundary and release tests live in
[profession-stacking.md](profession-stacking.md). HAK and module repacking and
in-game acceptance are required; source edits do not establish deployed state.
