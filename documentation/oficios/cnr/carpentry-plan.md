# Carpentry — Implementation Plan

Bringing Carpintería (profession 2) into the database-driven crafting system:
two stations, 8 wood materials, 86 recipes.

Design source: `documentation/oficios/Oficios Basicos - Etapa 1 - 2026 -
Carpinteria - En progreso.csv`.

Status 2026-08-15: slices 1, 3 and 4 are delivered. The catalogue has two
registered stations, eight materials and 86 recipes carrying their properties.
Two things remain, and both are tracked in
[`open-issues.md`](open-issues.md) rather than here: the item-level runtime
proof for slice 2's four property constructors, and harvesting (slice 5).

Checklist rules are the same as
`build_catalogue.py`: every slice states
its exit test, and a slice is not closed until that test passes.

---

## 0. Starting inventory

This section records the repository state before slice 1. The current state is
the status summary above and the completed-slice record below.

### Blueprints — all present, none to create

| Family | Blueprints |
|--------|-----------|
| Logs | `carplenyo_*` × 8 |
| Planks | `carptablon_*` × 8 |
| Tools | `carp_kitserr`, `carp_sierra`, `carp_kitcarp` |
| Components | `carpac2_plumas`, `carpacc_puntas1`, `carpacc_puntas2`, `carpacc_aros`, `carpacc_cuerda1`, `carpacc_cuerda2`, `carpacc_mangoc`, `carpacc_plancha1`, `carpacc_plancha2` |
| Harvesting | `carp_at1`..`carp_at8` (fellable trees), `carp_hl` / `carp_hlp` (axes) |

Product blueprints are **not** needed per material. Smithing already proves the
model: one base resref plus per-recipe properties. A bow is `nw_wbwsh` with
Zalantar's properties applied, exactly as a longsword is `wswls002` with
Mithril's.

### Placeables

| Tag | Blueprint | Role |
|-----|-----------|------|
| `cnrSawTable` | `carp_tablaserr` — "Tabla de serrería" | Sawing table |
| `carp_serrador_a`, `carp_serrador_c` | same blueprint | Two more sawing tables in the test area |
| `cnrCarpsBench`, `carp_carp_a`, `carp_carp_c` | `carp_bancocar001` — "Table, Celtic" | Carpenter's bench |

At the start of the plan, the intended Carpentry tags were not registered in
`cnr_station`, and one test-area instance still used the unrelated legacy tag
`cnrcarpelf`. Slices 1 and 3 subsequently registered `cnrSawTable` and
`cnrCarpsBench` and wired their current instances to the generic station path.

---

## 1. The finding that governs everything: tags lie, names tell the truth

**The `carplenyo_*` and `carptablon_*` tags do not name the wood they contain.**
The tag is a legacy placeholder; the item's display name carries the real design
wood. Cross-referencing the CSV against the blueprint names resolves all eight,
in the CSV's own top-to-bottom order:

| CSV material | Tier | Log tag | Log name | Plank tag | Plank name |
|---|:-:|---|---|---|---|
| Pino | 1 | `carplenyo_pino` | Leño de pino | `carptablon_pino` | Tablones de pino |
| Cedro | 1 | `carplenyo_cipres` | Leño de cedro | `carptablon_cipre` | Tablones de cedro |
| Abeto | 2 | `carplenyo_abeto` | Leño de abeto | `carptablon_abeto` | Tablones de abeto |
| Roble | 2 | `carplenyo_cedro` | Leño de roble | `carptablon_cedro` | Tablones de roble |
| Sombralto | 3 | `carplenyo_alamo` | Leño de sombralto | `carptablon_alamo` | Tablones de sombralto |
| Leñocaso | 3 | `carplenyo_olmo` | Leño de Leñocaso | `carptablon_olmo` | Tablones de Leñocaso |
| Zalantar | 4 | `carplenyo_roble` | Leño de zalantar | `carptablon_roble` | Tablones de zalantar |
| Maderadique | 4 | `carplenyo_fresno` | Leño de maderadique | `carptablon_fresn` | Tablones de maderadique |

Note `carplenyo_roble` is **Zalantar**, not oak — oak is `carplenyo_cedro`.
Writing recipes from the tags would silently pair every wood with the wrong
properties. Recipes must be authored from this table.

