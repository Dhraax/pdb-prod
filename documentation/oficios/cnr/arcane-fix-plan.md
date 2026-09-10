# Arcane fix plan — 2026-08-23

Reported from testing at arcane level 20, on the Mesa de Artesanía urdímbrica.
Every open question has been answered by the user; nothing here waits on a
decision.

**Status: slices 1, 3 and 4 done; slice 2 cancelled. Nothing tested in game.** Four slices, in this order. Each is a
commit of its own and is audited with `scripts/agent_audit.sh` before the next
one starts — a candidate buried under later commits cannot be finalised, which
is what five retroactive audits demonstrated earlier today.

| # | Slice | Depends on | State |
|--:|---|---|---|
| 1 | The DC belongs to the step, and stops at 35 | — | **done** |
| 2 | Tier 3 gets one colour | — | **cancelled**, nothing was wrong |
| 3 | `[Encantado]` on every enchanted piece | — | **done** |
| 4 | The window asks for a name and a description | 3 | **done** |

---

## What was reported

> Esperaba que la DC aumentara de dificultad conforme se pasa de +1 a +2, +3…
> Ahora mismo la DC varía en función de la característica.
> FUE DC23, DES DC24, CON DC25, INT DC26, SAB DC26, CAR DC27

Confirmed, and it is not limited to the six abilities.

---

## Slice 1 — The DC belongs to the step, not to the property — **done**

### Why it happens

`dc` is a column of **`cnr_arcane_property`** (`migration/01_schema.sql:278`),
one value per property, and `cnr_arcane_step` has none
(`01_schema.sql:294-309`). Every step of a property therefore inherits the same
number, and what the player rolls against varies with the property he picked
rather than with the power he asked for. The number the tester read as "the DC
of Strength" is really "the DC at which Strength unlocks".

**It reaches 93 of the 105 properties.** There are 484 steps across 105
properties, and only 12 properties have a single step; every other one would be
flat from its first value to its last without this rule.

### The rule

```
entry = min(cnr_arcane_property.dc, 35 - (step_count - 1))
DC    = entry + (rung - 1)
```

`rung` is the step's **place** in its property's ladder, counting from 1 — not
the essences it costs. Each rung is one DC harder than the one below it, and
**no ladder tops above 35**. 35 is not a new number: it is the ceiling the rest
of the CNR already uses, as `migration/03_catalogue.sql` runs 10 to 35 across
all 513 recipes.

**Pricing by rung and not by essences is the whole correctness of this.** Half
the ladders do not spend one essence per rung: the eleven damage properties go
1, 2, 4, 6, 8 — five rungs, not eight — and truncated spell-slot progressions
go 2, 3, 4 for spell levels 1, 2, 3. Tying the DC to the essence count would
skip the entry DC for those classes and would still overcharge the damage
ladders. The rung is the only common unit.

The six abilities come out like this, none of them capped:

| | +1 | +2 | +3 | +4 | +5 | +6 |
|---|--:|--:|--:|--:|--:|--:|
| Fuerza | 23 | 24 | 25 | 26 | 27 | 28 |
| Destreza | 24 | 25 | 26 | 27 | 28 | 29 |
| Constitucion | 25 | 26 | 27 | 28 | 29 | 30 |
| Inteligencia | 26 | 27 | 28 | 29 | 30 | 31 |
| Sabiduria | 26 | 27 | 28 | 29 | 30 | 31 |
| Carisma | 27 | 28 | 29 | 30 | 31 | 32 |

Inteligencia and Sabiduria start on the same number because their **properties**
carry the same `dc` in the design, both unlocking at level 13. That is a tie
between two properties, not a repeat inside one ladder, and the user accepted
it: *"no es problema mientras haya una evolución escalonada de la DC"*.

### The eleven that get lowered

**11 of the 105 properties** would have run past 35 and are pulled down so the
last rung lands exactly on it. The ladder keeps its +1 per rung; the whole thing
shifts, by 4 points at the most.

