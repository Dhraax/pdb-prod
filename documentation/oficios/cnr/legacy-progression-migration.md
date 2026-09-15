# Legacy trade progression: where it lives and how to carry it into CNR

**Status: reference, nothing implemented.** This document exists because the two
last live pieces of the old trade system were removed from production on
2026-09-15 and the owner asked that their mechanics be recorded first: the plan
is to convert each character's legacy trade level into the equivalent share of a
CNR tradeskill level.

Read this before writing that conversion. The numbers here come from the code as
it was on the day it was deleted; the commit that removed it is named at the end.

## Where the old progression is stored

Not in MySQL. `mti_libreria` keeps it on **an item in the player's own
inventory**:

```nss
const string CONTENEDOR_VARIABLES = "dmfi_pc_emote";

void GuardarIntPersistente(object oJugador, string sVariable, int iValor)
{
  object oVarita = GetItemPossessedBy(oJugador, CONTENEDOR_VARIABLES);
  if(oVarita != OBJECT_INVALID) SetLocalInt(oVarita, sVariable, iValor);
}
```

Three consequences the conversion has to respect:

- **The data travels with the character's bag.** A character who lost that item
  has no legacy progression to read, and the conversion has to treat that as
  zero rather than as an error.
- **PWDB already uses the same container** for its own cached values
  (`pwdb_i_user.nss`, `pwdb_c_config.nss`), so the item is not going away and
  the legacy keys can be read from it at any point after login.
- Nothing has written these keys since 2026-09-15 except the two paths removed
  that day, so the values are frozen and the conversion can run once, late,
  without racing anything.

## The keys

Seventeen trade levels, each an integer that the old system capped at 100:

| Key | Old trade | Nearest CNR tradeskill |
|-----|-----------|------------------------|
| `NIVELMINERIA` | Minería | harvesting, no CNR skill of its own |
| `NIVELFUNDICION` | Fundición | `CNR_TRADESKILL_SMELTING` |
| `NIVELHERRERIA` | Herrería | `CNR_TRADESKILL_SMITHING` |
| `NIVELAFILADURA` | Afiladura | `CNR_TRADESKILL_SMITHING` |
| `NIVELRECOLECCION` | Recolección | harvesting |
| `NIVELCOCINA` | Cocina | trade withdrawn |
| `NIVELHERBOLOGIA` | Herbología | `CNR_TRADESKILL_ALCHEMY` |
| `NIVELALQUIMIA` | Alquimia | `CNR_TRADESKILL_ALCHEMY` |
| `NIVELLENYADOR` | Tala | harvesting |
| `NIVELSERRERIA` | Serrería | `CNR_TRADESKILL_WOOD` |
| `NIVELCARPINTERIA` | Carpintería | `CNR_TRADESKILL_CARPENTRY` |
| `NIVELEBANISTA` | Ebanistería | `CNR_TRADESKILL_CARPENTRY` |
| `NIVELTALLADOR` | Tallado de gemas | `CNR_TRADESKILL_GEM` |
| `NIVELENGARZADOR` | Engarce | `CNR_TRADESKILL_JEWELRY` |
| `NIVELORFEBREESP` | Orfebrería especial | `CNR_TRADESKILL_JEWELRY` |
| `NIVELORFEBREARC` | Orfebrería arcana | `CNR_TRADESKILL_JEWELRY` |
| `NIVELDESOLLADOR` | Desollar | `CNR_TRADESKILL_SEWING` |

Plus the arcane trade, which stored level and experience separately:

| Key | Meaning |
|-----|---------|
| `Profesion8` / `Profesion8XP` | Esenciación |
| `Profesion11` / `Profesion11XP` | Infusionamiento |
| `Profesion15` / `Profesion15XP` | Artesanía Urdímbrica |

The mapping column is the obvious correspondence, not a decision. Several old
trades collapse into one CNR skill and three of them have no CNR equivalent at
all, so the conversion has to decide what wins when a character holds two old
levels that map to the same skill: the higher one, the sum, or an average.

## What CNR expects on the other side

- Seven tradeskills, `CNR_SKILL_COUNT` in `cnr_i_skill.nss`.
- Levels 1 to 20. `CNR_MAX_TRADESKILL_LEVEL` is 20 and
  `PersistDetermineTradeskillLevel` counts down from 20, so XP beyond the last
  threshold never raises the level again.
- Progression is stored as **XP, not level**. The level is derived.
  `CnrSkill_SetXP` writes through to the database and refuses a value the
  character is not allowed to reach; `CnrSkill_CanSetXP` is the gate.
- `CNR_MAX_TRAINED_PROFESSIONS` is 2 and `CNR_TRAINED_PROFESSION_LEVEL` is 2: a
  character may only hold two professions, and training one starts it at level
  2. **A conversion that grants a third profession will be refused by
  `CnrSkill_CanSetXP`**, so the conversion has to pick which two survive, or
  the owner has to decide to raise the cap.

The XP curve, set in `cnr_trade_init.nss`:

