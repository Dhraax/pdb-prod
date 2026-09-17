/// ----------------------------------------------------------------------------
/// @system  CNR Oficios
/// @file    cnr_i_legacy
/// @author  Dhraax
/// @brief   One-shot conversion of the old trade progression into CNR.
///
///          The old system kept a level per sub-trade, counted to 100, on the
///          player's own variable container. CNR keeps XP per trade and derives
///          a level from 1 to 20. This file takes the main level of an old
///          trade, works out the same share of the CNR scale rounded down, and
///          writes it as the XP floor of that level.
///
///          A character at 70 of 100 in the old carpentry becomes level 14 of
///          20, because 70 * 20 / 100 is 14. Integer division is the rounding:
///          it always goes down, which is what was asked for. The character is
///          written at the XP floor of that level, so the row in the database
///          carries both the level and the experience that belongs to it.
///
///          Nothing runs on login. A trade master offers the conversion in
///          conversation, the player accepts, and from then on a flag in the
///          same container stops it happening twice. The old keys of that trade
///          and its book are removed in the same step, so there is nothing left
///          to convert a second time even if the flag were lost.
///
///          Sastreria has no counterpart in the old system, so it never offers
///          the option.
/// ----------------------------------------------------------------------------

#include "cnr_i_skill"

// -----------------------------------------------------------------------------
//                                  Constants
// -----------------------------------------------------------------------------

/// The old scale. Every legacy trade level was counted out of this.
const int CNR_LEGACY_MAX = 100;

/// Prefix of the per-trade flag written to the variable container once a
/// conversion has been done. The trade name is appended, so a DM reading the
/// container sees CNR_CONV_Herreria rather than a number.
const string CNR_LEGACY_FLAG = "CNR_CONV_";

// -----------------------------------------------------------------------------
//                                  Prototypes
// -----------------------------------------------------------------------------

/// @brief The old key that holds the main level of a CNR trade.
/// @param nSkill CNR tradeskill, 1 to 7, as CnrSkill_* numbers them.
/// @returns The persistent key, or "" when the trade had no old counterpart.
string CnrLegacy_MainKey(int nSkill);

/// @brief The old level a character holds for a CNR trade.
/// @param oPC The player.
/// @param nSkill CNR tradeskill, 1 to 7.
/// @returns The level on the old scale, or 0 when there is nothing to convert.
int CnrLegacy_Level(object oPC, int nSkill);

/// @brief Whether the conversion has already been done for this trade.
/// @param oPC The player.
/// @param nSkill CNR tradeskill, 1 to 7.
/// @returns TRUE when the flag is set.
int CnrLegacy_Converted(object oPC, int nSkill);

/// @brief Whether a trade master should offer the conversion.
/// @param oPC The player.
/// @param nSkill CNR tradeskill, 1 to 7.
/// @returns TRUE when there is an old level and it has not been converted.
int CnrLegacy_HasPending(object oPC, int nSkill);

/// @brief The CNR level an old level converts into.
/// @param nLegacy Level on the old scale.
/// @returns 1 to CNR_MAX_TRADESKILL_LEVEL, rounded down.
int CnrLegacy_TargetLevel(int nLegacy);

/// @brief Remove every persistent key of an old trade and its books.
/// @param oPC The player.
/// @param nSkill CNR tradeskill, 1 to 7.
void CnrLegacy_Clear(object oPC, int nSkill);

/// @brief Convert one trade. Speaks to the player either way.
/// @param oPC The player.
/// @param nSkill CNR tradeskill, 1 to 7.
/// @returns TRUE when the conversion was applied.
int CnrLegacy_Convert(object oPC, int nSkill);

// -----------------------------------------------------------------------------
//                                  Functions
// -----------------------------------------------------------------------------

string CnrLegacy_MainKey(int nSkill)
{
    // The main level is the trade's end product, not the gathering step that
    // fed it: a carpenter is measured by NIVELCARPINTERIA, not by how many
    // trees he felled.
    switch (nSkill)
    {
        case 1: return "NIVELHERRERIA";      // Herreria
        case 2: return "NIVELCARPINTERIA";   // Carpinteria
        case 3: return "Profesion12";        // Peleteria, old marroquineria
        case 4: return "NIVELHERBOLOGIA";    // Alquimia, old herboristeria
        case 5: return "NIVELENGARZADOR";    // Joyeria, old engarce
        case 6: return "Profesion15";        // Arcano, old artesania urdimbrica
    }
    return "";
}

