# Warlock Errata

Status: pending review. None of the changes described here are currently
implemented.

## Scope

This document lists differences between the published Warlock class rules and
the behavior implemented in `src/shared/nss/war_*.nss`, plus implementation
defects found during the same review. The implemented behavior is described in
[Warlock invocation model](../nwscript/warlock.md).

Each item states the published rule, the implemented behavior with its
evidence, and the decision required. No item should be implemented before the
intended rule is confirmed, because several of them change live class balance.

## Published Rule Versus Implementation

### 1. Dark Wall of Fire damage does not match the published 8d6

Published rule: "causing 8d6 but half of the wall damage comes from the
supernatural power (magical damage)".

Implemented (`war_wallfirea.nss:82-83` on entry, `:24-25` per tick):

```
Entry:  2d6 + (Warlock level / 2) fire  +  2d6 + (Warlock level / 2) magical
Tick:   1d6 + (Warlock level / 2) fire  +  1d6 + (Warlock level / 2) magical
```

| Warlock level | Entry average | Per-round average | Published average |
|---------------|---------------|-------------------|-------------------|
| 12 | 26 | 19 | 28 |
| 16 | 30 | 23 | 28 |

The 8d6 value appears nowhere in the script. The entry only reaches the
published average from roughly level 14; the sustained damage never reaches it.
For comparison, the generic Wall of Fire (`nw_s0_wallfirea.nss:20`, `:80`)
applies `4d6 + caster level` on entry and on every tick.

Decision required: is the published 8d6 the intended value, is the current
level-scaling formula the intended value, or should the tick be raised to match
the entry dice?

### 2. Hellrime Blast applies -4 Dexterity, not -2

Published rule: "-2 Dexterity / Reflex during 10 turns".

Implemented (`war_utilities.nss:371`): `EffectAbilityDecrease(ABILITY_DEXTERITY, 4)`
with a **Fortitude** save, not Reflex.

Two separate mismatches: the magnitude and the saving throw category.

Decision required: correct the script, or correct the published text.

### 3. Essence replaces the invocation DC instead of capping it

`GetWarlockSpellDC()` (`war_utilities.nss:173-181`) replaces the default
`Innate + 1` bonus with a fixed per-essence value for spells 1335, 1337, 1344,
1346, 1347 and for Hideous Blow:

| Essence | Bonus | Effect on Eldritch Cone (default 7) | Effect on Eldritch Doom (default 9) |
|---------|-------|-------------------------------------|-------------------------------------|
| Brimstone / Hellrime | 5 | **-2 DC** | **-4 DC** |
| Caustic / Repelling | 7 | no change | -2 DC |
| Utterdark | 9 | +2 DC | no change |

A player who activates a lesser-tier essence therefore weakens their
higher-tier shapes. `war_area.nss:108-112` already works around this by passing
`bIgnorarEsencia = TRUE` for its Reflex damage save, which suggests the
replacement was not intended as a downgrade.

Decision required: should the essence value act as a floor
(`max(Innate + 1, essence value)`) rather than a replacement?

### 4. Devour Magic and Voracious Dispelling are nearly identical below level 20

Published rules present Devour Magic as the stronger effect, and it costs a
greater invocation slot while Voracious Dispelling costs a lesser one.

Implemented:

| | Voracious Dispelling (`war_disipar.nss`) | Devour Magic (`war_devorar.nss`) |
|---|---|---|
| Tier | Lesser | Greater |
| Dispel level cap | 15 (`:48`) | 20 (`:62`) |
| Effective check at Warlock 16 | 15 | 16 |
| Extra effect | `EffectDamage(caster level, DAMAGE_TYPE_MAGICAL)` | `EffectTemporaryHitpoints(caster level)` for 60s |
| Dispel routine | `pbDispelMagic` | `pbDispelMagic`, identical arguments |

At the practical level ceiling the greater invocation buys `+1` on the dispel
check. The published Devour Magic text also says the temporary hit points are
granted "per dispelled target"; the script applies one
`EffectTemporaryHitpoints` per target that carried magic, and multiple
temporary hit point effects do not accumulate.

Decision required: differentiate the two invocations, or move Devour Magic to
the lesser tier.

### 5. Voracious Dispelling damage ignores its own caster-level cap

