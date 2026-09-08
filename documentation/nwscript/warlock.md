# Warlock Invocation Model

## Status And Scope

This document records the Warlock (`CLASS_TYPE_WARLOCK`, class row 57)
behavior found in the current PDB source. It is an implementation baseline, not
confirmation that the behavior matches the published class rules and not
authorization to change the ruleset.

Discrepancies between this implementation and the published class page are
tracked separately in
[Warlock errata](../pending-changes/warlock-errata.md).

The audited implementation is:

- `src/shared/nss/war_utilities.nss` — shared DC, damage, essence, and
  damage-over-time logic
- `src/shared/nss/war_*.nss` — one script per invocation
- `src/shared/nss/x2_s3_onhitcast.nss` — Hideous Blow delivery
- `src/shared/nss/pb_nivellanzador.nss` — caster level resolution
- `haks-2da/classes.2da`, `haks-2da/feat.2da`, `haks-2da/spells.2da`,
  `haks-2da/cls_feat_warlok.2da`

## Class Chassis

| Property | Value | Source |
|----------|-------|--------|
| Class row | 57 | `haks-2da/classes.2da` |
| Hit die | d6 | `classes.2da`, `HitDie` |
| Base attack bonus | `CLS_ATK_2` (3/4 progression) | `classes.2da`, `AttackBonusTable` |
| Saving throws | `CLS_SAVTHR_WIZ` | `classes.2da`, `SavingThrowTable` |
| Primary ability | Charisma | `classes.2da`, `PrimaryAbil` |
| Caster level | Equals Warlock class level | `pb_nivellanzador.nss`, `GetSpecialCasterLevel` |

`GetTotalCasterLevel()` detects a Warlock invocation through
`GetSpellFeatId()` and the `MinLevelClass` column of `feat.2da`, then resolves
the caster level as the Warlock class level.

## Invocation Tiers

Tier is defined by the `Innate` column of `spells.2da`; the level gate is
enforced twice, by `MinLevel` in `feat.2da` and by
`CheckWarlockSpellCharisma()` (`war_utilities.nss:149`).

| Tier | `Innate` | Class level required by script | Invocations |
|------|----------|-------------------------------|-------------|
| Least | 1-2 | 1 | Eldritch Spear, Hideous Blow, Chilling Burst, Beguiling Influence, Dark One's Own Luck, Devil's Sight, Leaps and Bounds, See the Unseen, Darkness (Aliento de la noche), Infernal Recovery, Imbue Item |
| Lesser | 4 | 6 | Voracious Dispelling, Walk Unseen, Dead Walk, Curse of Despair, Flee the Scene, Charm Monster, Brimstone Blast, Hellrime Blast, Eldritch Chain |
| Greater | 6 | 11 | Chilling Tentacles, Hellcat, Dark Wall of Fire, Repelling Blast, Eldritch Cone, **Caustic Blast**, **Devour Magic**, Empower Spell-Like Ability |
| Dark | 8 | 16 | Utterdark Blast, Eldritch Doom, Word of Changing, Retributive Invisibility, Path of Shadow, Maximize Spell-Like Ability |

Two frequently misclassified entries:

- **Caustic Blast** (`spells.2da` row 1368, feat 1502) is a **greater**
  invocation, not a dark one.
- **Devour Magic** (`spells.2da` row 1369, feat 1514) is a **greater**
  invocation. `Voracious Dispelling` (row 1348, feat 1476) is a **lesser**
  invocation.

`Maximize Spell-Like Ability` carries `Innate` 8 but `MinLevel` 8 in
`feat.2da`. The two gates disagree; `CheckWarlockSpellCharisma()` enforces
class level 16.

### Charisma Access Gate

`CheckWarlockSpellCharisma()` (`war_utilities.nss:149`) blocks the invocation
when `Innate > Charisma - 10`. The effective minimum Charisma is therefore
`10 + Innate`:

| Tier | Minimum Charisma |
|------|------------------|
| Least | 12 |
| Lesser | 14 |
| Greater | 16 |
| Dark | 18 |

## Saving Throw DC

`GetWarlockSpellDC()` (`war_utilities.nss:167`):

