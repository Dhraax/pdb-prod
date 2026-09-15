# Legacy trade progression: where it lives and how to carry it into CNR

**Status: implemented on 2026-09-15.** The conversion lives in
`cnr_i_legacy.nss` and a trade master offers it in conversation. The reference
sections below are what it was built from; the section **What was built** states
what it actually does.

The numbers here come from the code as it was on the day it was deleted; the
commit that removed it is named at the end.

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

## What was built

One conversion per trade, offered by the trade master, never on login.

**Where it lives**

| Resource | Role |
|----------|------|
| `src/cnr/nss/cnr_i_legacy.nss` | The whole conversion: the mapping, the arithmetic, the cleanup |
| `src/cnr/nss/cnr_ofi_conv_c.nss` | `StartingConditional`: shows the line only to a player who still has old progression in that trade |
| `src/cnr/nss/cnr_ofi_conv.nss` | The action that converts |

Both scripts take the trade as the conversation parameter `oficio`, numbered the
way `CnrSkill_*` numbers it: 1 Herrería, 2 Carpintería, 3 Peletería, 4 Alquimia,
5 Joyería, 6 Arcano, 7 Sastrería. That is the same shape `ofi_abre_tienda`
already uses, so adding a master needs a dialogue line, not another script.

**The arithmetic.** The old level, counted out of 100, becomes the same share of
the twenty CNR levels, rounded down by integer division:

```nss
int nLevel = (nLegacy * CNR_MAX_TRADESKILL_LEVEL) / CNR_LEGACY_MAX;
```

70 of 100 gives 14 of 20. So does 74. The character is then written at the **XP
floor** of that level, `CnrTradeXPLevel<n>`, so they keep the level and start it
empty rather than inheriting progress they never earned.

**Which old level counts.** The trade's end product, not the gathering step that
fed it:

| CNR trade | Old key taken as the level | Old keys wiped with it | Book destroyed |
|-----------|----------------------------|------------------------|----------------|
| Herrería | `NIVELHERRERIA` | `NIVELMINERIA`, `NIVELFUNDICION`, `NIVELAFILADURA` | `libroHerreria` |
| Carpintería | `NIVELCARPINTERIA` | `NIVELLENYADOR`, `NIVELSERRERIA`, `NIVELEBANISTA` | `carp_libro` |
| Peletería | `Profesion12`, marroquinería | `Profesion9`, `NIVELDESOLLADOR`, both XP keys | `sapocuelib` |
| Alquimia | `NIVELHERBOLOGIA` | `NIVELALQUIMIA`, `NIVELRECOLECCION`, `NIVELCOCINA` | `libroHerboristeria` |
| Joyería | `NIVELENGARZADOR` | `NIVELTALLADOR`, `NIVELORFEBREESP`, `NIVELORFEBREARC` | `orf_libro` |
| Arcano | `Profesion15`, artesanía urdímbrica | `Profesion8`, `Profesion11`, their XP keys, `2AJUSTE_ARTESANIA_URD_BETA` | `pb_ofi_man_artes`, `sapoaralib` |
| Sastrería | none | | |

Alquimia takes the old **herbalism** level, not the old alchemy one: the trade
that was Herboristería is the one that became Alquimia, and the old alchemy level
was a later step inside it. Sastrería did not exist in the old system at all, so
no master offers the line and every tailor starts at zero.

**Once only.** On success the conversion writes `CNR_CONV_<trade>` to the same
variable container and then removes every key in the row above and destroys the
books. Two independent stops, so a lost flag still cannot convert a second time:
there is nothing left to read.

**It warns before it acts.** The master's line does nothing by itself: it opens
a node that spells out the two-profession cap, that Alquimia does not take a
slot, that the level is rounded down and that the old notes and book will be
gone. Only the reply under that warning runs `cnr_ofi_conv`. The choice is
irreversible and the player is told so before making it.

**What it refuses.** The two-profession cap is checked by `CnrSkill_CanSetXP`
**before anything of the player's is touched**, not by letting the write fail
afterwards. A character who already holds two trades at level 2 or more, Alquimia
aside, is told so and keeps every old level and every old book. `CnrSkill_Load`
failing aborts the same way, because a conversion that cannot read the current
level might silently lower it.

**The row it writes carries both numbers.** `CnrSkill_SetXP` derives the level
from the XP with `PersistDetermineTradeskillLevel` and writes `skill_level` and
`skill_xp` in the same statement, so a converted character is level 14 with the
9,875 XP that level 14 starts at, never level 14 with a token value.

**When the new level is already higher**, nothing is written to CNR, but the old
keys and the book are still removed and the flag is still set: the character is
told their current trade already beats what they had.

## The one legacy key that was still read, and no longer is

`ko_kazad_cantera`, the two granite quarries in Kazad and the barbarian cave,
used to read `NIVELMINERIA` and roll differently on it: `d10() == 10` for a
character with any mining level, `d20() == 20` for one without. The key is still
on the container of every character who ever had it -nothing writes it any more,
but nothing erased it either- so an old character rolled twice as well as a new
one, forever, on the strength of a trade that no longer exists. The script's own
comment called both branches 10%, which was wrong for the second.

That check is gone. **Everyone rolls `d10() == 10`**, the better of the two, and
the script no longer includes `mti_libreria`, which it only needed to read the
key. `NIVELMINERIA` is now read by nothing: `cnr_i_legacy` deletes it when
Herrería is converted, and that is all.

## Provenance

Both paths were read and removed by the commit that adds this document. The code
quoted here is from `src/shared/nss/wrap_bp.nss` lines 68-122 and
`src/shared/nss/pb_mod_activate.nss` lines 2586-2884 as they stood at commit
`b165a1c7`, which is where to recover the originals from.
