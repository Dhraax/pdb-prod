# The darkness descriptor

**Parked on 2026-08-30 by the owner.** Nothing here is scheduled, and no
saving-throw work depends on it. It is written down so the research is not
repeated.

## What it is for

Shadow Defence I, II and III read, in the owner's own words:

> Reduce en uno la TS de los conjuros de las escuelas de encantamiento, ilusion
> y nigromancia que sean lanzados contra el, **asi como los conjuros con el
> descriptor de oscuridad**. Este bonificador aumenta a +2 a nivel 6 y a +3 a
> nivel 9.

The school half is implemented and live: `gsSPGetShadowDefenceDCForSchool` gives
-1, -2 and -3 for feats 1358, 1359 and 1360, and it is applied by the spell
route, the policy-free route and the legacy adapter alike.

**The darkness half has never existed.** That is the whole of what this file is
about.

## Why it cannot simply be added

NWN has no descriptor data. `spells.2da` has a `School` column and nothing for
descriptors, and the engine exposes none. Any implementation is a table kept by
hand.

## What 3.5 says

Twenty-six spells carry the [Darkness] descriptor. From the Player's Handbook,
only **Darkness** and **Deeper Darkness**. The Forgotten Realms ones, which are
the setting's own, are Armor of Darkness, Blacklight, Darkbolt, Net of Shadows,
Shadow Canopy and Scattergloom.

Of all of them, this module has one: **Darkness**.

## The rows it would have to cover

Darkness is not one row. Verified against `haks-2da/spells.2da` on 2026-08-30:

| Row | Label | School | Impact script |
|-----|-------|--------|---------------|
| 36 | `Darkness` | V | `NW_S0_Darkness` |
| 345 | `SHADOW_CON_Darkness` | V | `NW_S0_Darkness` |
| 606 | `ASDarkness` | V | `NW_S0_Darkness` |
| 688 | `GWildShape_DriderDarkness` | V | `x2_s1_driderdark` |
| 1011 | `ConjAssNvl2_Oscuridad` | V | `conj_oscuridad` |
| 1078 | `ConjGuaNegroNvl2_Oscuridad` | V | `****` |
| 1203 | `Blig_Darkness` | V | `NW_S0_Darkness` |
| 1213 | `Blig_DeeperDarkness` | V | `X0_S0_Flare` |
| 1529 | `MMF_Darkness` | V | `mmf_s3_skills` |
| 2935 | `DROW_OSCURIDAD` | `****` | `NW_S0_Darkness` |
| 3062 | `ONI_OSCURIDAD` | `****` | `NW_S0_Darkness` |

**The owner's decision on which of these count**, taken 2026-08-30: the wizard's
and sorcerer's, the assassin's, and the drow and oni racials. Shadow
Conjuration's version counts too. The wild shape rows do not, on the general
rule that everything should consume the same spell and branch internally rather
than multiply rows.

**The Blackguard rows are out.** That class is being retired and must not enter
any change loop.

Row 36 alone is a bard, cleric and wizard spell at level 2, so this is not an
obscure corner: listing only that row would protect a Shadow Adept against the
wizard and leave them exposed to the assassin, the drow and the oni.

## The shape it would take

A bitmask, because a spell carries several descriptors at once - fireball is
`[Fire]`, blasphemy is `[Evil][Language-Dependent][Sonic]`. Nineteen descriptors
exist in 3.5 and they fit in an `int` with room to spare.

```nwscript
int gsSPGetSpellDescriptors(int iSpellId);
int gsSPHasSpellDescriptor(int iSpellId, int iDescriptor);
```

The implementation is a `switch` over spell rows. It starts with darkness and
grows; asking about chaos or fear later costs a case, not a design.

## What would keep it honest

A hand-kept table rots. The proposal was a checker in the style of
`check_effect_identity.py`: sweep `spells.2da`, take every row whose impact
script is in the known set of darkness implementations, and fail if one is
missing from the table. The same idea `build_catalogue.py` uses for base items -
the claim is checked rather than asserted.

## One data fault found alongside

`spells.2da` row 1213, `Blig_DeeperDarkness`, has `X0_S0_Flare` as its impact
script. Deeper Darkness casts Flare, a light spell. It is a Blackguard row and
that class is being retired, so it is recorded here and nowhere else.