`war_disipar.nss:43` builds the damage effect from `nCasterLevel` **before**
the clamp at `:48` reduces it to 15. The dispel check is capped at 15 while the
damage keeps the uncapped caster level.

Decision required: confirm whether the damage was meant to be capped as well.

### 6. Path of Shadow does not restore hit points

Published rule: "as Greater Teleport, without failure chance, and it restores
half of your hit points when travelling".

`war_teleport.nss` sets `TELEPORTAR`, `NIVEL_LANZADOR_TELEPORTAR` and
`RUTASOMBRAS`, then opens the `conj_teleport` conversation. No healing occurs
in this script.

Decision required: confirm whether the healing exists in the `conj_teleport`
conversation or its destination script. If it does not, the effect is missing.

### 7. Walk Unseen duration is level-based, not 24 hours

Published rule: "the invoker becomes invisible for 24h".

Implemented (`war_invi.nss:68`): `HoursToSeconds(GetTotalCasterLevel())`,
doubled at `:63` when the caster has feat 1357 (Insidious Magic). A Warlock 16
gets 16 hours, or 32 with the feat.

Decision required: align the text or the script. The same applies to
Darkness / Aliento de la noche (`war_niebla.nss:53`), whose in-file comment
states "1 turn per level" while the code applies hours per level.

### 8. Retributive Invisibility concealment outlives its invisibility

`war_invisiblem.nss:161-162` applies the 50% concealment and the invisibility
as two independent effects with the same duration. Breaking invisibility by
attacking removes only the invisibility; the concealment continues for the full
`TurnsToSeconds(caster level)`.

The detonation at `:64` and `:105` fires only once per cast and only while the
6-second polling chain is alive. If invisibility is never lost, the explosion
never triggers.

Decision required: confirm that persistent concealment after the first attack
is intended, since it converts a stealth invocation into a sustained defensive
buff.

## Implementation Defects

### 9. Eldritch Chain grants more targets at low level than at mid level

`war_cadena.nss:83-84`:

```nwscript
int nMaxCnt = nLevel/5;
if (nMaxCnt < 1) nMaxCnt = 2;
```

A Warlock below level 5 receives 2 additional targets; a Warlock between 5 and
9 receives 1. The floor was almost certainly meant to be `1`.

Note that the invocation is gated at class level 6 by
`CheckWarlockSpellCharisma()`, so the branch is only reachable through an
alternative cast path. It should still be corrected.

### 10. Chilling Burst applies damage regardless of spell resistance and save

`war_rafaga.nss:86` gates only the knockdown behind
`!MyResistSpell(...) && !MySavingThrow(SAVING_THROW_FORT, ...)`. The damage at
`:99` is applied unconditionally, outside that branch.

Decision required: confirm whether the flat damage equal to the Warlock level
is intended to ignore spell resistance.

### 11. Operator precedence in Eldritch Cone skips the self-exclusion check

`war_cono.nss:60`:

```nwscript
if(nEsencia == WARLOCK_ESENCIA_CAUSTICA || !MyResistSpell(OBJECT_SELF, oTarget, fDelay) && (oTarget != OBJECT_SELF))
```

`&&` binds tighter than `||`, so the condition evaluates as
`A || (B && C)`. With the Caustic essence active the `oTarget != OBJECT_SELF`
guard is bypassed. The earlier `spellsIsTarget(..., SPELL_TARGET_STANDARDHOSTILE, ...)`
filter normally excludes the caster, so the defect is currently masked rather
than harmless.

Fix: parenthesise the intended grouping.

### 12. `war_normal.nss` writes the wrong variable name and is unreferenced

`war_normal.nss:12` sets `esencia_ajuste`, while every consumer reads
`esencia_ajustes`. The script would therefore clear the damage type without
clearing the essence adjustment.

No `ImpactScript` entry in `haks-2da/spells.2da` references `war_normal`;
essence deactivation goes through `CambiarEsencia()`. The file appears to be
dead code.

Decision required: delete the file, or fix the variable name if a spell is
expected to use it.

### 13. Undead double damage is a no-op in the generic Wall of Fire

Adjacent finding outside the Warlock scripts. `nw_s0_wallfirea.nss:91`:

```nwscript
if(PB_Race_GetIsUndead(oTarget)) nDamage * 2;
```