| Property | Section | Rungs | Level | Before | After |
|---|---|--:|--:|---|---|
| Daño fuerza | DAÑO (ARMAS) | 5 | 20 | 35..39 | 31..35 |
| Daño radiante | DAÑO (ARMAS) | 5 | 19 | 34..38 | 31..35 |
| Daño necrótico | DAÑO (ARMAS) | 5 | 19 | 34..38 | 31..35 |
| Daño psíquico | DAÑO (ARMAS) | 5 | 18 | 33..37 | 31..35 |
| Trueno | DAÑO (ARMAS) | 5 | 18 | 32..36 | 31..35 |
| Ácido | DAÑO (ARMAS) | 5 | 17 | 32..36 | 31..35 |
| Radiante | INMUNIDAD AL DAÑO | 4 | 20 | 35..38 | 32..35 |
| Fuerza | INMUNIDAD AL DAÑO | 4 | 20 | 35..38 | 32..35 |
| Psíquico | INMUNIDAD AL DAÑO | 4 | 19 | 34..37 | 32..35 |
| Necrótico | INMUNIDAD AL DAÑO | 4 | 19 | 34..37 | 32..35 |
| Reduccion de daño | OTROS | 4 | 19 | 33..36 | 32..35 |

The other 94 keep the entry DC the design authored, and the 12 single-rung
properties are untouched by construction: one rung means the DC is the
property's own.

**The damage family still separates properly.** `Daño perforante` runs 28..32
and `Daño fuerza` 31..35, so the top types stay harder than the bottom ones.
Only the six that overran are compressed against the ceiling, and they land one
point apart from each other rather than on top of each other.

### Where it changed

| File | Change |
|---|---|
| `cnr_i_arcane.nss` | `CNR_ARC_DC_CEILING = 35`, with the reason it is 35 |
| `cnr_i_arcane.nss` | `CnrArc_SqlStepCount()`, `CnrArc_SqlStepRank()`, `CnrArc_SqlEntryDC()` — the formula as SQL fragments, written once |
| `cnr_i_arcane.nss` | `CnrArc_ReadProperty` gains fields 13 and 14: the entry DC and the top DC |
| `cnr_i_arcane.nss` | `CnrArc_ReadStep` gains field 5: that step's DC |
| `cnr_i_arcane.nss` | `CnrArc_ListSteps` gains field 2: that step's DC |
| `cnr_i_apply.nss` | `iDC` comes from the step, not from the property |
| `cnr_arc_nui.nss` | The panel reads the step's DC, and the ladder's range until one is picked |
| `cnr_arc_nui.nss` | The odds say "elige el poder" instead of a percentage for a rung nobody chose |
| `cnr_arc_nui.nss` | The step dropdown reads `+3   -   3 esencias   -   DC 25` |

**The formula is computed in SQL, not in NWScript.** The plan called for a
`CnrArc_StepDC()` helper; one expression shared by both queries is stronger, and
the reason is the trap below. The window and the applier now derive the DC from
the *same* SQL text, so they cannot drift apart — it is not that they agree, it
is that there is only one of them.

**No schema change and no data change.** A `dc` column on `cnr_arcane_step`
filled by `migration/build_arcane.py` is the escape hatch if a property ever
needs a curve of its own; it is not worth 484 rows of arithmetic for a rule this
uniform.

### The trap

The odds shown in the window and the DC the applier rolls against are computed
in two different files. They agreed only because both read the same column.
Change one and not the other and the window prints a percentage the server will
not honour, which is worse than the bug being fixed.

### Verification

- `./linux_build-dev.sh --check cnr_arc_dist.nss cnr_arc_evt.nss cnr_arc_ou.nss`
  — the three executables that reach the changed includes, found by walking the
  include graph rather than guessed. 3 successful, 0 errored.
- At the time of this slice, the formula was run against the then-current 105
  properties and 442 steps, in SQLite, with `LEAST`/`GREATEST` translated to
  `MIN`/`MAX`: **no step above 35, no ladder with a jump other than +1, and all
  24 then-single-rung properties keeping the DC the design authored.** This is
  what caught the essences-versus-rung error.
- Still owed in game: read back `Tirada: X + Y = Z contra DC N` for Fuerza +1
  through +6 against the table above, and for `Daño fuerza` at its first and
  last rung to confirm 31 and 35. Confirm the window's percentage matches the
  DC the applier prints for the same selection.

---

## Slice 2 — Tier 3 gets one colour — **cancelled, nothing was wrong**

### What the plan claimed

That eighteen essences serve tier 3, that ten carry goldenrod and eight carry
the tier-2 royal blue, and that the eight were a copied line to be corrected.

### What the join actually says

The premise was wrong. There is no set of eighteen tier-3 essences to begin
with: ten belong to tier 3 alone and eight are shared with tier 2. The guardrail
written into this slice — *"the slice lists them explicitly rather than matching
on colour, so a blueprint shared with another tier cannot be caught by
accident"* — is what caught it.

**The eight are not *exclusively* tier-3 essences. They are shared, serving one
property of each tier:**

