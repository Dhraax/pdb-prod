# Caster-Level Model

## Status And Scope

This document records the caster-level behavior found in the current PDB
source. It is an architecture baseline, not confirmation that the behavior is
correct and not authorization to change the ruleset.

The audited implementation is primarily in:

- `src/shared/nss/pb_nivellanzador.nss`
- `src/shared/nss/cwa_enforcer.nss`
- `src/shared/nss/pjr_on_chat.nss`
- `haks-2da/classes.2da`
- `haks-2da/spells.2da`

The current server image is `nwnxee/unified:build8193.37`.

In existing player-facing text, `ECL` is used to mean effective caster level.
It must not be confused with the D&D meaning of Effective Character Level,
which includes racial adjustment and total character levels. The current
caster-level code does not inspect race and cannot calculate that value.

## Concepts That Must Remain Separate

| Concept | Meaning |
|---------|---------|
| Base class level | Levels returned by `GetLevelByClass()` for one class |
| Effective caster level | The caster level for one selected casting class after its valid prestige progression and permitted modifiers |
| Current cast caster level | The engine value attached to the active spell, ability, area of effect, or item cast |
| Spell-list level | The spell level at which one class receives one spell |
| Maximum spell level | The highest spell level unlocked by the class progression, independent of caster-level bonuses unless a PDB rule explicitly says otherwise |

Never add unrelated base casting classes together to create one caster level.
A Wizard/Cleric has two caster-level tracks, not a combined track. A prestige
class may advance one or more tracks only according to an explicit PDB rule.

## Native Engine Contracts