```
DC = 10 + nSpellLevelBonus + nAptitudeBonus + Charisma modifier
```

- `nSpellLevelBonus` defaults to `Innate + 1`.
- `nAptitudeBonus` is `+2` when the caster has feat 1499
  (`Soltura Aptitud Sortilega`), `war_utilities.nss:183`.

For the blast spells 1335, 1337, 1344, 1346, 1347 and for Hideous Blow, the
active essence **replaces** the default value (`war_utilities.nss:173-181`):

| Active essence | `nSpellLevelBonus` |
|----------------|--------------------|
| Brimstone (fire) / Hellrime (cold) | 5 |
| Caustic (acid) / Repelling (magical) | 7 |
| Utterdark (negative) | 9 |
| None | `Innate + 1` |

Because this is a replacement and not a maximum, a Brimstone or Hellrime
essence **lowers** the DC of Eldritch Cone (default 7) and Eldritch Doom
(default 9). `war_area.nss:108-112` passes `bIgnorarEsencia = TRUE` for its
Reflex damage save, so Eldritch Doom keeps 9 for damage mitigation while its
essence rider still uses the essence value.

## Eldritch Blast Damage

`GetWarlockExplosionDamage()` (`war_utilities.nss:188`). Charisma is not part
of this calculation at any point.

### Base dice by class level

`war_utilities.nss:196-206`:

| Warlock level | d6 |
|---------------|-----|
| 1-2 | 1 |
| 3-4 | 2 |
| 5-6 | 3 |
| 7-8 | 4 |
| 9-10 | 5 |
| 11-13 | 6 |
| 14-16 | 7 |
| 17-19 | 8 |
| 20-21 | 9 |
| 22-23 | 10 |
| 24+ | 11 |

### Modifiers, applied in order

1. **Epic blast feats** (`war_utilities.nss:208-211`): feats 1516-1519, chained
   by `PREREQFEAT1`, add `+1` to `+4` dice. The chain is evaluated with
   `else if`, so only the highest owned feat applies.
2. **Essence** (`war_utilities.nss:214`): every essence adds `+2` dice except
   Caustic (`+1`) and Repelling (`+0`).
3. **Aptitude modifier** (`war_utilities.nss:217-219`): Empower multiplies the
   rolled total by 1.5; Maximize replaces the roll with `dice * 6`. The charge
   is consumed by `UsoModAptitud()` at cast time.
4. **Critical hit**: a ranged touch attack returning `2` doubles the result
   (`war_explosion.nss:67`, `war_cadena.nss`).

Damage type is the essence type stored in `esencia_sobrenatural`, defaulting to
`DAMAGE_TYPE_MAGICAL`.

## Ranged Touch Attack