The tiers are not a judgement call: the CSV already groups the woods under
`Nivel 1 (8 ó menos)` … `Nivel 4 (16 o más)`, two per tier.

### The tags are left alone

Decided: **no tag is changed.** The tag is an opaque key, and the table above is
the authority for pairing one with its design row.

**Reversed on 2026-08-23 for the names.** The original decision left three
blueprints reading a wood the design does not have: `carptablon_cipre` said
"Tablones de ciprés", and the Leñocaso pair said "del crepúsculo". The reasoning
was that recipes bind by tag, so the display text costs nothing. It cost a
tester an afternoon: making cedar items, every component list asked for cypress
planks, and the cypress planks in the chest worked. Display text is the only
part of this a player can see.

The three names, and the descriptions with them, now say the design's wood.
Tags, resrefs and components are untouched, exactly as this section requires.
The tree nodes were corrected in the same pass, so a tree, its log, its plank
and the recipes that consume it all name the same wood.

**Consequence:** this table is not documentation, it is the specification. Any
future edit to a carpentry recipe must come back to it. Reading a tag as if it
named its wood is the one mistake that produces silently wrong items.

---

## 2. Two stations

**Station tags follow the `cnr*` convention**, like every other station:
`cnrSawTable` and `cnrCarpsBench`. The tag is what `cnr_i_craft` looks up and
what names the catalogue file; the **resref stays whatever the blueprint is**
(`carp_tablaserr`, `carp_bancocarp`), exactly as `cnrAnvilSmith` sits on
`herreria_yunque` and `cnrSewingTable` on `sapo_mesa_marroq`.

They were first registered under their placeable tags, which broke that
convention. Renamed in the generator, both `.utp` blueprints, both placed
instances, and both catalogue files.


Carpentry is the first profession with a **two-step chain**: raw → material →
product. The database already models this with `cnr_station.produces`.

| | Sawing table | Carpenter's bench |
|---|---|---|
| Tag | `cnrSawTable` | `cnrCarpsBench` |
| `produces` | `material` | `product` |
| Tools | `carp_kitserr` (medium breakage), `carp_sierra` (low) | `carp_kitcarp` (low) |
| Recipes | 8 | 78 |
| XP | ×0.30, as every material station | full |

Both get `OnUsed = cnr_device_ou`, `Conversation = cnr_c_station`, and empty
`OnInventoryDisturbed`, `OnOpen`, and `OnClosed` events, per
[`crafting-system.md`](crafting-system.md) §8.

**Sawing:** 3 logs of a wood → 1 plank of that wood. Neither tool is consumed;
both roll their own breakage chance.

---

## 3. Recipe families

The bench's material is the **plank**. Every recipe also requires
`carp_kitcarp`, which is never consumed.

| Category | Extra components | Planks | Output |
|---|---|:-:|---|
| Flechas | `carpac2_plumas`, `carpacc_puntas1` | 1 | 99 arrows |
| Virotes | `carpacc_puntas2`, `carpacc_aros` | 1 | 99 bolts |
| Arcos cortos | `carpacc_cuerda1` | 1 | short bow |
| Arcos largos | `carpacc_cuerda1` | 2 | long bow |
| Ballestas ligeras | `carpacc_cuerda2` | 2 | light crossbow |
| Ballestas pesadas | `carpacc_cuerda2` | 4 | heavy crossbow |
| Clavas | `carpacc_mangoc` | 2 | club |
| Bastones | `carpacc_aros` ×2 | 2 | quarterstaff |
| Escudos grandes | `carpacc_plancha2` | 3 | large shield |
| Escudos pequeños | `carpacc_plancha1` | 2 | small shield |

Ten families × 8 woods = 80, **minus 2**: Sombralto makes no arrows and no
bolts, so those recipes do not exist rather than existing without properties.

**78 bench recipes**, plus 8 sawing recipes = 86.

The CSV supplies seven property sets: Arcos, Ballestas, Virotes, Flechas,
Clavas, Bastones, Escudos. Short and long bows share the Arcos set, light and
heavy crossbows share Ballestas, both shields share Escudos.

---

## 4. Resolved decisions

Every question this plan opened has been answered.

