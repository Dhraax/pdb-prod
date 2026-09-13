/// ----------------------------------------------------------------------------
/// @system  CNR Character Settings
/// @file    cnr_i_setting
/// @author  Dhraax
/// @brief   Character-scoped settings stored in cnr_character_setting.
/// ----------------------------------------------------------------------------

#include "nwnx_sql"
#include "pwdb_i_user"

const string CNR_SETTING_SHOW_ABOVE_LEVEL = "show_above_level";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Read an integer setting for a player character.
/// @param oPC Player character whose setting should be read.
/// @param sSettingName Stable setting key stored in the database.
/// @param nDefault Value returned when no row exists or persistence is unavailable.
/// @returns The stored value, or nDefault when it cannot be read.
int CnrSetting_GetInt(
    object oPC,
    string sSettingName,
    int nDefault = 0
);

/// @brief Store an integer setting for a player character.
/// @param oPC Player character whose setting should be stored.
/// @param sSettingName Stable setting key stored in the database.
/// @param nValue Value to store.
/// @returns TRUE when the row was written; otherwise FALSE.
int CnrSetting_SetInt(
    object oPC,
    string sSettingName,
    int nValue
);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int CnrSetting_GetInt(object oPC, string sSettingName, int nDefault)
{
    int nCharacterId = PWDB_GetCharacterId(oPC);
    if (nCharacterId <= 0 || sSettingName == "")
    {
        return nDefault;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT setting_value FROM cnr_character_setting"
        + " WHERE character_id = ? AND setting_name = ? LIMIT 1"))
    {
        return nDefault;
    }

    NWNX_SQL_PreparedInt(0, nCharacterId);
    NWNX_SQL_PreparedString(1, sSettingName);

    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        return nDefault;
    }

    NWNX_SQL_ReadNextRow();
    return StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
}

int CnrSetting_SetInt(object oPC, string sSettingName, int nValue)
{
    int nCharacterId = PWDB_GetCharacterId(oPC);
    if (nCharacterId <= 0 || sSettingName == "")
    {
        return FALSE;
    }

    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO cnr_character_setting"
        + " (character_id, setting_name, setting_value) VALUES (?, ?, ?)"
        + " ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value)"))
    {
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, nCharacterId);
    NWNX_SQL_PreparedString(1, sSettingName);
    NWNX_SQL_PreparedInt(2, nValue);
    return NWNX_SQL_ExecutePreparedQuery();
}