| Essence | Material | Tier 2 use | Tier 3 use |
|---|---|---|---|
| `cnr_esen63` | Pesuño de bestia de Málar | Cortante, immunity | Daño cortante |
| `cnr_esen64` | Colmillo de abishái | Perforante, immunity | Daño perforante |
| `cnr_esen65` | Vellosidad de alaghi | Contundente, immunity | Daño contundente |
| `cnr_esen66` | Espolón de dragónido | Fuego, immunity | Fuego, damage |
| `cnr_esen67` | Claridad de nyzh | Trueno, immunity | Trueno, damage |
| `cnr_esen68` | Hálito de dragón del canto | Relámpago, immunity | Relámpago, damage |
| `cnr_esen69` | Escama de asabi | Ácido, immunity | Ácido, damage |
| `cnr_esen70` | Gotas de ábalin | Frío, immunity | Frío, damage |

The same material either wards off a damage type or adds it, and the two uses
sit at different tiers. Recolouring them to goldenrod would have mislabelled
every one of them for its tier-2 use.

### What the data looks like once read properly

Of the 93 essences the arcane trade names, **85 serve exactly one tier and 8
serve two — always tier 2 and 3, never any other pair.** Grouping only the
tier-exclusive ones, every tier is unanimous:

| Tier | Exclusive essences | Colour | RGB |
|--:|--:|---|---|
| 1 | 54, unanimous | cyan | 1, 243, 243 |
| 2 | 13, unanimous | royal blue | 65, 105, 225 |
| 3 | 10, unanimous | goldenrod | 218, 165, 32 |
| 4 | 8, unanimous | magenta | 255, 1, 255 |

The eight shared ones carry the tier-2 colour, the lower of the two they serve.
That is a consistent rule, not a mistake.

### Why this does not block slice 4

Slice 4 colours the name by the tier of the **property** being applied, read
from `cnr_arcane_property.tier` — `sProperty` field 3, which the applier already
holds. It never reads a blueprint's name. The four colours above are
unambiguous, so `CnrArc_TierColor()` can be written from this table directly.

A piece enchanted with `Espolón de dragónido` therefore comes out blue when the
property chosen was fire immunity and goldenrod when it was fire damage, which
is the right answer: the colour marks what was made, not what was spent.

**No file was changed by this slice.**

---

## Slice 3 — `[Encantado]` on every enchanted piece — **done**

### What exists today

**Nothing renames the item.** `cnr_i_apply.nss` applies the property, sets
`CNR_ARC_VAR_DONE` and calls `SetIdentified`. There is no `SetName` and no
`SetDescription` anywhere in the arcane files.

### What this slice does

On a successful enchant, and nothing else:

```
<current name> <pink>[Encantado]</c>
```

The piece keeps the name it already has, whatever that is, and the description
it already has. The suffix is pink, always present, and can never be lost.

**No colour is stripped and none is added to the existing name.** A crafted
piece may arrive already coloured — 90 of the 513 recipes bake a `<c…>` into
`cnr_recipe.display_name`, and 673 of the 1146 components do, though a component
is not what gets enchanted — and appending a second, closed colour span after it
is valid. Two spans side by side, each closed, is exactly what the engine
expects.

The tier colour is **not** part of this slice. It only ever applies to a name
the player typed, which does not exist until slice 4.

### Where it changed

| File | Change |
|---|---|
| `cnr_i_apply.nss` | `CNR_ARC_MARK_TEXT` and the pink `255, 130, 190` |
| `cnr_i_apply.nss` | `CnrArcA_MarkName()`, which appends the marker |
| `cnr_i_apply.nss` | `SetName` right after a successful `CnrProp_Apply` |

**It went in `cnr_i_apply.nss`, not `cnr_i_arcane.nss` as planned.**
`cnr_i_arcane` is the query layer and does not include `colors_inc`, while the
applier reaches it through `cnr_i_craft` and is the only file that ever names an
item. Putting it there keeps the include chain as shallow as it was; slice 4's
`CnrArc_TierColor()` belongs beside it for the same reason.

**The name is set before the enchanted mark, not after.** A piece that somehow
failed to be stamped is then not left wearing a marker promising it was.

### What ColorArray does to the numbers

`ColorToken()` maps each channel through `ColorArray`, which is the identity
except for the six values that would break a NWScript string literal: 0, 10, 13,
34, 92 and 255 come out as 1, 11, 14, 35, 93 and 254.