int CnrLegacy_Level(object oPC, int nSkill)
{
    string sKey = CnrLegacy_MainKey(nSkill);
    if (sKey == "")
    {
        return 0;
    }
    return ObtenerIntPersistente(oPC, sKey);
}

int CnrLegacy_Converted(object oPC, int nSkill)
{
    string sSkill = GetSkillName(nSkill - 1);
    if (sSkill == "")
    {
        return FALSE;
    }
    return ObtenerIntPersistente(oPC, CNR_LEGACY_FLAG + sSkill) > 0;
}

int CnrLegacy_HasPending(object oPC, int nSkill)
{
    if (CnrLegacy_Level(oPC, nSkill) <= 0)
    {
        return FALSE;
    }
    return !CnrLegacy_Converted(oPC, nSkill);
}

int CnrLegacy_TargetLevel(int nLegacy)
{
    // Integer division rounds down, which is the whole rule: 70 of 100 gives
    // 70 * 20 / 100 = 14, and 74 gives 14 as well.
    int nLevel = (nLegacy * CNR_MAX_TRADESKILL_LEVEL) / CNR_LEGACY_MAX;
    if (nLevel < 1)
    {
        return 1;
    }
    if (nLevel > CNR_MAX_TRADESKILL_LEVEL)
    {
        return CNR_MAX_TRADESKILL_LEVEL;
    }
    return nLevel;
}

void CnrLegacy_DestroyBook(object oPC, string sTag)
{
    // A character may hold more than one copy, so empty the inventory of them.
    // DestroyObject only takes effect once this script ends: searching again
    // would return the same book until the engine aborted the script with
    // TOO MANY INSTRUCTIONS. Retagging it first moves the search on. The cap
    // keeps a book that refused the new tag from looping all the same.
    int nGuard = 0;
    object oBook = GetItemPossessedBy(oPC, sTag);
    while (GetIsObjectValid(oBook) && nGuard < 50)
    {
        SetTag(oBook, "cnr_legacy_destroyed");
        DestroyObject(oBook);
        oBook = GetItemPossessedBy(oPC, sTag);
        nGuard++;
    }
}

void CnrLegacy_Clear(object oPC, int nSkill)
{
    switch (nSkill)
    {
        case 1:
            BorrarIntPersistente(oPC, "NIVELHERRERIA");
            BorrarIntPersistente(oPC, "NIVELMINERIA");
            BorrarIntPersistente(oPC, "NIVELFUNDICION");
            BorrarIntPersistente(oPC, "NIVELAFILADURA");
            CnrLegacy_DestroyBook(oPC, "libroHerreria");
            break;

        case 2:
            BorrarIntPersistente(oPC, "NIVELCARPINTERIA");
            BorrarIntPersistente(oPC, "NIVELLENYADOR");
            BorrarIntPersistente(oPC, "NIVELSERRERIA");
            BorrarIntPersistente(oPC, "NIVELEBANISTA");
            CnrLegacy_DestroyBook(oPC, "carp_libro");
            break;

        case 3:
            BorrarIntPersistente(oPC, "Profesion12");
            BorrarIntPersistente(oPC, "Profesion12XP");
            BorrarIntPersistente(oPC, "Profesion9");
            BorrarIntPersistente(oPC, "Profesion9XP");
            BorrarIntPersistente(oPC, "NIVELDESOLLADOR");
            CnrLegacy_DestroyBook(oPC, "sapocuelib");
            break;

        case 4:
            BorrarIntPersistente(oPC, "NIVELALQUIMIA");
            BorrarIntPersistente(oPC, "NIVELHERBOLOGIA");
            BorrarIntPersistente(oPC, "NIVELRECOLECCION");
            BorrarIntPersistente(oPC, "NIVELCOCINA");
            CnrLegacy_DestroyBook(oPC, "libroHerboristeria");
            break;

        case 5:
            BorrarIntPersistente(oPC, "NIVELENGARZADOR");
            BorrarIntPersistente(oPC, "NIVELTALLADOR");
            BorrarIntPersistente(oPC, "NIVELORFEBREESP");
            BorrarIntPersistente(oPC, "NIVELORFEBREARC");
            CnrLegacy_DestroyBook(oPC, "orf_libro");
            break;

        case 6:
            BorrarIntPersistente(oPC, "Profesion15");
            BorrarIntPersistente(oPC, "Profesion15XP");
            BorrarIntPersistente(oPC, "Profesion11");
            BorrarIntPersistente(oPC, "Profesion11XP");
            BorrarIntPersistente(oPC, "Profesion8");
            BorrarIntPersistente(oPC, "Profesion8XP");
            BorrarIntPersistente(oPC, "2AJUSTE_ARTESANIA_URD_BETA");
            CnrLegacy_DestroyBook(oPC, "pb_ofi_man_artes");
            CnrLegacy_DestroyBook(oPC, "sapoaralib");
            break;
    }
}

