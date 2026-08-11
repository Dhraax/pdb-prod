# Spell Saving Throws

Status: pending review. None of the changes described here are currently
implemented.

## Scope

Perform a repository-wide review of spell saving throws, including
`DoMissileStorm`, direct spell impact scripts, persistent areas, secondary
scripts, and delayed effects. Damage types and saving throw types must be
treated as separate concepts.

## Current behavior

`DoMissileStorm` accepts a damage type and a Boolean that enables a Reflex
save. When the save is enabled, it currently selects the saving throw subtype
from the damage type using only two branches:

- `DAMAGE_TYPE_MAGICAL` selects `SAVING_THROW_TYPE_SPELL`.
- Every other damage type selects `SAVING_THROW_TYPE_FIRE`.

This produces the following results:

| Spell | Current damage input | Current Reflex behavior |
|-------|----------------------|-------------------------|
| Isaac's Lesser Missile Storm | `DAMAGE_TYPE_FUERZA` | Enabled, but classified as fire by `DoMissileStorm` |
| Isaac's Greater Missile Storm | `DAMAGE_TYPE_FUERZA` | Enabled, but classified as fire by `DoMissileStorm` |
| Firebrand | Result of `ChangedElementalDamage(..., DAMAGE_TYPE_FIRE)` | Enabled; every non-magical result is classified as fire |
| Ball Lightning | Result of `ChangedElementalDamage(..., DAMAGE_TYPE_ELECTRICAL)` | Disabled because the optional Reflex argument is omitted |

The four spells above run directly as `ImpactScript` entries with `UserType` 1
in `spells.2da`. In this context, the engine automatically adds the spell save
classification on top of the selected elemental subtype. Spellcraft and other
save-versus-spell modifiers therefore apply even when the visible subtype is
fire or electricity.

Incendiary Cloud is different. Its initial `ImpactScript` creates a persistent
area, and `NW_S0_IncCloudA` later runs from `vfx_persistent.2da` as the area's
`OnEnter` script. Passing `GetAreaOfEffectCreator()` identifies the source but
does not restore the original spell-script context. Its current fire save does
not automatically receive Spellcraft or other save-versus-spell modifiers.

## User-observed affected spells

The following spells have been observed in game to perform saving throws
without adding the expected Spellcraft save bonus:

- Grease (`NW_S0_GreaseA` and `NW_S0_GreaseC`).
- Web (`NW_S0_WebA` and `NW_S0_WebC`).
- Delayed Blast Fireball (`NW_S0_DelFireA`).
- Incendiary Cloud (`NW_S0_IncCloudA` and `NW_S0_IncCloudC`).
- Acid Fog (`NW_S0_AcidFogA` and `NW_S0_AcidFogC`).
- Combust (`X2_S0_Combust`, including delayed `RunCombustImpact` calls).

This is evidence of a general execution-context problem rather than an issue
limited to Incendiary Cloud. The list is not assumed to be exhaustive.

The future review must cross-reference every saving throw call with its actual
execution context. At minimum, it must cover:

- `OnEnter`, `OnHeartbeat`, and `OnExit` scripts referenced by
  `vfx_persistent.2da`.
- Saving throws inside functions scheduled with `DelayCommand` after the
  original spell impact has completed.
- Secondary scripts invoked with `ExecuteScript` or equivalent mechanisms.
- Any spell effect whose saving throw occurs after the initial `ImpactScript`.
- Direct `ReflexSave`, `FortitudeSave`, `WillSave`, `MySavingThrow`, and
  `GetReflexAdjustedDamage` calls.

## Damage names

The project defines these custom damage aliases in `pb_constantes.nss`:

- `DAMAGE_TYPE_FUERZA` maps to `DAMAGE_TYPE_CUSTOM2` and is displayed as
  `Fuerza`.
- `DAMAGE_TYPE_VENENO` maps to `DAMAGE_TYPE_CUSTOM3` and is displayed as
  `Veneno`.
- `DAMAGE_TYPE_PSIQUICO` maps to `DAMAGE_TYPE_CUSTOM4` and is displayed as
  `Psiquico`.

The standard NWScript name `DAMAGE_TYPE_ELECTRICAL` is displayed as
`Relampago`, and `DAMAGE_TYPE_SONIC` is displayed as `Trueno`. The corresponding
standard saving throw constants remain `SAVING_THROW_TYPE_ELECTRICITY` and
`SAVING_THROW_TYPE_SONIC`. No custom Force saving throw type currently exists.

## Proposed changes for later review

1. Separate the saving throw subtype from `nDAMAGETYPE` in `DoMissileStorm`.
2. Keep the two Isaac's missile storms as Force damage and classify their
   required Reflex saves as spell saves rather than fire saves.
3. Enable the required Reflex save for Ball Lightning.
4. Select the elemental saving throw subtype from the actual result returned by
   `ChangedElementalDamage`, so Elemental Mastery cannot leave a mismatched fire
   save on electrical, cold, acid, or sonic damage.
5. Audit all persistent, secondary, and delayed spell saves, starting with the
   six user-observed spells above. Do not limit the correction to Incendiary
   Cloud.
6. Decide how persistent and delayed spell effects should combine their
   original save subtype with save-versus-spell modifiers:
   - Using `SAVING_THROW_TYPE_SPELL` is the supported simple correction for
     Spellcraft and save-versus-spell modifiers, but it drops fire-specific save
     modifiers when the original subtype was fire. The same tradeoff applies to
     acid, electricity, cold, sonic, and other subtypes.
   - Exactly reproducing a direct spell save requires a separately reviewed
     solution that combines spell and subtype modifiers outside an
     `ImpactScript`. A single standard saving throw call cannot request both
     types.
7. Review whether `DoMissileStorm` should include the project's
   `GetChangesToSaveDC()` adjustment. Fireball currently includes it, while the
   shared missile-storm helper currently uses only `GetSpellSaveDC()`. This is a
   caster DC concern and is separate from the defender's Spellcraft bonus.

## Required validation

- Compare a target immediately below and above a five-point modified
  Spellcraft threshold while keeping its Reflex save unchanged.
- Confirm Firebrand reports a fire save and gains the expected Spellcraft bonus.
- Confirm Ball Lightning reports an electricity save, performs half-damage and
  Evasion processing, and gains the expected Spellcraft bonus.
- Confirm both Isaac's missile storms apply Force damage, require Reflex saves,
  and do not apply fire-specific save modifiers.
- Test Incendiary Cloud separately because its save runs from a persistent-area
  event rather than a spell `ImpactScript`.
- Reproduce and verify Grease, Web, Delayed Blast Fireball, Acid Fog, and every
  delayed Combust save using the same controlled Spellcraft thresholds.
- Produce a complete inventory of affected scripts before implementing fixes,
  so equivalent execution paths receive the same treatment.

## References

- [NWN Lexicon: saving throw types](https://nwnlexicon.com/SAVING_THROW_TYPE)
- [NWN Lexicon: GetReflexAdjustedDamage](https://nwnlexicon.com/GetReflexAdjustedDamage)
- [NWN Wiki: saving throws](https://nwn.fandom.com/wiki/Saving_throw)