So the pink is really `254, 130, 190` and tier 4's magenta will be `254, 1, 254`
rather than the `255, 1, 255` written into the blueprints. Imperceptible, and
the reason the two sets of numbers will not match if anyone diffs them.

### Verification

- `./linux_build-dev.sh --check cnr_arc_dist.nss cnr_arc_evt.nss cnr_arc_ou.nss`
  -> 3 successful, 0 errored.
- `SetName` confirmed against the installed `nwscript.nss` to accept an item,
  and to revert to the original name when passed `""` — which is why slice 4
  must not call it with an empty custom name.
- `ColorArray` read at byte level, not through a text decoder: it is the
  identity but for those six indices, and neither 130 nor 190 is among them.
- The resulting name simulated byte for byte on a plain recipe name and on a
  coloured one: colour spans stay balanced in both, two closed spans side by
  side in the second.

Still owed in game:

- Enchant a plain-named piece and a coloured one and read both back.
- Confirm the pink is legible beside tier 4's magenta, since a tier-4 piece will
  show both at once once slice 4 lands.
- **Measure what the engine does with a long name.** The suffix and its colour
  code add about twenty characters to a name that may already be long. Do not
  assume a limit; write a long one and read it back.

---

## Slice 4 — The window asks for a name and a description — **done**

### What exists today

The right column of the window is one read-only text box, in `CnrArcN_Open`:

```nwscript
// --- right column: the detail, read only ---------------------------------
json jRight = JsonArray();
jRight = JsonArrayInsert(jRight,
    NuiId(NuiText(NuiBind(CNR_ARCN_B_DETAIL)), "txt_detail"));
```

It is filled by `CnrArcN_DrawDetail`. The user's judgement is that it *"da
información que no vale para nada"*.

### What replaces it

- A label **Nombre** and a single-line `NuiTextEdit`.
- A label **Descripción** and a taller, multi-line `NuiTextEdit` below it.

### The two cases, and they are the whole rule

**The player typed a name.** The old name is thrown away and the name is built
from scratch:

```
<tier colour>NOMBRE</c> <pink>[Encantado]</c>
```

Nothing of the previous name survives, so nothing about its colour matters. The
tier is the tier of the essence used to enchant, `sProperty` field 3, which the
applier already holds.

**The player typed nothing.** The piece keeps the name it already has, plus the
suffix slice 3 gives it. Same for the description.

The two fields are independent: a name with no description, or a description
with no name, both work.

### The signature

Appended to the description, always, on its own final line:

```
Esta pieza ha sido imbuida por el Artesano Arcano: <character name>
```

`GetName(oPC)` at the moment of enchanting, so the piece records who made it
even if the character is renamed afterwards. It is appended **by the applier**,
never sent by the window, so it cannot be edited away or forged with another
character's name.

### The guardrails

The applier's own header states the doctrine: *"Nothing the window sent is
trusted. A NUI window is driven by the client, so a modified one can ask for +7
with no essences."* Two free-text strings are the same problem in a worse form,
because they land on an item other people read.

These are about **what the player types**, not about the name the piece arrives
with — that one is simply overwritten. All of them run in the applier:

| Guardrail | Why |
|---|---|
| Strip `<c…>` and `</c>` from both typed strings | Otherwise a player picks his own colour, or leaves an unbalanced tag that swallows the rest of the line — including the `[Encantado]` after it |
| Cap the length of each, and cap it again at the window | `NuiTextEdit`'s own limit is a client-side courtesy, not a check |
| Treat a name that is blank once trimmed as "typed nothing" | Falls into the second case above and keeps the current name |
| Strip newlines from the name | It is a one-line field, and a newline in an item name is not something to find out about in game |

### Where it changed

| File | Change |
|---|---|
| `cnr_arc_nui.nss` | Binds `item_name` and `item_desc`, and their caps |
| `cnr_arc_nui.nss` | The right column is now two labels and two `NuiTextEdit`s |
| `cnr_arc_nui.nss` | `CNR_ARCN_B_DETAIL` and the panel text are gone; `CnrArcN_DrawDetail` keeps the cost box, the odds and the button |
| `cnr_arc_nui.nss` | A fourth cost row, `gain`, carrying the experience and the tier |
| `cnr_arc_evt.nss` | Reads both binds raw, passes them on, clears them after a success |
| `cnr_arc_evt.nss` | The result line is set **after** the refresh, not before |
| `cnr_i_apply.nss` | `CnrArcA_Clean`, `CnrArcA_TierColor`, `CnrArcA_BuildName`, `CnrArcA_BuildDescription` |
| `cnr_i_apply.nss` | `CnrArcA_Attempt` takes the two strings, both defaulted to `""` |