int CnrLegacy_Convert(object oPC, int nSkill)
{
    string sSkill = GetSkillName(nSkill - 1);
    int nLegacy = CnrLegacy_Level(oPC, nSkill);
    if (sSkill == "" || nLegacy <= 0)
    {
        return FALSE;
    }

    if (CnrLegacy_Converted(oPC, nSkill))
    {
        SendMessageToPC(oPC, "Ya convertiste tu " + sSkill + " al oficio nuevo.");
        return FALSE;
    }

    // Fail closed: without the cache there is no way to tell whether this would
    // lower an existing level, and a conversion that guesses is worse than one
    // that waits.
    if (!CnrSkill_Load(oPC))
    {
        SendMessageToPC(oPC, "No se pudo leer tu oficio. Avisa a un DM.");
        return FALSE;
    }

    int nLevel = CnrLegacy_TargetLevel(nLegacy);
    int nXP = GetLocalInt(GetModule(), "CnrTradeXPLevel" + IntToString(nLevel));
    int nHaveXP = CnrSkill_GetXP(oPC, nSkill);

    // Ask before touching anything. CnrSkill_CanSetXP is what refuses a third
    // trade of level 2 or more, and it tells the player why itself. Checking it
    // here rather than letting CnrSkill_SetXP fail keeps the guarantee simple:
    // when the conversion is not possible, nothing of the player's is removed.
    if (!CnrSkill_CanSetXP(oPC, nSkill, nXP))
    {
        SendMessageToPC(oPC, "No se convierte nada: conservas tu " + sSkill
            + " antigua y su manual, y puedes convertir otro oficio.");
        return FALSE;
    }

    if (nXP > nHaveXP)
    {
        if (!CnrSkill_SetXP(oPC, nSkill, nXP))
        {
            SendMessageToPC(oPC, "No se pudo escribir tu oficio. No se ha "
                + "retirado nada; avisa a un DM.");
            return FALSE;
        }

        SendMessageToPC(oPC, "Tu " + sSkill + " antigua era nivel "
            + IntToString(nLegacy) + " de " + IntToString(CNR_LEGACY_MAX)
            + ". En el oficio nuevo eso son " + IntToString(nLevel)
            + " de " + IntToString(CNR_MAX_TRADESKILL_LEVEL) + ", con "
            + IntToString(nXP) + " de experiencia.");
        PlaySound("gui_level_up");
    }
    else
    {
        SendMessageToPC(oPC, "Tu " + sSkill + " antigua era nivel "
            + IntToString(nLegacy) + " de " + IntToString(CNR_LEGACY_MAX)
            + ", que en el oficio nuevo son " + IntToString(nLevel) + " de "
            + IntToString(CNR_MAX_TRADESKILL_LEVEL) + ". Ya tienes eso o mas, "
            + "asi que se queda como esta.");
    }

    GuardarIntPersistente(oPC, CNR_LEGACY_FLAG + sSkill, 1);
    CnrLegacy_Clear(oPC, nSkill);
    SendMessageToPC(oPC, "Se retiran las anotaciones y el manual del oficio viejo.");
    WriteTimestampedLogEntry("[CNR] Legacy conversion: " + GetName(oPC)
        + " " + sSkill + " " + IntToString(nLegacy) + " -> " + IntToString(nLevel));
    return TRUE;
}