| Question | Decision |
|---|---|
| Planks per arrow / bolt recipe | **1**, same as any other single-material family |
| "Reforzado 2/3/4" | **Mighty** |
| "Afiladura" | **Keen**, the same as "Afilado" |
| Sombralto arrows and bolts | They **do not exist**. 78 bench recipes, not 80 |
| Misnamed tags and `carptablon_cipre` | Left as they are; §1 is the binding map |
| `cnrcarpelf` | Not the sawing table. It is a stale tag on one test-area instance, wired only to report that it is unregistered. The station is `cnrSawTable` |

Still to settle when the stations are wired, not blocking any slice:
`carp_serrador_a`/`_c` and `carp_carp_a`/`_c` are extra test-area instances.
Station lookup is by tag, so they are either retagged onto the two real
stations or given rows of their own.

---

## 5. Engine work: four property types are missing

`cnr_apply_prop.nss` handles 20 property types. The carpentry design needs four
it does not have. **Every constructor below was verified by compiling it**, not
taken from memory:

| Design wording | Property | NWScript constructor |
|---|---|---|
| "Reforzado 2/3/4" | `Mighty` | `ItemPropertyMaxRangeStrengthMod(n)` |
| "Ataque 4", "5 Ataque" | `AttackBonus` | `ItemPropertyAttackBonus(n)` |
| "1d4…1d10 Criticos Masivos" | `MassiveCriticals` | `ItemPropertyMassiveCritical(IP_CONST_DAMAGEBONUS_*)` |
| "Ralentizar CD 14/16" | `OnHitSlow` | `ItemPropertyOnHitProps(IP_CONST_ONHIT_SLOW, IP_CONST_ONHIT_SAVEDC_*)` |

**`ItemPropertyMighty` does not exist.** Mighty is
`ItemPropertyMaxRangeStrengthMod` in script; the obvious name fails to compile
with `UNDEFINED IDENTIFIER`.

Already present and needing no work: `Stun` ("Aturdir CD 16"),
`EnhancementBonus` ("Mejora N"), `DamageBonus` ("1dN <tipo>"), `ACBonus`
("CA N"), `DamageImmunity` ("N% Resistencia/Inmunidad"), `SpellFailure`
("N% Reducción Fallo conjuro"), `Keen` ("Afilado" and "Afiladura").

Note `itemproperty` cannot be initialised at its declaration with this
compiler — declare it, then assign, as `cnr_apply_prop.nss` already does.

The generator **rejects** property types the engine cannot apply, so these four
branches are a hard prerequisite for slice 4.

---

## 6. Slices

Each ends with a Codex audit and one commit, no push.

### Slice 1 — Materials and the sawing chain — **DONE 2026-08-10**

Result:

- `documentation/oficios/carpinteria.json` — new design source, generated once
  from the CSV plus the blueprint display names. It carries, per wood: tier, log
  tag, plank tag, both display names, and the seven property strings verbatim
  for slice 4. **This file is the binding between a wood and its tags**; §1 is
  its human-readable form.
- 8 woods in `cnr_material` for profession 2, tiers straight from the CSV's own
  `Nivel 1`..`Nivel 4` headers.
- `cnrSawTable` registered: profession 2, `produces = material`,
  `cnr_carp_anim`. Tools `carp_kitserr` at 0.3 and `carp_sierra` at 0.1 — 0.3 is
  the rate every other tool in the system uses, so it reads as the house
  "medium", and the saw is deliberately a third of that.
- `migration/catalogue/cnrsawtable.json` — 8 recipes, 3 logs → 1 plank.
- The placeable now carries `OnUsed = cnr_device_ou`,
  `Conversation = cnr_c_station`, and empty `OnInvDisturbed` / `OnOpen` /
  `OnClosed`, mirroring the working stations exactly.

Two things worth keeping in mind:

**The recipe name and blueprint name must be identical.** `cnr_i_craft.nss`
calls `SetName()` on the item it makes, while the component list and the testing
chest keep the blueprint name. A capitalization difference therefore creates
two otherwise identical stacks. The eight sawmill recipes now use the exact
names of their `src/cnr/uti/carptablon_*` blueprints; their output tag and resref
already matched those blueprints. The three stale labels in the custom item
palette were also aligned with the Cedro and Leñocaso blueprint names.

**The generator will not silently mis-pair a wood again.** The mapping lives in
`carpinteria.json` and the plank exception is declared explicitly rather than
matched by name, so `carptablon_cipre` cannot drift onto the wrong wood.

