# Use Magic Device For Scrolls And Wands

## Status And Scope

This document records the custom PDB Use Magic Device (UMD, named UOM in some
Spanish comments and messages) flow implemented by:

- `src/shared/nss/x2_pc_umdcheck.nss`
- `src/shared/nss/x2_inc_spellhook.nss`
- `src/shared/nss/x2_inc_switches.nss`
- `src/shared/nss/wrap_on_mod_load.nss`
- `src/shared/nss/pb_nivellanzador.nss`
- `haks-2da/spells.2da`

It describes audited behavior and a target correction. No correction has been
implemented or validated in game.

See [Caster-level model](caster-levels.md) for the shared caster-level defects
and proposed per-class API.

## Execution Path

Approximately 397 spell impact scripts call `X2PreSpellCastCode()`. That
function reaches `X2PreSpellCastCodeBase()`, which executes
`x2_pc_umdcheck` through `X2UseMagicDeviceCheck()` before the impact script is
allowed to continue.

The module load script sets `MODULE_SWITCH_ENABLE_UMD_SCROLLS` to `TRUE`.
However, the current custom `x2_pc_umdcheck.nss` does not read that switch.
Its own item filtering determines whether the check runs, so the switch is not
an effective runtime toggle for this implementation.

The check accepts the following base-item families:

- blank, enchanted, normal, and spell scrolls;
- blank, enchanted, and magic wands;
- magic rods;
- magic staves.

Other item types and casts without a valid `GetSpellCastItem()` return `TRUE`
without a UMD check.

