/// ----------------------------------------------------------------------------
/// @system  CNR Tradeskills
/// @file    cnr_i_skill
/// @author  Dhraax
/// @brief   Tradeskill XP persistence keyed by pwdb_character.character_id.
/// ----------------------------------------------------------------------------

#include "nwnx_sql"
#include "pwdb_i_user"
#include "mti_libreria"

// Number of tradeskills. GetSkillName() is 0-based; the CnrTradeskillXP_<n>
// variable suffix used by legacy CNR code is 1-based.
const int CNR_SKILL_COUNT = 7;
const int CNR_SKILL_ALCHEMY = 4;
const int CNR_MAX_TRAINED_PROFESSIONS = 2;
const int CNR_TRAINED_PROFESSION_LEVEL = 2;
// The module's tradeskill curve stops here: PersistDetermineTradeskillLevel
// counts down from 20, so beyond it experience accumulates without ever
// raising the level again.
const int CNR_MAX_TRADESKILL_LEVEL = 20;

// Session cache on CONTENEDOR_VARIABLES, refreshed at login.
const string CNR_VAR_XP    = "CNR_XP_";
const string CNR_VAR_LEVEL = "CNR_LEVEL_";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Load every tradeskill row for oPC into the container cache, creating
///     missing rows at level 1 with 0 XP.
/// @param oPC Player character to load.
/// @returns TRUE when the load completed; FALSE when the session cannot persist.
int CnrSkill_Load(object oPC);

/// @brief Read cached tradeskill XP. Does not query the database.
/// @param oPC Player character to read.
/// @param nSkill Skill index, 1-based.
/// @returns XP, or 0 when unknown.
int CnrSkill_GetXP(object oPC, int nSkill);

/// @brief Read cached tradeskill level. Does not query the database.
/// @param oPC Player character to read.
/// @param nSkill Skill index, 1-based.
/// @returns Level, or 1 when unknown.
int CnrSkill_GetLevel(object oPC, int nSkill);

/// @brief Check whether an XP total may train the requested profession.
/// @param oPC Player character to check.
/// @param nSkill Skill index, 1-based.
/// @param nXP Proposed new XP total.
/// @returns TRUE when the write respects the two-profession limit. Alchemy is
///     always exempt and level-one professions do not occupy a slot.
int CnrSkill_CanSetXP(object oPC, int nSkill, int nXP);

/// @brief Whether a profession has reached the end of the curve.
/// @param oPC Player to inspect.
/// @param nSkill One-based tradeskill index.
/// @returns TRUE when the profession is at CNR_MAX_TRADESKILL_LEVEL.
int CnrSkill_IsMaxLevel(object oPC, int nSkill);

/// @brief Write tradeskill XP through to the database and refresh the cache.
///     Refuses to write when no character_id is available.
/// @param oPC Player character to write.
/// @param nSkill Skill index, 1-based.
/// @param nXP New XP total.
/// @returns TRUE when the row was written; otherwise FALSE.
int CnrSkill_SetXP(object oPC, int nSkill, int nXP);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int CnrSkill_Load(object oPC)
{
    int nCharacterId = PWDB_GetCharacterId(oPC);
    if (nCharacterId <= 0)
    {
        return FALSE;
    }

    object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    if (!GetIsObjectValid(oContainer))
    {
        return FALSE;
    }

    int nSkill;
    for (nSkill = 1; nSkill <= CNR_SKILL_COUNT; nSkill++)
    {
        string sSkill = GetSkillName(nSkill - 1);
        if (sSkill == "")
        {
            continue;
        }

        // Create the row if this character has never trained the skill.
        if (NWNX_SQL_PrepareQuery(
            "INSERT INTO cnr_tradeskill (character_id, skill_name)"
            + " VALUES (?, ?)"
            + " ON DUPLICATE KEY UPDATE character_id = character_id"))
        {
            NWNX_SQL_PreparedInt(0, nCharacterId);
            NWNX_SQL_PreparedString(1, sSkill);
            NWNX_SQL_ExecutePreparedQuery();
        }

        int nXp = 0;
        int nLevel = 1;

        if (NWNX_SQL_PrepareQuery(
            "SELECT skill_xp, skill_level FROM cnr_tradeskill"
            + " WHERE character_id = ? AND skill_name = ? LIMIT 1"))
        {
            NWNX_SQL_PreparedInt(0, nCharacterId);
            NWNX_SQL_PreparedString(1, sSkill);

            if (NWNX_SQL_ExecutePreparedQuery() && NWNX_SQL_ReadyToReadNextRow())
            {
                NWNX_SQL_ReadNextRow();
                nXp    = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
                nLevel = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
            }
        }

        SetLocalInt(oContainer, CNR_VAR_XP + IntToString(nSkill), nXp);
        SetLocalInt(oContainer, CNR_VAR_LEVEL + IntToString(nSkill), nLevel);
    }

    return TRUE;
}