The placeable's old `OnOpen` / `OnClosed` pointed at `carp_serrador_a` /
`carp_serrador_c`, a self-contained legacy sawing system with its own
`NIVELSERRERIA` progression. Wiring the station replaces it. Those four scripts
(`carp_serrador_*`, `carp_carp_*`) became unreferenced by this placeable. They
were subsequently removed by the legacy-profession cleanup recorded in
[`legacy-removal-and-production-promotion.md`](legacy-removal-and-production-promotion.md).

*Verified:* all 8 recipes checked row by row against the design — material code,
tier, output resref and the exact log consumed, including the pairs that read
wrong (`Roble` → `carplenyo_cedro`, `Zalantar` → `carplenyo_roble`). Applied to
MySQL; generator idempotent; `--check` compiles 5410 successful, 0 errored.

DC runs 10→35 and XP 4→14 across the eight, the material-station 0.30 factor
already applied.

#### Original scope
- Fix `carptablon_cipre`'s name to "Tablones de cedro".
- Add the 8 woods to `cnr_material` for profession 2, tiers from the CSV.
- New `migration/catalogue/cnrsawtable.json`: 8 recipes, 3 logs → 1 plank,
  both tools with their breakage.
- Register the sawing station; wire its placeable.

*Exit:* 8 sawing recipes in MySQL, each consuming the correct log for its wood —
verified against the name table in §1, not the tags. Menu opens in game.

### Slice 2 — The four missing property types — **ENGINE COMPLETE; RUNTIME EXIT PENDING**

Added to **both** consumers, `cnr_i_prop.nss` (what the engine calls) and
`cnr_apply_prop.nss` (the standalone script):

| Property | Constructor | Authoring |
|---|---|---|
| `Mighty` | `ItemPropertyMaxRangeStrengthMod(v1)` | `value1` = cap |
| `AttackBonus` | `ItemPropertyAttackBonus(v1)` | `value1` = bonus |
| `MassiveCriticals` | `ItemPropertyMassiveCritical(CnrProp_DamageAmount(v1, v2))` | same die shorthand as `DamageBonus` |
| `OnHitSlow` | `ItemPropertyOnHitProps(IP_CONST_ONHIT_SLOW, v1)` | `value1` = `IP_CONST_ONHIT_SAVEDC_*` |

`ItemPropertyMighty` does not exist — confirmed by compiling, not assumed.

**The generator now validates both consumers and requires them to agree.** It
previously read only `cnr_apply_prop.nss`, which is *not* the file the engine
calls; a type added to one and not the other would have passed the build and
failed silently in game. Verified by removing a branch from one file only: the
generator stops with
`cnr_i_prop.nss and cnr_apply_prop.nss disagree on: OnHitSlow, OnHitSlowXX`.

*Exit test not yet met:* the four are compiled and accepted, but no recipe uses
them until slice 4, so none has been seen on an item in game.

#### Original scope
- `Mighty`, `AttackBonus`, `MassiveCriticals`, `OnHitSlow` in
  `cnr_apply_prop.nss`, and the generator's accepted list.

*Exit:* a test recipe carrying each one produces an item with the property
visible in its description.

### Slice 3 — Bench recipes without properties — **DONE 2026-08-11**

78 recipes in ten categories, `cnrCarpsBench` registered with `carp_kitcarp` at
0.1, the placeable wired like the sawing table. Ammunition is 7 rather than 8:
Sombralto makes none.

**A base resref must not be resolved.** The recipes first asked for
`nw_wbwln001` and got `pb_parclaarco01` — *Arco de Anirin*, a unique magic item.
`resolve_resref()` matches tags as well as resrefs, and PDB has named blueprints
that keep the base item's tag; bastones and ballestas pesadas were hijacked the
same way. **The counts were all correct**, so nothing reported it; it surfaced
only by reading the generated resrefs back.

Fixed at the root: a recipe may state `base_resref` in its JSON and the
generator then uses it verbatim, resolving nothing. All 78 do. Documented in
[`schema.md`](schema.md).

Outputs, all verified as `TemplateResRef` values already instanced in the
module: `nw_wamar001`, `nw_wambo001`, `nw_wbwsh001`, `nw_wbwln001`,
`nw_wbwxl001`, `nw_wbwxh001`, `nw_wblcl001`, `nw_wdbqs001`, plus the two shields
smithing uses. Large shields have since been unified across both professions
onto **`ashlw002`**, the only large-shield resref in the catalogue;
`pb_athtemescudo2` is gone because it carried `Armor +3`. Small shields remain
`nw_ashsw001` here and `pb_cammolescudo2` in smithing.