[`GetSpellCastItem()`](https://nwnlexicon.com/Spell_Script) is valid in the
active item spell context. [`GetCasterLevel()`](https://nwnlexicon.com/GetCasterLevel)
would return the item's caster level in this context, not the character's
effective caster level. It must not be substituted directly for a character
eligibility calculation.

## Current Decision State

The script tracks three independent requirements:

| Flag | Meaning |
|------|---------|
| `iEmularClase` | The character lacks access through a recognized spell list |
| `iEmularNLanzador` | A recognized class does not meet the calculated minimum caster level |
| `iEmularCaracteri` | The character does not meet the casting ability requirement |

For scrolls, all three flags must be cleared to avoid a roll. If checks remain,
the script may roll to emulate the class, caster level, and casting ability.

For wands, rods, and staves, the current intended policy explicitly clears the
caster-level and ability flags. A recognized wand can therefore request only
an `emulate class` roll. It cannot request an `emulate caster level` roll.

Consequences for diagnosis:

- If a wand reports `emular clase`, its spell was not recognized on any
  supported spell list owned by the character.
- If an alleged wand reports `emular nivel de lanzador`, its runtime base item
  did not enter the wand, rod, or staff branch. Capture its resref, base item
  type, spell ID, and exact message before changing rules.

## Confirmed Mystic Theurge Defect

The scroll calculation is inconsistent with the shared caster-level code:

- Cleric and Favored Soul add Mystic Theurge progression.
- Wizard and Sorcerer do not add Mystic Theurge progression.
- Druid does not add Mystic Theurge progression.

Example:

```text
Character: Wizard 3 / Cleric 3 / Mystic Theurge 10
Expected arcane caster level: 13
Arcane caster level seen by x2_pc_umdcheck: 3
```

For an arcane level-3 scroll, the script can compare the minimum level 5
against 3 and request an unnecessary caster-level roll. The divine Cleric
path sees 13 because that branch explicitly adds Mystic Theurge.

`GetTotalCasterLevel()` already adds Mystic Theurge to Wizard, Sorcerer,
Cleric, and Druid. The UMD script duplicates an older class mapping and has
drifted from it.

## Other Confirmed Defects

### `Innate` Is Used As The Class Spell Level

The script reads the `Innate` column from `spells.2da` and uses it to derive
minimum caster level for every candidate class. `Innate` is not necessarily
the level at which a particular class receives the spell.

The current local `spells.2da` contains different `Innate` and class-list
values for at least:

| Spell list | Differing rows |
|------------|---------------:|
| Wizard/Sorcerer | 22 |
| Cleric | 15 |
| Druid | 24 |
| Bard | 9 |

Examples include:

- `Identify`: Wizard 1, Bard 1, `Innate` 2.
- `Find Traps`: Cleric 2, `Innate` 3.
- `Ultravision`: Druid 1, `Innate` 2.

These entries can make the script require a higher caster level than the
class progression requires. Other mismatches make it too permissive.

[`GetSpellLevelByClass()`](https://nwnlexicon.com/GetSpellLevelByClass) should
replace manual normal-list lookups. It is supported by build 8193.37, resolves
master/subspell relationships, and returns `-1` when the class lacks the
spell. Domain spells remain an explicit exception.

### Arcane Candidate Selection Uses Boolean Expressions

The current comparisons contain expressions equivalent to:

```nwscript
iSorcererLevel > (iWizardLevel && iEngineerLevel)
iEngineerLevel > (iWizardLevel && iSorcererLevel)
```

Logical `&&` produces `TRUE` or `FALSE`, not the greatest of two levels. A
Wizard 10 / Sorcerer 2 can therefore select Sorcerer 2 because it compares 2
against zero or one. The selected class then controls the progression table,
caster-level comparison, and roll bonus.

### Independent Flags Can Mix Different Casting Paths

Class access, ability score, and caster level are global flags. One class can
clear class access, another ability score can clear the ability requirement,
and a third class can provide the selected caster level. A valid casting path
must instead satisfy all requirements as one atomic candidate.

### Divine Base Classes Are Added Together

The divine branch initially adds Cleric and Favored Soul levels together, then
adds prestige progression. Those are separate caster tracks. The correct
behavior is to evaluate each base class independently and accept the best
complete eligible path, not sum both base classes.

### Rules Are Duplicated

Assassin, Blackguard, Soldier of Light, Paladin variants, Bard, divine, and
arcane logic each maintain their own spell lists, ability checks, minimum
levels, and prestige additions. This duplicates information already present
in `classes.2da`, `spells.2da`, and `pb_nivellanzador.nss`, making future drift
likely.

## Target Eligibility Flow

The correction should preserve the current UMD roll and failure rules while
replacing only eligibility calculation:

```text
Resolve item category and active spell
    -> resolve master spell when applicable
    -> enumerate character casting-class candidates
    -> obtain the spell-list level for each candidate
    -> apply the explicit domain exception
    -> obtain effective caster level for that same candidate
    -> check that candidate's casting ability
    -> accept immediately when one complete candidate qualifies
    -> otherwise select the closest failed candidate for the permitted UMD roll
```

Candidate evaluation must keep these fields together:

```text
base class
spell-list level
minimum class level or item caster-level requirement
effective caster level
casting ability and required score
arcane or divine classification
```

For the existing wand policy:

1. Resolve whether at least one character class receives the spell.
2. If it does, allow the cast without caster-level or ability checks.
3. If it does not, perform only the existing emulate-class roll.

For scrolls:

1. Evaluate every eligible class independently.
2. Allow the cast when one candidate satisfies class, caster level, and
   casting ability.
3. Never combine partial success from multiple classes.
4. If none qualifies, choose the candidate with the smallest real deficit and
   apply the existing UMD path.

## Ruleset Decisions Required

- Should scroll qualification compare character caster level with the minimum
  class level needed to learn the spell, or with the caster level stored on the
  actual scroll?
- Which caster-level modifiers count for item qualification: prestige
  progression, Practiced Spellcaster, Archmage Spell Power, temporary effects,
  or none?
- Are rods and magic staves intentionally governed by the same permissive rule
  as wands?
- Should Favored Soul always use the Cleric spell list and Charisma for UMD?
- Which arcane and divine tracks does Mystic Theurge advance when more than one
  of either type exists?
- Should the module switch become an actual UMD on/off control again?

These decisions affect game balance and must be explicit before changing the
roll DCs or eligible item families.

## Manual Validation Matrix

At minimum, validate the following characters with scrolls and wands whose
spell IDs and list levels are known:

| Character | Item case | Expected focus |
|-----------|-----------|----------------|
| Wizard 3 / Cleric 3 / Mystic Theurge 10 | Arcane scroll levels 1, 3, 6, and 7 | Mystic Theurge advances the Wizard track exactly once |
| Wizard 3 / Cleric 3 / Mystic Theurge 10 | Divine scroll levels 1, 3, 6, and 7 | Mystic Theurge advances the Cleric track exactly once |
| Wizard / Druid / Mystic Theurge | Druid and Wizard scrolls | Both selected tracks receive intended progression |
| Wizard 10 / Sorcerer 2 | Shared and class-specific scrolls | Highest valid complete candidate is selected |
| Cleric / Favored Soul | Cleric-list scroll | Base class levels are not summed |
| Wizard 1 or Bard 1 | `Identify` scroll | Class level 1 is used instead of `Innate` 2 |
| Cleric 3 | `Find Traps` scroll | Cleric level 2 is used instead of `Innate` 3 |
| Any eligible caster | Recognized wand | No caster-level or ability roll under the current policy |
| Non-caster with trained UMD | Scroll and wand | Existing emulate-class DC and failure behavior remain intact |
| Unsupported item base type | Item spell | UMD check is bypassed as currently designed |

For every failure, capture character classes, effective levels, spell ID,
master spell ID, item resref, base item type, selected candidate class, and the
exact UMD message. Do not infer the failed requirement only from the item name.
