# Archmage Arcane Fire

Status: pending review. None of the changes described here are currently
implemented.

## Scope

Arcane Fire (feat 1431 `FEAT_ARCANE_FIRE`, spell 1322) is implemented as a
two-stage module spell hook. This document records its current behavior and the
defects found while auditing it. Item 1 can disable the module-wide spell hook
for every player and should be triaged first.

Audited files:

- `src/shared/nss/spl_arcane_fire.nss` — activation, `ImpactScript` of spell 1322
- `src/shared/nss/archmage_fire.nss` — the intercepting hook
- `src/shared/nss/archmage_spelllk.nss` — Spell-Like Ability, same pattern
- `src/shared/nss/x2_inc_switches.nss` — hook plumbing
- `src/shared/nss/q_mod_def_load.nss` — default hook assignment

## Current Behavior

Activation (`spl_arcane_fire.nss`) casts nothing. It:

1. Sets `arcane_fire_active` to 1 on the caster.
2. Copies the current module override spellscript into the module string
   `archmage_save_overridespellscript`.
3. Replaces the module override spellscript with `archmage_fire`.
4. Stores the selected target in the local object `arcane_fire_target`.

The next spell cast then runs `archmage_fire` instead of its own script. That
script blocks the original spell, restores the previous hook, clears
`arcane_fire_active`, validates that the spell is a memorized wizard or
sorcerer spell, makes a ranged touch attack against the stored target, and
applies `d6(Archmage level + spell level)` magical damage.

The default module override spellscript is `q_spellhook`
(`q_mod_def_load.nss:158`), which implements spell components and other custom
rules.

## Defects

### 1. The hook is module-wide, so any player can trigger and break it

`SetModuleOverrideSpellscript()` stores its value on the module object
(`x2_inc_switches.nss:461`), not on the caster. While an Archmage has Arcane
Fire armed:

- `q_spellhook` is disabled for every player in the module.
- The next spell cast by **any** player runs `archmage_fire` in that player's
  context. `SetModuleOverrideSpellScriptFinished()` is called at
  `archmage_fire.nss:41`, before the `FEAT_ARCANE_FIRE` check at `:47`, so a
  character without the feat loses the spell entirely: the slot is spent, no
  effect is produced and no message is shown.
- `arcane_fire_active` is cleared on that other player, not on the Archmage,
  who stays flagged as armed and cannot re-arm until rest or relog.

### 2. Concurrent activations permanently destroy the saved hook

`archmage_save_overridespellscript` is a single module-wide string, written
only by `spl_arcane_fire.nss:18`. With two Archmages:

| Step | `archmage_save_overridespellscript` | Module override spellscript |
|------|-------------------------------------|-----------------------------|
| Initial | — | `q_spellhook` |
| Archmage A arms | `q_spellhook` | `archmage_fire` |
| Archmage B arms | `archmage_fire` | `archmage_fire` |
| Any spell is cast | `archmage_fire` | `archmage_fire` |

From that point every restore re-installs `archmage_fire`. `q_spellhook` is
never recovered and every spell cast by every player is intercepted, until the
module is reloaded.

`archmage_spelllk.nss` uses the same pattern with its own saved slot
`spelllike_save_overridespellscript`. Both systems compete for the same module
variable and can clobber each other in the same way.

### 3. State resets do not restore the hook

`hc_on_play_rest.nss:437` and `wrap_on_clnt_ent.nss:272` clear
`arcane_fire_active` on rest and on client enter. Neither restores the module
override spellscript. An Archmage who logs out while armed leaves the module
hooked.

### 4. Damage uses the Archmage class level, not the caster level

`archmage_fire.nss:15`:

```nwscript
int nCasterLvl = GetLevelByClass(53, OBJECT_SELF);   // CLASS_TYPE_ARCHMAGE
```

Spell Power feats add up to 5 more, then damage is
`d6(nCasterLvl + spell level)`. The Archmage prestige class contributes at most
5 levels, so a Wizard 25 / Archmage 5 with Spell Power V casting a 9th level
spell rolls 19d6. Every comparable script in the repository uses
`GetTotalCasterLevel()`.

Decision required: confirm whether restricting the dice to prestige levels is
the intended balance or a defect.

### 5. Consumed spell with no effect in several paths

The spell slot is spent by the engine before `archmage_fire` runs, and the
script blocks the original spell unconditionally at `:41`. The spell is
therefore lost with no compensation when:

- the target is friendly (`:66`, the whole damage block is skipped);
- the stored target is no longer valid;
- the spell is not a wizard or sorcerer spell, or was cast from an item;
- the caster does not have the feat, per defect 1.

### 6. Minor issues

- The ranged touch attack critical result is discarded. `TouchAttackRanged()`
  returns 2 on a critical hit and the script only tests for truthiness, so a
  critical deals normal damage.
- `nMetaMagic` is read at `:18` and never used. Empower and Maximize do not
  affect Arcane Fire.
- `fDist` is computed at `:27` and never used.
- No spell resistance check and no saving throw are applied.
- The target is captured at activation and never revalidated for distance,
  line of sight, or validity.
- The 18 second expiry is commented out (`spl_arcane_fire.nss:15`), so an
  activation stays armed indefinitely.

## Suggested Direction

To be confirmed before implementation:

1. Move the armed state and the saved hook name from the module to the caster,
   or gate `archmage_fire` on `GetLocalInt(OBJECT_SELF, "arcane_fire_active")`
   before calling `SetModuleOverrideSpellScriptFinished()`, so a character who
   did not arm the ability never loses a spell.
2. Never store the current hook when it already equals `archmage_fire`; restore
   the module default instead.
3. Restore the module override spellscript in the rest and client-enter
   cleanups, and on a timeout.
4. Decide the intended caster level source for the damage dice.

## Validation Required Before Implementation

- Two Archmages arming Arcane Fire in the same session, verifying that
  `q_spellhook` is still installed afterwards.
- A non-Archmage casting a spell while an Archmage is armed, verifying the
  spell resolves normally.
- Logout and rest while armed, verifying the module hook is restored.
- Spell component consumption from `q_spellhook` still working after several
  Arcane Fire cycles.