*Verified:* 78 recipes over 10 categories, every wood → plank → tier pairing
checked against the design with zero mismatches; the 107 recipes whose names
match a carpentry family (the 78 plus smithing's shields) all carry the intended
resref; ammunition stacks at 99. Applied to MySQL: 86 carpentry recipes.
Generator idempotent. No `.nss` changed, so nothing to compile.

#### Original scope
- Register the bench station and wire its placeable.
- New `migration/catalogue/cnrcarpsbench.json`: the 78 recipes, correct
  components and quantities, `carp_kitcarp` on every one.

*Exit:* 78 recipes browsable in ten categories; components resolve to real
blueprints; a craft consumes the right planks and returns the tool.

### Slice 4 — Properties from the CSV — **DONE 2026-08-11**

174 property rows over all 78 bench recipes. Every one checked against the
design: **zero discrepancies**.

The CSV states properties as Spanish prose, so `build_catalogue.py` parses it.
The parser **raises on any clause it cannot map** — a silently dropped clause is
an item quietly missing a designed property, which no count would reveal. It
handles the messy reality of the sheet: `Mejora 1` and `1 mejora`, `CA3` and
`CA 3`, `Daño físico` and `daño físico`, and the compound
`1d4 Ácido CD 16 Ralentizar`, which becomes two rows.

Rows per property type:

| | | | |
|---|--:|---|--:|
| `DamageBonus` | 32 | `ACBonus` | 16 |
| `EnhancementBonus` | 28 | `Mighty` | 12 |
| `MassiveCriticals` | 22 | `DamageImmunity` | 10 |
| `Keen` | 22 | `OnHitSlow` | 6 |
| `AttackBonus` | 16 | `Stun` | 4 |
| `SpellFailure` | 6 | | |

All four types added in slice 2 are now **exercised by real recipe data**. That
is not the same as its exit test, which asks for the property to be visible on a
crafted item in game — **that check is still pending**, for this slice and for
slice 2.

Indices were read from the 2das, not memory: `iprp_immuncost.2da` confirms
5%=1, 10%=2, 20%=8; damage types come from `iprp_damagetype.2da`; on-hit save
DCs are indices, so CD 14 is `0` and CD 16 is `1`.

#### Every clause maps — including the one first reported as impossible

Six shield recipes ask for **"5% Reducción Fallo conjuro"** (one written `5&`).
This was first recorded as inexpressible in NWN, on the strength of a reference
table listing only -50%, -30%, -25% and -20%.

**That was wrong.** The table was incomplete. Reading the constants out of
compiled bytecode gives the full set:

| Index | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | **9** |
|---|---|---|---|---|---|---|---|---|---|---|
| Reduction | -50% | -45% | -40% | -35% | -30% | -25% | -20% | -15% | -10% | **-5%** |

Ten constants, linear: `index = (50 - percent) / 5`. A first correction listed
only seven and called it complete, because only the constants guessed at were
tested — the same mistake one layer down.

`src/shared/nss/cr_onequip.nss:40` had been using
`IP_CONST_ARCANE_SPELL_FAILURE_MINUS_5_PERCENT` all along. The six shields now
carry `SpellFailure` index 9 alongside their AC bonus, and **no clause in the
whole design goes unmapped**.

591 property rows, not 585.


#### Original scope
- Parse the seven property columns into `cnr_recipe_property`.
- Needs slice 2 merged.

*Exit:* every enabled bench recipe resolves at least one property, the Sombralto
ammunition rows simply not existing. Same zero-orphan guard the jewelry
rebuild uses.

### Harvesting — **out of scope**

Removed at the user's direction. Tying `carp_at1`..`carp_at8` to the logs they
should drop is not part of this plan and must not be started without being
asked for.

---

## 7. Why this order

Slice 1 is self-contained and proves the two-station chain works before 80
recipes depend on it. Slice 2 is pure engine work with no data. Slice 3 delivers
a playable bench even with no properties — recipes that build plain items are
better than none. Slice 4 makes them worth building. Where the logs
come from is deliberately not covered here.