The result is discarded. The equivalent line in the same file's `MuroFuego()`
tick function (`:25`) assigns correctly, so undead take double damage per round
but normal damage on entry. `war_wallfirea.nss` does not have this defect.

### 14. `dm_resetbrujo` does not clear Warlock state variables

Reported in game: after a DM uses the invocation reset, an essence left active
before the reset stays active and survives relog, death, and server restart.

`chat_consoladm.nss:356-395` removes feats 1470-1497, 1502 and 1514, then
resets the persistent `INVOCACIONES` counter. It clears no state variable.

The following state survives the reset:

| Variable | Owner | Written by | Consumed by |
|----------|-------|------------|-------------|
| `esencia_ajustes` | PC | `CambiarEsencia()` (`war_utilities.nss:277`) | `GetWarlockSpellDC()`, `GetWarlockExplosionDamage()`, every blast shape, `AjusteEsencia()` |
| `esencia_sobrenatural` | PC | `CambiarEsencia()` | damage type in every blast shape and in `x2_s3_onhitcast.nss` |
| `war_mod_aptitud` | PC | `CambiarModAptitud()` (`war_utilities.nss:224`) | Empower and Maximize multipliers |
| `GOLPEHORRIBLE` | PC | `war_golpe.nss` | `x2_s3_onhitcast.nss:74` |

Consequences:

- A reset character keeps the essence damage bonus (`+1` or `+2` dice), the
  essence damage type, the full essence rider, and the essence branch of
  `GetWarlockSpellDC()` — up to a bonus of 9 with Utterdark. None of that
  requires an invocation feat, only `Explosión Sobrenatural` (feat 1465), which
  is granted at class level 1 and is **not** in the removal list.
- Local variables stored on a player object are written to the character's
  `VarTable` when the character file is exported, which is why the state
  survives logout, death, and restart.
- Feats 1499 (`Soltura Aptitud Sortilega`), 1500 (Empower), 1501 (Maximize)
  and the epic blast feats 1516-1519 are also absent from the removal list.
  The first three are published as invocations.

Note that essences are mutually exclusive by construction: `esencia_ajustes`
and `esencia_sobrenatural` are single-valued, so activating one essence
replaces the previous one and re-activating the same one clears it. The defect
is only that the reset never clears them.

Proposed fix, to be confirmed before implementation: add a public cleanup
function to `war_utilities.nss` that deletes `esencia_ajustes`,
`esencia_sobrenatural`, `war_mod_aptitud` and `GOLPEHORRIBLE`, removes the
`Golpe_Horrible_CastSpell` item property from the equipped weapon, and call it
from the `dm_resetbrujo` branch. Decide separately whether feats 1499, 1500,
1501 and 1516-1519 belong in the removal list.

### 15. Unused shape constants

`WARLOCK_MOLDEADO_NORMAL`, `WARLOCK_MOLDEADO_CADENA`, `WARLOCK_MOLDEADO_CONO`
and `WARLOCK_MOLDEADO_AREA` (`war_utilities.nss:17-20`) are declared and never
referenced anywhere in the repository. Blast shapes are separate spells and
keep no stored state.

Decision required: delete the constants, or implement the shape toggle they
were written for.

### 16. Damage-over-time guard can remain permanently set

`AplicarDoT()` (`war_utilities.nss:324`) marks the target with
`esencia_dot_<damage type>` and clears it when the chain ends. The chain is
continued with `DelayCommand` in the caster's context. If the caster logs out
or is destroyed before the chain completes, the pending call is dropped and the
guard is never cleared.

`AjusteEsencia()` (`war_utilities.nss:355-366`) refuses to start a new
Brimstone or Caustic damage-over-time while the guard is set, so an affected
creature can become permanently immune to that essence rider.

Decision required: clear the guard from a scheduled cleanup with an absolute
timeout, or store an expiry timestamp instead of a Boolean.

## Validation Required Before Implementation

- Recompile every touched script with the bundled compiler.
- Confirm blast damage, DC, and duration values in game at Warlock levels 12,
  16, and 20 for each essence.
- Verify each blast shape against a target with spell resistance and against an
  undead target with the Utterdark essence active.
- Re-check saving throw categories against the published class page after the
  rule decisions above are resolved.