Single-target and chain shapes resolve with the native
[`TouchAttackRanged()`](https://nwnlexicon.com/index.php/TouchAttackRanged)
(`war_explosion.nss:48`, `war_cadena.nss:54` and `war_cadena.nss:107`). The
engine returns `0` on a miss, `1` on a hit and `2` on a critical hit.

The engine roll uses base attack bonus, the Dexterity modifier, size, and
generic attack-bonus effects. The defender's touch AC excludes armor, shield,
and natural armor bonuses, and retains size, Dexterity, dodge, and deflection.

Cone and Doom shapes do not use a touch attack; they apply a Reflex save
instead. Hideous Blow uses a normal melee attack and therefore does not benefit
from the touch-attack critical doubling.

## Essence Riders

`AjusteEsencia()` (`war_utilities.nss:353`) runs only inside the branch that
already passed the spell-resistance check, so spell resistance suppresses both
the blast damage and its rider.

| Essence | Damage type | Rider | Save | Stacks |
|---------|-------------|-------|------|--------|
| Brimstone | Fire | 2d6 per tick, up to 5 ticks of 6s | Reflex per tick | No — guarded by `esencia_dot_<type>` (`war_utilities.nss:355-366`) |
| Caustic | Acid | 2d6 per tick, up to 5 ticks of 6s | Reflex per tick | No — same guard |
| Hellrime | Cold | -4 Dexterity, 10 turns (`war_utilities.nss:371`) | Fortitude | **Yes** |
| Utterdark | Negative | 2 negative levels, 1 hour, `SupernaturalEffect` | Fortitude | **Yes** |
| Repelling | Magical | Repel `1 + 1d6` metres plus knockdown, 6s (`war_utilities.nss:399`) | Reflex | Not applicable |

`AplicarDoT()` (`war_utilities.nss:324`) applies its damage directly and never
calls `MyResistSpell()`. Every essence damage-over-time therefore bypasses
spell resistance, including Brimstone. Empower and Maximize also scale the
per-tick damage.

Utterdark and Hellrime have no duplicate guard. Each landing blast that fails
its Fortitude save adds another independent instance with its own timer.

### Undead interaction

`PB_Race_GetIsUndead()` (`lib_race.nss:327`) returns TRUE for
`RACIAL_TYPE_UNDEAD` and `RACIAL_TYPE_WIGHT`. With the Utterdark essence
active, every blast shape converts its damage into `EffectHeal` for those
targets (`war_explosion.nss:52`, `war_cono.nss:70`, `war_cadena.nss:60`,
`war_area.nss:130`) and the rider never runs.

## Spell Resistance By Shape

The Caustic essence bypasses spell resistance on the initial impact of every
blast shape, through the condition
`nEsencia == WARLOCK_ESENCIA_CAUSTICA || !MyResistSpell(...)`:

| Script | Line | Bypassed by Caustic |
|--------|------|---------------------|
| `war_explosion.nss` | 71 | Yes |
| `war_cadena.nss` | 57, 110 | Yes |
| `war_cono.nss` | 60 | Yes |
| `war_area.nss` | 97 | Yes |
| `war_wallfirea.nss` | 79 | **No** — always checks |
| `war_rafaga.nss` | 86 | **No** — but damage is applied outside the check |

## Blast Shapes

| Shape | Spell | Targeting | Mitigation | Notes |
|-------|-------|-----------|------------|-------|
| Eldritch Blast / Spear | 1335 / 1337 | Single, ranged touch | Spell resistance | Critical doubles damage |
| Eldritch Chain | 1344 | Touch per target, sphere of colossal radius around the first target | Spell resistance per target | Extra targets `nLevel / 5`, forced to 2 when the result is below 1 (`war_cadena.nss:83`); the chain aborts when the first touch attack misses |
| Eldritch Cone | 1346 | `SHAPE_SPELLCONE`, 11.0 metres (`war_cono.nss:51`) | Reflex half at the essence DC | No touch attack |
| Eldritch Doom | 1347 | Sphere of gargantuan radius | Reflex half at DC `10 + 9 + Charisma` | One hit per enemy (`nONEHIT = TRUE`); missile count is the caster level capped at the Warlock level |
| Hideous Blow | 1338 | Melee weapon on-hit property | Normal attack roll | 6s timelock; delivered by `x2_s3_onhitcast.nss:74-88` |

## Dark Wall Of Fire

`war_wallfire.nss` creates the area of effect for `GetTotalCasterLevel()`
rounds. `war_wallfirea.nss` applies damage; there is no saving throw, and
spell resistance is checked only on entry.

```
Entry: 2d6 + (level / 2) fire  +  2d6 + (level / 2) magical
Tick every 6s: 1d6 + (level / 2) fire  +  1d6 + (level / 2) magical
```

| Warlock level | Entry | Per round |
|---------------|-------|-----------|
| 12 | 16-36, average 26 | 14-24, average 19 |
| 16 | 20-40, average 30 | 18-28, average 23 |

The generic Wall of Fire (`nw_s0_wallfirea.nss:20` and `:80`) applies
`4d6 + caster level` on entry **and** on every tick: average 26 at caster level
12, average 30 at caster level 16. The Warlock version matches on entry and
delivers roughly 73% (level 12) to 77% (level 16) of the generic sustained
damage.

Undead take double damage on the fire half only; the magical half is never
doubled (`war_wallfirea.nss:31`, `:84`). Half of the damage being magical is
the version's real advantage against fire resistance and immunity.

`war_wallfireb.nss` decrements the `AOE_<id>` counter on exit. Entering a
second overlapping wall increments the counter without applying entry damage.

## Utility And Support Invocations

| Invocation | Script | Implementation |
|------------|--------|----------------|
| Voracious Dispelling | `war_disipar.nss` | Dispel level capped at 15 (`:48`); adds `EffectDamage(caster level, DAMAGE_TYPE_MAGICAL)` built at `:43`, before the cap is applied |
| Devour Magic | `war_devorar.nss` | Dispel level capped at 20 (`:62`); adds `EffectTemporaryHitpoints(caster level)` for 60s (`:57`) when the target carried magic |
| Walk Unseen | `war_invi.nss` | `EffectInvisibility(INVISIBILITY_TYPE_NORMAL)` for `HoursToSeconds(caster level)` (`:68`), doubled by feat 1357, Insidious Magic (`:63`) |
| Darkness / Aliento de la noche | `war_niebla.nss` | 30% concealment on the caster only, `HoursToSeconds(caster level)` (`:43`, `:53`) |
| Retributive Invisibility | `war_invisiblem.nss` | Invisibility and 50% concealment as **separate** effects, both `TurnsToSeconds(caster level)` (`:149`, `:161-162`). Breaking invisibility leaves the concealment running. On invisibility loss it detonates once for `4d6 + Warlock level` sonic damage in a huge radius with a Fortitude save against daze (`:64`, `:105`) |
| Dark One's Own Luck | `war_suerte.nss` | Saving throw bonus equal to the Charisma modifier, 24 hours |
| Path of Shadow | `war_teleport.nss` | Sets `RUTASOMBRAS` and opens the `conj_teleport` conversation; blocked by Dimensional Anchor and by the area flag `NOTELEPORT` |
| Word of Changing | `war_polymorph.nss` | Random appearance, 100% spell failure, -20 attack; blocked against undead, constructs, and the caster; one round against shapechangers |
| Chilling Burst | `war_rafaga.nss` | Flat fire damage equal to the Warlock level (`:31`); the Fortitude save gates only the knockdown |
| Infernal Recovery | `war_reg.nss` | Regeneration 1 above level 7, 2 above level 12, 5 above level 17, for 2 turns |

Every invocation feat listed above has `USESPERDAY` set to `****` in
`feat.2da` and is therefore at will. The only limited abilities are Empower
(feat 1500, 5 uses) and Maximize (feat 1501, 3 uses).

## State Variables

Warlock toggles are stored as local variables on the player object. Local
variables on a player are written to the character's `VarTable` on export, so
this state survives logout, death, and server restart.

| Variable | Owner | Meaning |
|----------|-------|---------|
| `esencia_ajustes` | PC | Active essence, one of the `WARLOCK_ESENCIA_*` constants |
| `esencia_sobrenatural` | PC | Damage type of the active essence |
| `war_mod_aptitud` | PC | Pending Empower or Maximize charge |
| `GOLPEHORRIBLE` | PC | Hideous Blow armed on the equipped weapon |
| `esencia_dot_<damage type>` | Target | Guard preventing duplicate essence damage-over-time chains |
| `esencia_effectdelay_<player name>` | Module | Cooldown for the essence-change visual effect only; transient |

Essences are mutually exclusive: `esencia_ajustes` and `esencia_sobrenatural`
hold a single value each, so selecting an essence replaces the previous one and
selecting the active one clears it (`CambiarEsencia()`,
`war_utilities.nss:277`).

The `WARLOCK_MOLDEADO_*` constants (`war_utilities.nss:17-20`) are declared but
unused. Blast shapes are independent spells and store no state.

The DM command `dm_resetbrujo` (`chat_consoladm.nss:356-395`) removes the
invocation feats but clears none of these variables. See errata item 14.

## Scaling Summary

Damage output scales with, in order of impact:

1. Warlock class level, which drives the blast dice table and the caster level.
2. Epic blast feats 1516-1519, up to `+4` dice.
3. The active essence, `+2` dice for all except Caustic (`+1`) and Repelling
   (`+0`).
4. Empower and Maximize charges.
5. Critical hits on the ranged touch attack.

Charisma affects invocation access and every saving throw DC. It never affects
damage.

Accuracy scales with base attack bonus, the Dexterity modifier, and generic
attack-bonus effects, resolved against the target's touch AC.