- [`GetLevelByClass()`](https://nwnlexicon.com/GetLevelByClass) returns the
  creature's level in one class, or zero when the creature lacks that class.
- [`GetCasterLevel()`](https://nwnlexicon.com/GetCasterLevel) is
  context-sensitive. In a spell script it returns the level of the current
  spell or ability; during an item cast it returns the item's caster level. It
  must not be used as a stable character-sheet caster-level query.
- [`GetLastSpellCastClass()`](https://www.nwnlexicon.com/GetLastSpellCastClass)
  is meaningful in the current spell or area-of-effect context. It is not a
  persistent declaration of the class a prestige class advances.
- [`GetSpellFeatId()`](https://nwnlexicon.com/GetSpellFeatId) distinguishes a
  feat-backed spell invocation when the current spell context provides one.
- [`GetSpellLevelByClass()`](https://nwnlexicon.com/GetSpellLevelByClass) is
  available in the current server version. It returns the class-specific spell
  level, returns `-1` when the class does not receive the spell, and resolves a
  subspell through its `Master` entry. It does not resolve cleric domain access.
- [`GetDomain()`](https://nwnlexicon.com/GetDomain) can be used for the domain
  exception after normal class-list lookup fails.

`haks-2da/classes.2da` and `haks-2da/spells.2da` are the local ruleset sources.
Generic documentation must not override their custom class and spell data.

## Current Public Functions

### `GetSpecialCasterLevel()`

This function converts prestige or custom class levels into caster-level
progression. Examples include full progression for Mystic Theurge and partial
progression for Pale Master, Eldritch Knight, and Harper variants.

The function answers only how many levels a class contributes. It does not
identify which base casting class receives that contribution. Callers
currently make that decision independently, which has allowed them to drift.

### `GetTotalCasterLevel()`

This is the main per-class calculation and is used by more than 300 script
files. It selects a base class from an explicit argument, a feat-backed custom
cast, or `GetLastSpellCastClass()`, then adds configured prestige progression
and selected bonuses.

Known risks:

- Prestige progression is added to every compatible base class found on the
  creature. The character data does not record which base class a prestige
  class advanced.
- Druid handling adds Mystic Theurge but not Blighter, while other scripts
  treat Blighter as Druid progression.
- Orcus progression is interpreted inconsistently: this function adds every
  Orcus level, while other code uses `GetSpecialCasterLevel()` and
  `classes.2da` contains a separate divine progression modifier.
- Archmage Spell Power is calculated before base-class selection and is added
  even to divine results.
- Practiced Spellcaster is treated as a generic feat for every casting class.
  It is capped against Hit Dice before later bonuses are added.
- The default branch calls `GetCasterLevel()`. Outside an active spell or
  area-of-effect context, that value may describe the previous cast or return
  zero rather than the requested character progression.
- Item casts deliberately skip several character bonuses because
  `GetSpellCastItem()` is valid. Any future eligibility check must state
  whether that is the intended game rule.

Because of its call surface, this function must not be broadly rewritten
without compatibility checks for spell duration, damage scaling, dispelling,
summons, item properties, and persisted values.

### `GetCL()`

`GetCL()` attempts to return one character-wide number. That abstraction is
invalid for a multiclass caster and its implementation contains direct defects:

- Favored Soul, Warlock, and Engineer levels are added twice.
- Prestige contributions are added once for every compatible base class in the
  three class slots. A Wizard 10 / Sorcerer 5 / Archmage 5 can therefore return
  25 instead of a per-class result.
- Mystic Theurge can be counted repeatedly when multiple compatible base
  classes are present.
- Paladin variants, Ranger, Assassin, Blackguard, Soldier of Light, and other
  caster classes are missing.
- A pure supported caster omitted by the function can be reported as caster
  level zero.

The `!ecl` chat command prints this value, but `GetCL()` also participates in
gameplay gates such as spell learning, golem logic, and module activation.
It must therefore be treated as defective gameplay code, not merely an
outdated debug display.

### `GetCasterMaxSpellLevel()` And `GetCasterCanCast()`

`GetCasterMaxSpellLevel()` derives spell access from effective caster level.
This conflates caster strength with class spell progression and contains known
edge cases:

- Sorcerer level 1 produces maximum spell level 0.
- Bard level 20 produces level 7 even though the progression ends at level 6.
- Engineer has an empty branch and falls through to the default maximum of 9.
- Favored Soul is absent and also receives the default maximum of 9.
- An invalid or unsupported class fails open with maximum spell level 9.
- Caster-level feats and bonuses can unlock higher spell levels.
- The Blighter adjustment can reduce Druid spell access unexpectedly.

`GetCasterCanCast()` is active in `cwa_enforcer`, the module override spell
script configured by `module.ifo.json`. It inherits the maximum-level defects
and manually reads class columns from `spells.2da`. This makes the issue active
gameplay behavior rather than unused utility code.

## Target Architecture

The replacement model should expose separate, documented operations:

```text
GetEffectiveCasterLevelByClass(creature, baseClass, modifierPolicy)
GetCurrentSpellCasterLevel(caster)
GetSpellLevelForClass(baseClass, spellId)
GetMaximumSpellLevelByClass(creature, baseClass)
```

The contracts should be:

1. `GetEffectiveCasterLevelByClass()` is stable outside a spell event and
   returns one class track only.
2. `GetCurrentSpellCasterLevel()` wraps the native context-sensitive value and
   is used only while a spell, item cast, or area of effect is active.
3. `GetSpellLevelForClass()` uses `GetSpellLevelByClass()` and applies the
   explicit domain exception.
4. `GetMaximumSpellLevelByClass()` reads actual class progression. Caster-level
   bonuses do not unlock spell slots unless a documented PDB rule permits it.
5. The `!ecl` command reports a labelled result for every casting class rather
   than summing incompatible progressions.

Prestige progression should be represented centrally as data or one mapping
function. UMD, spell effects, dispel checks, spell eligibility, and chat output
must consume that same mapping instead of maintaining separate class lists.

## Decisions Required Before Refactoring

- Which base class receives each ambiguous prestige progression on a
  multiclass character?
- Does Mystic Theurge advance exactly one arcane and one divine track, and how
  are those tracks selected when several are eligible?
- Does Orcus grant full, half, or `classes.2da`-defined divine progression?
- Does Blighter replace or add to Druid progression?
- Is Practiced Spellcaster selected per class or global in PDB?
- Does Archmage Spell Power apply only to the advanced arcane class?
- Which character caster-level modifiers count when qualifying to use an item?

These are ruleset decisions. They must be settled before implementation rather
than inferred from the current contradictory code.

## Incremental Migration

1. Add focused per-class query functions without removing legacy entry points.
2. Build a table of base classes, spell-list columns, casting abilities,
   progression tables, and compatible prestige classes.
3. Correct `!ecl` to display per-class diagnostics and use it during manual
   verification.
4. Move UMD eligibility to the new per-class query without changing its DC or
   failure rules.
5. Move `GetCasterCanCast()` to actual class progression.
6. Migrate high-risk `GetTotalCasterLevel()` callers by subsystem.
7. Retire `GetCL()` only after all gameplay callers have been replaced.

Compilation, module packaging, and in-game verification are required for every
migration slice. Static inspection alone cannot establish the engine's runtime
spell context.