int CnrSkill_GetXP(object oPC, int nSkill)
{
    object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    if (!GetIsObjectValid(oContainer))
    {
        return 0;
    }

    return GetLocalInt(oContainer, CNR_VAR_XP + IntToString(nSkill));
}

int CnrSkill_GetLevel(object oPC, int nSkill)
{
    object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    if (!GetIsObjectValid(oContainer))
    {
        return 1;
    }

    int nLevel = GetLocalInt(oContainer, CNR_VAR_LEVEL + IntToString(nSkill));
    return nLevel > 0 ? nLevel : 1;
}

int CnrSkill_IsMaxLevel(object oPC, int nSkill)
{
    return CnrSkill_GetLevel(oPC, nSkill) >= CNR_MAX_TRADESKILL_LEVEL;
}

int CnrSkill_CanSetXP(object oPC, int nSkill, int nXP)
{
    int nCharacterId = PWDB_GetCharacterId(oPC);
    string sSkill = GetSkillName(nSkill - 1);
    if (nCharacterId <= 0 || sSkill == "")
    {
        return FALSE;
    }

    int nTargetLevel = PersistDetermineTradeskillLevel(nXP);
    if (nSkill == CNR_SKILL_ALCHEMY
        || nTargetLevel < CNR_TRAINED_PROFESSION_LEVEL)
    {
        return TRUE;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT"
        + " IFNULL(MAX(CASE WHEN skill_name = ? THEN skill_level ELSE 1 END), 1),"
        + " SUM(CASE WHEN skill_name <> 'Alquimia' AND skill_level >= ?"
        + "          THEN 1 ELSE 0 END)"
        + " FROM cnr_tradeskill WHERE character_id = ?"))
    {
        PrintString("[CNR] Profession limit query preparation failed: "
            + NWNX_SQL_GetLastError());
        SendMessageToPC(oPC, "No se pudo comprobar tu limite de oficios. Avisa a un DM.");
        return FALSE;
    }

    NWNX_SQL_PreparedString(0, sSkill);
    NWNX_SQL_PreparedInt(1, CNR_TRAINED_PROFESSION_LEVEL);
    NWNX_SQL_PreparedInt(2, nCharacterId);
    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        PrintString("[CNR] Profession limit query failed: "
            + NWNX_SQL_GetLastError());
        SendMessageToPC(oPC, "No se pudo comprobar tu limite de oficios. Avisa a un DM.");
        return FALSE;
    }

    NWNX_SQL_ReadNextRow();
    int nCurrentLevel = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    int nTrainedCount = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));

    // Existing trained professions may continue progressing. The gate only
    // prevents a level-one profession from becoming a third trained one.
    if (nCurrentLevel >= CNR_TRAINED_PROFESSION_LEVEL
        || nTrainedCount < CNR_MAX_TRAINED_PROFESSIONS)
    {
        return TRUE;
    }

    SendMessageToPC(oPC, "Ya tienes dos oficios de nivel 2 o superior. "
        + "Alquimia no ocupa plaza; no puedes avanzar " + sSkill
        + " a nivel 2.");
    return FALSE;
}

int CnrSkill_SetXP(object oPC, int nSkill, int nXP)
{
    int nCharacterId = PWDB_GetCharacterId(oPC);
    if (nCharacterId <= 0)
    {
        WriteTimestampedLogEntry("[CNR] Refused tradeskill write for "
            + GetName(oPC) + ": no character_id.");
        return FALSE;
    }

    string sSkill = GetSkillName(nSkill - 1);
    if (sSkill == "")
    {
        return FALSE;
    }

    if (!CnrSkill_CanSetXP(oPC, nSkill, nXP))
    {
        return FALSE;
    }

    int nLevel = PersistDetermineTradeskillLevel(nXP);

    // ON DUPLICATE KEY UPDATE, never REPLACE: REPLACE deletes the row first and
    // would fire ON DELETE CASCADE on anything hanging off this table.
    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO cnr_tradeskill (character_id, skill_name, skill_level, skill_xp)"
        + " VALUES (?, ?, ?, ?)"
        + " ON DUPLICATE KEY UPDATE"
        + "   skill_level = VALUES(skill_level),"
        + "   skill_xp    = VALUES(skill_xp)"))
    {
        PrintString("[CNR] Tradeskill prepare failed: " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, nCharacterId);
    NWNX_SQL_PreparedString(1, sSkill);
    NWNX_SQL_PreparedInt(2, nLevel);
    NWNX_SQL_PreparedInt(3, nXP);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[CNR] Tradeskill write failed for " + GetName(oPC)
            + " skill=" + sSkill + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    if (GetIsObjectValid(oContainer))
    {
        SetLocalInt(oContainer, CNR_VAR_XP + IntToString(nSkill), nXP);
        SetLocalInt(oContainer, CNR_VAR_LEVEL + IntToString(nSkill), nLevel);
    }

    return TRUE;
}