**What the retired panel held, and where it went.** The step dropdown carries
the value and its DC, the property list flags a level out of reach, and the cost
box has the materials and the odds — so most of it was already said twice after
slice 1. The experience and the tier had nowhere else to go and became a fourth
line in the cost box. The loot hint, `ubicacion`, was dropped: nothing acted on
it.

**The result line moved after the refresh.** It used to be written before, and
the refresh that follows redraws the window from the new state — which, now that
a success clears the selection, would have wiped the one line the player most
wants to read.

### The guardrails, as built

`CnrArcA_Clean` runs in the applier on both strings:

| Rule | Effect |
|---|---|
| **The raw string is cut to four times the cap before a character is read** | The loop walks it one character at a time and the string came from a client. Unbounded, an oversized one burns the script's instruction budget and aborts the attempt part way through. Worst case is now 3600 iterations against any input, measured, where the budget is 131072 |
| **The loop stops once the output is full** | The two together are what bound it: a string of nothing but `<` produces no output, so a full-output test alone would still run forever |
| Every `<` and `>` removed | Not just well-formed colour codes. A code is `<c` plus three bytes and a `>`, and a half-written one swallows what follows — the marker included. Matching the shape would leave the malformed cases, so the character is what goes |
| **LF folded** to a space in the name, two in a row to one | CR cannot be folded: NWScript has no `\r` escape and the compiler emits the letter `r` for it, so writing it matched every lowercase r instead. See below |
| Trimmed both ends | A name of nothing but spaces has to read as no name, or the fallback never fires and the piece ends up blank |
| Truncated | 60 for the name, 900 for the description, capped again at the window |

**NWScript has no `\r` escape, and finding out cost a bug in the wild.** An
audit asked for carriage returns to be folded alongside line feeds, so `"\r"`
went into the comparison. The compiler does not know that escape and emits the
**letter `r`**, byte 114 — verified by compiling a probe and reading the
constant out of the `.ncs`. Every lowercase r in a typed name was therefore
folded into a space, and *Espada del bravo* reached the tester as *Espada del b
avo*, while `RRR` survived because the test is case sensitive.

`"\t"` is not an escape either, and emits `t`. `"\n"` is real, byte 10. This
was the only use of either in the project's NWScript, so nothing else was
affected.

CR is now simply not matched, and cannot be: the character has no literal in the
language. It is cosmetic where an unbalanced colour tag was not — a single-line
`NuiTextEdit` never produces one, and a modified client sending one buys itself
an odd-looking name and nothing more.

**Cleaned before the roll, not after the property.** Both strings are made safe
while nothing has been consumed and the attempt can still be abandoned for free.
They used to be cleaned between `CnrProp_Apply` and the enchanted mark, so an
abort there left the piece carrying its new property, its material spent, and no
mark — **which made it eligible to be enchanted a second time.** The bound above
closes the abort; doing the work early means nothing depends on that bound
holding.

The order is now: clean, roll, consume, award, apply, name, mark.

`SetName("")` is never called: the engine reads that as *revert to the
original*, which would undo the recipe's own name.

### Verification

- `./linux_build-dev.sh --check cnr_arc_dist.nss cnr_arc_evt.nss cnr_arc_ou.nss`
  -> 3 successful, 0 errored.
- `NuiTextEdit` and `NuiGetBind` taken from working code in this repository
  (`src/nui/0i_window.nss:490`, `src/cnr/nui/cnr_arc_evt.nss`), not from memory;
  `SetName` and `SetDescription` read from the installed `nwscript.nss`.
- **The cleaning was replayed in Python, rule for rule, against hostile input:**
  a name trying to colour itself, a half-open `<c`, an embedded LF, a name of
  nothing but spaces, one of 120 characters, and — after the escape bug — names
  full of lowercase and capital Rs. In every case the brackets are
  gone, the marker survives at the end, the blank name falls back to the
  recipe's, and the long one stops at 60.
- **The loop was measured against a megabyte** of `<`, `>`, spaces, letters and
  carriage returns, for both caps: **3600 iterations at worst**, against an
  instruction budget of 131072.
- `CnrArcA_Attempt` has exactly one caller, and it passes both strings.

Still owed in game, and none of it can be argued from the source:

- The window's layout, which is the whole point of the slice.
- The four tier colours and the pink beside them, tier 4 especially.
- What the engine does with a long name, and whether the description shows the
  signature where it should.
- Two different characters, to confirm the signature is not cached.