| Level | XP | Level | XP |
|-------|----|-------|----|
| 1 | 0 | 11 | 5,750 |
| 2 | 125 | 12 | 7,000 |
| 3 | 250 | 13 | 8,375 |
| 4 | 500 | 14 | 9,875 |
| 5 | 875 | 15 | 11,975 |
| 6 | 1,375 | 16 | 14,250 |
| 7 | 2,000 | 17 | 16,700 |
| 8 | 2,750 | 18 | 19,300 |
| 9 | 3,625 | 19 | 22,000 |
| 10 | 4,625 | 20 | 25,000 |

There are two ways to spend an old level here and they do not agree. Sharing the
**XP** writes `25000 * L / 100`: level 50 becomes 12,500 XP, which the descending
lookup resolves to level **15**, because level 15 starts at 11,975. Sharing the
**level** writes `20 * L / 100`: level 50 becomes level 10, whose floor is 4,625
XP. The curve is not linear, so the two answers diverge by five levels in the
middle of the scale. **What was built shares the level**, which is what the owner
asked for; the XP-sharing version is recorded here only so nobody rediscovers it
and assumes it was the plan.

## The precedent worth copying

The arcane trade was already migrated once this way, and the code is worth
reading before writing the new conversion. It lived in `wrap_bp`, the `OnEnter`
of `bolsaplanar`, the area every player passes through on login:

- **One shot, guarded by a persistent flag.** `2AJUSTE_ARTESANIA_URD_BETA` is
  written at the end so the adjustment never runs twice, and the first branch
  keyed off the player still holding the old manual `sapoaralib`.
- **Halve the level, then recompute the XP from the level**, not the other way
  round: `GuardarIntPersistente(oPC, "Profesion8", iProfesion8 / 2)` followed by
  `Profesion8XP = CalculoSiguienteNivelXPEsenciacion2(iProfesion8 - 1)`. The XP
  is set to the floor of the new level so the character keeps the level and
  loses only the progress inside it.
- **A floor of 1**, so nobody is converted down to nothing.
- **A second branch for the characters the first one missed.** It is the `else`
  of the manual check, so it ran only when the old manual was **not** present,
  and it additionally required `2AJUSTE_ARTESANIA_URD_BETA` to be 0 and at least
  one of the three levels to be above 53. It then compressed only the part above
  50 by half. Read the whole guard before copying it: manual absent, flag unset,
  level above 53.
- **Swap the item and tell the player**, on a four second delay so the message
  is not lost in the login noise:
  `DestroyObject(oAntiguoManualArtesania); CreateItemOnObject("pb_ofi_man_artes", oPC);`

The shape is the part to copy: a one-shot guarded conversion that runs on login,
derives the new value from the old, floors it, replaces whatever item
represented the old trade, and says so in a delayed message.

What not to copy: it ran inside a 600-line area script that does twenty
unrelated things, and it was still running years after it was needed because
nothing recorded when it could be deleted. The CNR conversion belongs in its own
script, with the date it may be removed written next to the flag it sets.

## The other thing that was still live

`kitdesollador`, the old skinning knife, was still fully functional in
`pb_mod_activate` on the day this was written: 299 lines that checked the target
was a dead creature within 2 metres, consumed knife durability out of `USOSPICO`
(`d6(20)` on first use, one point per hide and up to `d4` for the thick ones,
destroyed under 6), rolled against a difficulty of 50 to 420 by `PIEL` type,
handed out the ten legacy hides through `FuncionCrearObjetoYTag`, and levelled
`NIVELDESOLLADOR` up to 100 with a third roll.

CNR replaced all of it: `cnrSkinningKnife` and `cnr_i_skin` treat the corpse as
a node with three deliveries and a ten second cooldown, and the hides are the
ten `cuero_*` materials. The only thing worth taking from the old branch is the
`PIEL` 1-10 scale, which `skinning-inventory.md` already records, and the
`NIVELDESOLLADOR` value, which is in the table above.

## One legacy key is still read, and it still discriminates

`ko_kazad_cantera`, the two granite quarries in Kazad, reads `NIVELMINERIA`, and
the key is still on the container of every character who ever had it: nothing
writes it any more, but nothing erased it either.

- a character with any mining level takes the miner branch, `d10() == 10`, one
  in ten;
- a character with none takes `d20() == 20`, one in twenty.

The script's own comment calls both 10%, which is wrong for the second. No new
character can earn the better odds, and **a conversion that wipes `NIVELMINERIA`
drops that character from one in ten to one in twenty**, so whichever trade ends
up clearing that key has to account for it. Whether the quarry should read a CNR
level instead is an open decision the owner has deferred.

## Provenance

Both paths were read and removed by the commit that adds this document. The code
quoted here is from `src/shared/nss/wrap_bp.nss` lines 68-122 and
`src/shared/nss/pb_mod_activate.nss` lines 2586-2884 as they stood at commit
`b165a1c7`, which is where to recover the originals from.
