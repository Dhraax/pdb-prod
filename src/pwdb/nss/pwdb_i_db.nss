/// ----------------------------------------------------------------------------
/// @system  PWDB Identity
/// @file    pwdb_i_db
/// @author  Dhraax
/// @brief   Internal MySQL persistence for account and character identity.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "pwdb_i_access"

// Resolution outcomes returned by PWDB_DB_ResolveCharacterId through
// PWDB_GetLastResult(). The caller decides what to do with each.
const int PWDB_RESULT_OK           =  1;  // resolved, character_id is valid
const int PWDB_RESULT_CDKEY_DENIED = -1;  // DB or legacy BIC belongs to another key
const int PWDB_RESULT_DB_ERROR     = -2;  // database unreachable or query failed
const int PWDB_RESULT_BAD_INPUT    = -3;  // empty UUID or CD key
const int PWDB_RESULT_ACCOUNT_DENIED   = -4;  // account management status is not active
const int PWDB_RESULT_CHARACTER_DENIED = -5;  // character profile status is not active
const int PWDB_RESULT_CHARACTER_DELETED = -6; // character tombstone denies this UUID/BIC

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Create the account and character identity tables.
/// @returns TRUE when both schema statements succeed; otherwise FALSE.
int PWDB_DB_EnsureIdentitySchema();

/// @brief Register the account and character, then resolve the character_id.
///     Binds strictly: an existing UUID presented with a different CD key is
///     refused instead of being re-parented. A successful resolution captures
///     the initial engine-owned profile and class snapshot when still pending.
/// @param oPC Player character being registered.
/// @param iCreationTimestamp Unix timestamp stored by the character creation
///     system, or zero to use the current database time.
/// @param sLegacyCdKey CD key already stored on the character's established
///     variable container, or empty when the character has none.
/// @returns Positive character_id on success; otherwise 0. Inspect
///     PWDB_DB_GetLastResult() for the reason.
int PWDB_DB_ResolveCharacterId(
    object oPC,
    int iCreationTimestamp,
    string sLegacyCdKey
);

/// @brief Capture the engine-owned profile and class snapshot once.
/// @param oPC Player character whose live engine values are authoritative.
/// @param iCharacterId Resolved persistent character identifier.
/// @returns TRUE when the snapshot was already captured or the initial capture
///     completed; otherwise FALSE. Identity resolution remains valid on failure.
int PWDB_DB_CaptureCharacterSnapshot(object oPC, int iCharacterId);

/// @brief Replace the provisional creation date with the timestamp restored
///     from the character's established variable container.
/// @param iCharacterId Resolved persistent character identifier.
/// @param iCreationTimestamp Positive Unix creation timestamp.
/// @returns TRUE when the timestamp was persisted; otherwise FALSE.
int PWDB_DB_SyncCreationTimestamp(int iCharacterId, int iCreationTimestamp);

/// @brief Read the stored creation date of a registered character.
/// @param iCharacterId Resolved persistent character identifier.
/// @returns created_at as a Unix timestamp, or 0 when it cannot be read.
int PWDB_DB_GetCreationTimestamp(int iCharacterId);

/// @brief Read all panel-granted level unlocks for a registered character.
/// @param iCharacterId Resolved persistent character identifier.
/// @returns A bit mask in ascending unlock-level order, or zero when no unlock
///     is granted or the lookup fails.
int PWDB_DB_GetLevelUnlockMask(int iCharacterId);

/// @brief Read the number of rebuilds still available to a character.
/// @param iCharacterId Resolved persistent character identifier.
/// @returns A non-negative available count, or -1 when the lookup fails.
int PWDB_DB_GetRebuildsAvailable(int iCharacterId);

/// @brief Import and acknowledge BioWare campaign unlocks in MySQL.
/// @param iCharacterId Resolved persistent character identifier.
/// @param iUnlockMask Campaign unlock bit mask confirmed by GetCampaignInt.
/// @returns TRUE when every confirmed grant exists and carries applied_at, or
///     when there was nothing to record; otherwise FALSE.
int PWDB_DB_RecordLevelUnlockMask(int iCharacterId, int iUnlockMask);

/// @brief Capture the first presented CD key during a panel-authorized reset.
/// @param iAccountId Account that owns the known character UUID.
/// @param sCandidateCdKey Public CD key presented by the denied connection.
/// @returns TRUE only when an active request accepted this first candidate.
int PWDB_DB_CaptureCdKeyResetCandidate(int iAccountId, string sCandidateCdKey);

/// @brief Import an unregistered legacy BIC under the key stored in its
///     variable container, while recording the rejected presented key.
/// @param oPC Selected legacy character.
/// @param iCreationTimestamp Stored character creation timestamp, or zero.
/// @param sLegacyCdKey Non-empty key read from the character container.
/// @param sPresentedCdKey Different key presented by the current connection.
/// @returns Positive legacy account_id when the safe import completed;
///     otherwise 0.
int PWDB_DB_ImportLegacyIdentity(
    object oPC,
    int iCreationTimestamp,
    string sLegacyCdKey,
    string sPresentedCdKey
);

/// @brief Turn an owned live character into a persistent deletion tombstone.
/// @param oPC Live character requesting deletion of its own server-vault BIC.
/// @param iCharacterId Persistent character identifier proven for this session.
/// @returns TRUE only when the UUID and CD key still own the updated row.
int PWDB_DB_MarkCharacterDeleted(object oPC, int iCharacterId);

/// @brief Delete the current character tree during an authorized rebuild.
/// @param oPC Live replacement character whose UUID and CD key are verified.
/// @param iCharacterId Cached identifier of the provisional character tree.
/// @returns TRUE only when the owned character row and its tree were deleted.
int PWDB_DB_CleanRebuildCharacter(object oPC, int iCharacterId);

/// @brief Rebind an existing character identity to a replacement BIC UUID.
/// @param oPC Live replacement character providing the new UUID and owner key.
/// @param iCharacterId Existing character identifier read from the old container.
/// @returns TRUE when ownership was verified, one rebuild was consumed for a
///     new UUID binding, and the engine-owned snapshot was refreshed. A retry
///     of an already-bound UUID does not consume another rebuild.
int PWDB_DB_MigrateRebuiltCharacter(object oPC, int iCharacterId);

/// @brief Outcome of the last PWDB_DB_ResolveCharacterId call.
/// @returns One of the PWDB_RESULT_* constants.
int PWDB_DB_GetLastResult();

/// @brief Read the character identifier found by the last resolution attempt.
/// @returns The known character_id, or zero when no character row was found.
int PWDB_DB_GetLastCharacterId();

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

// Module-scoped so the result survives the return into the caller.
const string PWDB_VAR_LAST_RESULT = "PWDB_LAST_RESULT";
const string PWDB_VAR_LAST_CHARACTER_ID = "PWDB_LAST_CHARACTER_ID";

int PWDB_DB_GetLastResult()
{
    return GetLocalInt(GetModule(), PWDB_VAR_LAST_RESULT);
}

int PWDB_DB_GetLastCharacterId()
{
    return GetLocalInt(GetModule(), PWDB_VAR_LAST_CHARACTER_ID);
}

void PWDB_DB_SetLastResult(int nResult)
{
    SetLocalInt(GetModule(), PWDB_VAR_LAST_RESULT, nResult);
}

int PWDB_DB_EnsureIdentitySchema()
{
    string sType = NWNX_SQL_GetDatabaseType();
    if (sType != "MYSQL")
    {
        PrintString("[PWDB:DB] Expected MYSQL, received " + sType);
        return FALSE;
    }

    int bAccount = NWNX_SQL_ExecuteQuery(
        "CREATE TABLE IF NOT EXISTS " + PWDB_TABLE_ACCOUNT + " ("
        + "  account_id  INT         NOT NULL AUTO_INCREMENT,"
        + "  cd_key      VARCHAR(16) NOT NULL,"
        + "  player_name VARCHAR(64) NULL,"
        + "  first_seen  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,"
        + "  last_seen   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP"
        + "                            ON UPDATE CURRENT_TIMESTAMP,"
        + "  PRIMARY KEY (account_id),"
        + "  UNIQUE KEY uq_cd_key (cd_key)"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
    );

    if (!bAccount)
    {
        PrintString("[PWDB:DB] Account schema failed: " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    int bCharacter = NWNX_SQL_ExecuteQuery(
        "CREATE TABLE IF NOT EXISTS " + PWDB_TABLE_CHARACTER + " ("
        + "  character_id   INT         NOT NULL AUTO_INCREMENT,"
        + "  character_uuid CHAR(36)    NOT NULL,"
        + "  account_id     INT         NOT NULL,"
        + "  char_name      VARCHAR(64) NULL,"
        + "  created_at     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,"
        + "  last_login_at  DATETIME    NULL,"
        + "  rebuilds_available SMALLINT UNSIGNED NOT NULL DEFAULT "
        + IntToString(PWDB_DEFAULT_REBUILDS_AVAILABLE) + ","
        + "  rebuilds_completed INT UNSIGNED NOT NULL DEFAULT 0,"
        + "  PRIMARY KEY (character_id),"
        + "  UNIQUE KEY uq_character_uuid (character_uuid),"
        + "  KEY idx_account (account_id),"
        + "  CONSTRAINT fk_character_account"
        + "    FOREIGN KEY (account_id) REFERENCES "
        + PWDB_TABLE_ACCOUNT + "(account_id)"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
    );

    if (!bCharacter)
    {
        PrintString("[PWDB:DB] Character schema failed: " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    if (!PWDB_DB_EnsureAccessSchema())
    {
        return FALSE;
    }

    PrintString("[PWDB:DB] Identity and access schema ready");
    return TRUE;
}

int PWDB_DB_CaptureCharacterSnapshot(object oPC, int iCharacterId)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC) || iCharacterId <= 0)
    {
        return FALSE;
    }

    // Written on every login, not only on the first one. There used to be a
    // check here that returned as soon as the profile had been captured once,
    // and it made the whole function pointless: a character who levelled up,
    // multiclassed, changed deity or had a stat raised kept the sheet of the
    // day they first connected.
    //
    // Everything below is built to run again - the profile upsert, the class
    // rows keyed by slot, the cleanup of slots that no longer exist - and
    // snapshot_captured_at is still only stamped when it is NULL, so the date
    // of the first capture is preserved.

    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_PROFILE
        + " (character_id, race_id, subrace, gender_id, portrait_resref, deity,"
        + " strength_score, dexterity_score, constitution_score,"
        + " intelligence_score, wisdom_score, charisma_score)"
        + " VALUES (?, ?, NULLIF(?, ''), ?, NULLIF(?, ''), NULLIF(?, ''),"
        + " ?, ?, ?, ?, ?, ?)"
        + " ON DUPLICATE KEY UPDATE"
        + "   race_id        = VALUES(race_id),"
        + "   subrace        = VALUES(subrace),"
        + "   gender_id      = VALUES(gender_id),"
        + "   portrait_resref = VALUES(portrait_resref),"
        + "   deity          = VALUES(deity),"
        + "   strength_score = VALUES(strength_score),"
        + "   dexterity_score = VALUES(dexterity_score),"
        + "   constitution_score = VALUES(constitution_score),"
        + "   intelligence_score = VALUES(intelligence_score),"
        + "   wisdom_score   = VALUES(wisdom_score),"
        + "   charisma_score = VALUES(charisma_score)"
    ))
    {
        PrintString("[PWDB:DB] Character snapshot prepare failed for PC="
            + GetName(oPC) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    NWNX_SQL_PreparedInt(1, GetRacialType(oPC));
    NWNX_SQL_PreparedString(2, GetStringLeft(GetSubRace(oPC), 32));
    NWNX_SQL_PreparedInt(3, GetGender(oPC));
    NWNX_SQL_PreparedString(4, GetStringLeft(GetPortraitResRef(oPC), 16));
    NWNX_SQL_PreparedString(5, GetStringLeft(GetDeity(oPC), 64));
    NWNX_SQL_PreparedInt(6, GetAbilityScore(oPC, ABILITY_STRENGTH, TRUE));
    NWNX_SQL_PreparedInt(7, GetAbilityScore(oPC, ABILITY_DEXTERITY, TRUE));
    NWNX_SQL_PreparedInt(8, GetAbilityScore(oPC, ABILITY_CONSTITUTION, TRUE));
    NWNX_SQL_PreparedInt(9, GetAbilityScore(oPC, ABILITY_INTELLIGENCE, TRUE));
    NWNX_SQL_PreparedInt(10, GetAbilityScore(oPC, ABILITY_WISDOM, TRUE));
    NWNX_SQL_PreparedInt(11, GetAbilityScore(oPC, ABILITY_CHARISMA, TRUE));

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Character snapshot update failed for PC="
            + GetName(oPC) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    int iClassSlot;
    int iClassCount = 0;
    for (iClassSlot = 1; iClassSlot <= 3; iClassSlot++)
    {
        int iClassId = GetClassByPosition(iClassSlot, oPC);
        int iClassLevel = GetLevelByPosition(iClassSlot, oPC);
        if (iClassId < 0 || iClassLevel <= 0)
        {
            continue;
        }
        iClassCount++;

        if (!NWNX_SQL_PrepareQuery(
            "INSERT INTO " + PWDB_TABLE_CLASS
            + " (character_id, class_slot, class_id, class_level)"
            + " VALUES (?, ?, ?, ?)"
            + " ON DUPLICATE KEY UPDATE"
            + "   class_id    = VALUES(class_id),"
            + "   class_level = VALUES(class_level)"
        ))
        {
            PrintString("[PWDB:DB] Character class insert prepare failed for PC="
                + GetName(oPC) + " slot=" + IntToString(iClassSlot)
                + ": " + NWNX_SQL_GetLastError());
            return FALSE;
        }

        NWNX_SQL_PreparedInt(0, iCharacterId);
        NWNX_SQL_PreparedInt(1, iClassSlot);
        NWNX_SQL_PreparedInt(2, iClassId);
        NWNX_SQL_PreparedInt(3, iClassLevel);

        if (!NWNX_SQL_ExecutePreparedQuery())
        {
            PrintString("[PWDB:DB] Character class insert failed for PC="
                + GetName(oPC) + " slot=" + IntToString(iClassSlot)
                + " class=" + IntToString(iClassId)
                + ": " + NWNX_SQL_GetLastError());
            return FALSE;
        }
    }

    if (!NWNX_SQL_PrepareQuery(
        "DELETE FROM " + PWDB_TABLE_CLASS
        + " WHERE character_id = ? AND class_slot > ?"
    ))
    {
        PrintString("[PWDB:DB] Stale character class cleanup prepare failed for PC="
            + GetName(oPC) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    NWNX_SQL_PreparedInt(1, iClassCount);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Stale character class cleanup failed for PC="
            + GetName(oPC) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    if (!NWNX_SQL_PrepareQuery(
        "UPDATE " + PWDB_TABLE_PROFILE
        + " SET snapshot_captured_at = CURRENT_TIMESTAMP"
        + " WHERE character_id = ? AND snapshot_captured_at IS NULL"
    ))
    {
        PrintString("[PWDB:DB] Character snapshot marker prepare failed for PC="
            + GetName(oPC) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Character snapshot marker update failed for PC="
            + GetName(oPC) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    return TRUE;
}

int PWDB_DB_SyncCreationTimestamp(int iCharacterId, int iCreationTimestamp)
{
    if (iCharacterId <= 0 || iCreationTimestamp <= 0)
    {
        return FALSE;
    }

    if (!NWNX_SQL_PrepareQuery(
        "UPDATE " + PWDB_TABLE_CHARACTER
        + " SET created_at = FROM_UNIXTIME(?) WHERE character_id = ?"
    ))
    {
        PrintString("[PWDB:DB] Creation timestamp prepare failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCreationTimestamp);
    NWNX_SQL_PreparedInt(1, iCharacterId);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Creation timestamp update failed for character_id="
            + IntToString(iCharacterId) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    return TRUE;
}

int PWDB_DB_GetCreationTimestamp(int iCharacterId)
{
    if (iCharacterId <= 0)
    {
        return 0;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT UNIX_TIMESTAMP(created_at) FROM " + PWDB_TABLE_CHARACTER
        + " WHERE character_id = ? LIMIT 1"
    ))
    {
        PrintString("[PWDB:DB] Creation timestamp read prepare failed: "
            + NWNX_SQL_GetLastError());
        return 0;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        return 0;
    }

    NWNX_SQL_ReadNextRow();
    return StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
}

int PWDB_DB_GetLevelUnlockMask(int iCharacterId)
{
    if (iCharacterId <= 0)
    {
        return 0;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT unlock_level FROM " + PWDB_TABLE_LEVEL_UNLOCK
        + " WHERE character_id = ? ORDER BY unlock_level"
    ))
    {
        PrintString("[PWDB:DB] Level unlock lookup prepare failed: "
            + NWNX_SQL_GetLastError());
        return 0;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Level unlock lookup failed for character_id="
            + IntToString(iCharacterId) + ": " + NWNX_SQL_GetLastError());
        return 0;
    }

    int iMask = 0;
    while (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        int iUnlockLevel = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
        switch (iUnlockLevel)
        {
            case 9:  iMask = iMask | 1;   break;
            case 13: iMask = iMask | 2;   break;
            case 17: iMask = iMask | 4;   break;
            case 21: iMask = iMask | 8;   break;
            case 22: iMask = iMask | 16;  break;
            case 24: iMask = iMask | 32;  break;
            case 26: iMask = iMask | 64;  break;
            case 30: iMask = iMask | 128; break;
            case 35: iMask = iMask | 256; break;
        }
    }

    return iMask;
}

int PWDB_DB_GetRebuildsAvailable(int iCharacterId)
{
    if (iCharacterId <= 0)
    {
        return -1;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT rebuilds_available FROM " + PWDB_TABLE_CHARACTER
        + " WHERE character_id = ? LIMIT 1"
    ))
    {
        PrintString("[PWDB:DB] Rebuild availability prepare failed: "
            + NWNX_SQL_GetLastError());
        return -1;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Rebuild availability lookup failed for character_id="
            + IntToString(iCharacterId) + ": " + NWNX_SQL_GetLastError());
        return -1;
    }

    if (!NWNX_SQL_ReadyToReadNextRow())
    {
        return -1;
    }

    NWNX_SQL_ReadNextRow();
    return StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
}

int PWDB_DB_RecordLevelUnlockMask(int iCharacterId, int iUnlockMask)
{
    if (iCharacterId <= 0)
    {
        return FALSE;
    }
    if (iUnlockMask == 0)
    {
        return TRUE;
    }

    if (!NWNX_SQL_PrepareQuery(
        "INSERT IGNORE INTO " + PWDB_TABLE_LEVEL_UNLOCK
        + " (character_id, unlock_level, applied_at)"
        + " SELECT ?, unlock_level, CURRENT_TIMESTAMP FROM ("
        + " SELECT 9 AS unlock_level, 1 AS unlock_bit"
        + " UNION ALL SELECT 13, 2"
        + " UNION ALL SELECT 17, 4"
        + " UNION ALL SELECT 21, 8"
        + " UNION ALL SELECT 22, 16"
        + " UNION ALL SELECT 24, 32"
        + " UNION ALL SELECT 26, 64"
        + " UNION ALL SELECT 30, 128"
        + " UNION ALL SELECT 35, 256"
        + " ) level_unlocks WHERE (? & unlock_bit) != 0"
    ))
    {
        PrintString("[PWDB:DB] Existing level unlock import prepare failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    NWNX_SQL_PreparedInt(1, iUnlockMask);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Existing level unlock import failed for character_id="
            + IntToString(iCharacterId) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    if (!NWNX_SQL_PrepareQuery(
        "UPDATE " + PWDB_TABLE_LEVEL_UNLOCK
        + " SET applied_at = COALESCE(applied_at, CURRENT_TIMESTAMP)"
        + " WHERE character_id = ?"
        + " AND ((? & CASE unlock_level"
        + "   WHEN 9 THEN 1"
        + "   WHEN 13 THEN 2"
        + "   WHEN 17 THEN 4"
        + "   WHEN 21 THEN 8"
        + "   WHEN 22 THEN 16"
        + "   WHEN 24 THEN 32"
        + "   WHEN 26 THEN 64"
        + "   WHEN 30 THEN 128"
        + "   WHEN 35 THEN 256"
        + "   ELSE 0 END) != 0)"
    ))
    {
        PrintString("[PWDB:DB] Applied level unlock prepare failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    NWNX_SQL_PreparedInt(1, iUnlockMask);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Applied level unlock update failed for character_id="
            + IntToString(iCharacterId) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    return TRUE;
}

int PWDB_DB_MarkCharacterDeleted(object oPC, int iCharacterId)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC) || iCharacterId <= 0)
    {
        return FALSE;
    }

    string sUuid = GetObjectUUID(oPC);
    string sCdKey = GetPCPublicCDKey(oPC);
    if (sUuid == "" || sCdKey == "")
    {
        return FALSE;
    }

    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_PROFILE
        + " (character_id, status, deleted_at, updated_by)"
        + " SELECT c.character_id, 'deleted', CURRENT_TIMESTAMP, NULL"
        + " FROM " + PWDB_TABLE_CHARACTER + " c"
        + " JOIN " + PWDB_TABLE_ACCOUNT + " a ON a.account_id = c.account_id"
        + " WHERE c.character_id = ? AND c.character_uuid = ? AND a.cd_key = ?"
        + " ON DUPLICATE KEY UPDATE status = 'deleted',"
        + " deleted_at = COALESCE(deleted_at, CURRENT_TIMESTAMP),"
        + " updated_by = NULL, updated_at = CURRENT_TIMESTAMP"
    ))
    {
        PrintString("[PWDB:DB] Character tombstone prepare failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    NWNX_SQL_PreparedString(1, sUuid);
    NWNX_SQL_PreparedString(2, sCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Character tombstone update failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    return NWNX_SQL_GetAffectedRows() > 0;
}

int PWDB_DB_CleanRebuildCharacter(object oPC, int iCharacterId)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC) || iCharacterId <= 0)
    {
        return FALSE;
    }

    string sUuid = GetObjectUUID(oPC);
    string sCdKey = GetPCPublicCDKey(oPC);
    if (sUuid == "" || sCdKey == "")
    {
        return FALSE;
    }

    // Revision targets are polymorphic and have no foreign key. Remove only
    // revisions whose target currently matches all three live ownership values.
    // This avoids a privileged database trigger and prevents an unowned cached
    // character_id from deleting another character's audit rows.
    if (!NWNX_SQL_PrepareQuery(
        "DELETE r FROM " + PWDB_TABLE_REVISION + " r"
        + " JOIN " + PWDB_TABLE_CHARACTER + " c"
        + " ON c.character_id = r.target_id"
        + " JOIN " + PWDB_TABLE_ACCOUNT + " a ON a.account_id = c.account_id"
        + " WHERE r.target_type = 'character' AND c.character_id = ?"
        + " AND c.character_uuid = ? AND a.cd_key = ?"
    ))
    {
        PrintString("[PWDB:DB] Rebuild revision cleanup prepare failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    NWNX_SQL_PreparedString(1, sUuid);
    NWNX_SQL_PreparedString(2, sCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Rebuild revision cleanup failed for character_id="
            + IntToString(iCharacterId) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    // Delete only the verified character root. InnoDB removes every FK-owned
    // row through ON DELETE CASCADE.
    if (!NWNX_SQL_PrepareQuery(
        "DELETE FROM " + PWDB_TABLE_CHARACTER
        + " WHERE character_id = ? AND character_uuid = ?"
        + " AND account_id = (SELECT account_id FROM " + PWDB_TABLE_ACCOUNT
        + " WHERE cd_key = ? LIMIT 1)"
    ))
    {
        PrintString("[PWDB:DB] Rebuild cleanup prepare failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    NWNX_SQL_PreparedString(1, sUuid);
    NWNX_SQL_PreparedString(2, sCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Rebuild cleanup failed for character_id="
            + IntToString(iCharacterId) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    if (NWNX_SQL_GetAffectedRows() != 1)
    {
        PrintString("[PWDB:DB] Rebuild cleanup refused: character ownership did not match"
            + " character_id=" + IntToString(iCharacterId));
        return FALSE;
    }

    return TRUE;
}

int PWDB_DB_MigrateRebuiltCharacter(object oPC, int iCharacterId)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC) || iCharacterId <= 0)
    {
        return FALSE;
    }

    string sUuid = GetObjectUUID(oPC);
    string sCdKey = GetPCPublicCDKey(oPC);
    string sName = GetName(oPC, TRUE);
    if (sUuid == "" || sCdKey == "")
    {
        return FALSE;
    }

    // The old character_id is accepted only when it belongs to the same CD key.
    if (!NWNX_SQL_PrepareQuery(
        "SELECT c.character_uuid, c.rebuilds_available"
        + " FROM " + PWDB_TABLE_CHARACTER + " c"
        + " JOIN " + PWDB_TABLE_ACCOUNT + " a ON a.account_id = c.account_id"
        + " LEFT JOIN " + PWDB_TABLE_PROFILE + " p"
        + "   ON p.character_id = c.character_id"
        + " WHERE c.character_id = ? AND a.cd_key = ?"
        + " AND COALESCE(p.status, 'active') = 'active' LIMIT 1"
    ))
    {
        PrintString("[PWDB:DB] Rebuild ownership prepare failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    NWNX_SQL_PreparedString(1, sCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Rebuild ownership lookup failed for character_id="
            + IntToString(iCharacterId) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    if (!NWNX_SQL_ReadyToReadNextRow())
    {
        PrintString("[PWDB:DB] Rebuild migration refused: character_id does not belong"
            + " to the presented CD key character_id=" + IntToString(iCharacterId));
        return FALSE;
    }
    NWNX_SQL_ReadNextRow();
    string sStoredUuid = NWNX_SQL_ReadDataInActiveRow(0);
    int iRebuildsAvailable = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));

    // A retry after the UUID update must not consume a second rebuild. A new
    // UUID migration, however, requires an available use before any mutation.
    if (sStoredUuid != sUuid && iRebuildsAvailable <= 0)
    {
        PrintString("[PWDB:DB] Rebuild migration refused: no rebuilds available"
            + " character_id=" + IntToString(iCharacterId));
        return FALSE;
    }

    // A replacement UUID must not belong to any other character row.
    if (!NWNX_SQL_PrepareQuery(
        "SELECT character_id FROM " + PWDB_TABLE_CHARACTER
        + " WHERE character_uuid = ? AND character_id <> ? LIMIT 1"
    ))
    {
        PrintString("[PWDB:DB] Rebuild UUID conflict prepare failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedString(0, sUuid);
    NWNX_SQL_PreparedInt(1, iCharacterId);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Rebuild UUID conflict lookup failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    if (NWNX_SQL_ReadyToReadNextRow())
    {
        PrintString("[PWDB:DB] Rebuild migration refused: replacement UUID already exists");
        return FALSE;
    }

    if (sStoredUuid != sUuid)
    {
        // Consume exactly one rebuild in the same statement that binds the
        // replacement UUID. A retry sees that UUID and skips this statement.
        if (!NWNX_SQL_PrepareQuery(
            "UPDATE " + PWDB_TABLE_CHARACTER + " c"
            + " JOIN " + PWDB_TABLE_ACCOUNT + " a ON a.account_id = c.account_id"
            + " LEFT JOIN " + PWDB_TABLE_PROFILE + " p"
            + "   ON p.character_id = c.character_id"
            + " SET c.character_uuid = ?, c.char_name = ?,"
            + "   c.last_login_at = CURRENT_TIMESTAMP,"
            + "   c.rebuilds_available = c.rebuilds_available - 1,"
            + "   c.rebuilds_completed = c.rebuilds_completed + 1,"
            + "   p.snapshot_captured_at = NULL"
            + " WHERE c.character_id = ? AND a.cd_key = ?"
            + " AND c.rebuilds_available > 0 AND c.character_uuid <> ?"
        ))
        {
            PrintString("[PWDB:DB] Rebuild migration prepare failed: "
                + NWNX_SQL_GetLastError());
            return FALSE;
        }

        NWNX_SQL_PreparedString(0, sUuid);
        NWNX_SQL_PreparedString(1, sName);
        NWNX_SQL_PreparedInt(2, iCharacterId);
        NWNX_SQL_PreparedString(3, sCdKey);
        NWNX_SQL_PreparedString(4, sUuid);
        if (!NWNX_SQL_ExecutePreparedQuery())
        {
            PrintString("[PWDB:DB] Rebuild migration failed for character_id="
                + IntToString(iCharacterId) + ": " + NWNX_SQL_GetLastError());
            return FALSE;
        }
        if (NWNX_SQL_GetAffectedRows() != 1)
        {
            PrintString("[PWDB:DB] Rebuild migration did not consume exactly one use"
                + " character_id=" + IntToString(iCharacterId));
            return FALSE;
        }
    }

    // Verify the final binding explicitly. This also makes retries safe when a
    // previous attempt rebound the UUID but failed while refreshing the snapshot.
    if (!NWNX_SQL_PrepareQuery(
        "SELECT c.character_id FROM " + PWDB_TABLE_CHARACTER + " c"
        + " JOIN " + PWDB_TABLE_ACCOUNT + " a ON a.account_id = c.account_id"
        + " WHERE c.character_id = ? AND c.character_uuid = ?"
        + " AND a.cd_key = ? LIMIT 1"
    ))
    {
        PrintString("[PWDB:DB] Rebuild verification prepare failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedInt(0, iCharacterId);
    NWNX_SQL_PreparedString(1, sUuid);
    NWNX_SQL_PreparedString(2, sCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Rebuild verification failed for character_id="
            + IntToString(iCharacterId) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    if (!NWNX_SQL_ReadyToReadNextRow())
    {
        PrintString("[PWDB:DB] Rebuild migration was not persisted for character_id="
            + IntToString(iCharacterId));
        return FALSE;
    }
    NWNX_SQL_ReadNextRow();

    if (!PWDB_DB_CaptureCharacterSnapshot(oPC, iCharacterId))
    {
        PrintString("[PWDB:DB] Rebuild identity migrated but snapshot refresh failed"
            + " character_id=" + IntToString(iCharacterId));
        return FALSE;
    }

    return TRUE;
}

int PWDB_DB_CaptureCdKeyResetCandidate(int iAccountId, string sCandidateCdKey)
{
    if (iAccountId <= 0 || sCandidateCdKey == "")
    {
        return FALSE;
    }

    // The first candidate wins and the request must still be pending and
    // unexpired. A key already owned by another account is never captured.
    if (!NWNX_SQL_PrepareQuery(
        "UPDATE " + PWDB_TABLE_ACCOUNT_CDKEY_RESET
        + " SET candidate_cd_key = ?, candidate_captured_at = CURRENT_TIMESTAMP"
        + " WHERE account_id = ? AND candidate_cd_key IS NULL"
        + " AND confirmed_at IS NULL AND expires_at > CURRENT_TIMESTAMP"
        + " AND NOT EXISTS (SELECT 1 FROM " + PWDB_TABLE_ACCOUNT
        + " WHERE cd_key = ?)"
    ))
    {
        PrintString("[PWDB:DB] CD-key candidate capture prepare failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    NWNX_SQL_PreparedString(0, sCandidateCdKey);
    NWNX_SQL_PreparedInt(1, iAccountId);
    NWNX_SQL_PreparedString(2, sCandidateCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] CD-key candidate capture failed for account_id="
            + IntToString(iAccountId) + ": " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    return NWNX_SQL_GetAffectedRows() == 1;
}

int PWDB_DB_ImportLegacyIdentity(
    object oPC,
    int iCreationTimestamp,
    string sLegacyCdKey,
    string sPresentedCdKey
)
{
    string sUuid = GetObjectUUID(oPC);
    string sPlayer = GetStringLeft(GetPCPlayerName(oPC), 64);
    string sName = GetStringLeft(GetName(oPC), 64);
    string sIpAddress = GetStringLeft(GetPCIPAddress(oPC), 45);
    sLegacyCdKey = GetStringLeft(sLegacyCdKey, 16);
    sPresentedCdKey = GetStringLeft(sPresentedCdKey, 16);

    if (sUuid == "" || sLegacyCdKey == "" || sPresentedCdKey == ""
        || sLegacyCdKey == sPresentedCdKey)
    {
        return 0;
    }

    // Establish ownership from the value already serialized in the server BIC,
    // never from the rejected connection key. Existing account labels are not
    // overwritten by this denied attempt.
    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_ACCOUNT + " (cd_key, player_name)"
        + " VALUES (?, ?)"
        + " ON DUPLICATE KEY UPDATE"
        + " player_name = COALESCE(NULLIF(player_name, ''), VALUES(player_name))"
    ))
    {
        return 0;
    }
    NWNX_SQL_PreparedString(0, sLegacyCdKey);
    NWNX_SQL_PreparedString(1, sPlayer);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return 0;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT account_id FROM " + PWDB_TABLE_ACCOUNT
        + " WHERE cd_key = ? LIMIT 1"
    ))
    {
        return 0;
    }
    NWNX_SQL_PreparedString(0, sLegacyCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        return 0;
    }
    NWNX_SQL_ReadNextRow();
    int iAccountId = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    if (iAccountId <= 0)
    {
        return 0;
    }

    // The denied attempt may import the BIC identity, but it is assigned only
    // to the container's legacy owner and is not counted as a successful login.
    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_CHARACTER
        + " (character_uuid, account_id, char_name, created_at, last_login_at)"
        + " SELECT ?, account_id, ?,"
        + " COALESCE(FROM_UNIXTIME(NULLIF(?, 0)), CURRENT_TIMESTAMP), NULL"
        + " FROM " + PWDB_TABLE_ACCOUNT + " WHERE cd_key = ?"
        + " ON DUPLICATE KEY UPDATE character_uuid = character_uuid"
    ))
    {
        return 0;
    }
    NWNX_SQL_PreparedString(0, sUuid);
    NWNX_SQL_PreparedString(1, sName);
    NWNX_SQL_PreparedInt(2, iCreationTimestamp);
    NWNX_SQL_PreparedString(3, sLegacyCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return 0;
    }

    // Confirm that a concurrent registration did not bind this UUID elsewhere.
    if (!NWNX_SQL_PrepareQuery(
        "SELECT a.cd_key FROM " + PWDB_TABLE_CHARACTER + " c"
        + " JOIN " + PWDB_TABLE_ACCOUNT + " a ON a.account_id = c.account_id"
        + " WHERE c.character_uuid = ? LIMIT 1"
    ))
    {
        return 0;
    }
    NWNX_SQL_PreparedString(0, sUuid);
    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        return 0;
    }
    NWNX_SQL_ReadNextRow();
    if (NWNX_SQL_ReadDataInActiveRow(0) != sLegacyCdKey)
    {
        return 0;
    }

    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_ACCOUNT_NAME_HISTORY
        + " (account_id, player_name, verified_count) VALUES (?, ?, 0)"
        + " ON DUPLICATE KEY UPDATE last_seen_at = CURRENT_TIMESTAMP"
    ))
    {
        return 0;
    }
    NWNX_SQL_PreparedInt(0, iAccountId);
    NWNX_SQL_PreparedString(1, sPlayer);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return 0;
    }

    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_ACCOUNT_CDKEY_HISTORY
        + " (account_id, cd_key, attempt_count, verified_count, last_player_name)"
        + " VALUES (?, ?, 0, 0, ?)"
        + " ON DUPLICATE KEY UPDATE last_player_name = VALUES(last_player_name)"
    ))
    {
        return 0;
    }
    NWNX_SQL_PreparedInt(0, iAccountId);
    NWNX_SQL_PreparedString(1, sLegacyCdKey);
    NWNX_SQL_PreparedString(2, sPlayer);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return 0;
    }

    if (!PWDB_AccessRecordAttempt(
        iAccountId,
        sPlayer,
        sPresentedCdKey,
        sIpAddress
    ))
    {
        return 0;
    }

    // An account that already existed may already have an authorized reset
    // window. A freshly imported account can open one in the panel and capture
    // the same key on the next coordinated attempt.
    PWDB_DB_CaptureCdKeyResetCandidate(iAccountId, sPresentedCdKey);
    return iAccountId;
}

int PWDB_DB_ResolveCharacterId(
    object oPC,
    int iCreationTimestamp,
    string sLegacyCdKey
)
{
    PWDB_DB_SetLastResult(PWDB_RESULT_BAD_INPUT);
    SetLocalInt(GetModule(), PWDB_VAR_LAST_CHARACTER_ID, 0);

    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC))
    {
        return 0;
    }

    string sUuid   = GetObjectUUID(oPC);
    string sCdKey  = GetPCPublicCDKey(oPC);
    string sPlayer = GetPCPlayerName(oPC);
    string sName   = GetName(oPC);

    if (sUuid == "" || sCdKey == "")
    {
        PrintString("[PWDB:DB] Empty UUID or CD key for PC=" + sName);
        return 0;
    }

    // -------------------------------------------------------------------------
    // Step 1: is this UUID already registered, to which CD key, and is this
    // character allowed to enter?
    // Runs before identity writes. A mismatch may only fill the first candidate
    // of an already-authorized reset request; it never changes account ownership.
    // -------------------------------------------------------------------------
    if (!NWNX_SQL_PrepareQuery(
        "SELECT a.cd_key, c.character_id, COALESCE(p.status, 'active'), a.account_id"
        + " FROM " + PWDB_TABLE_CHARACTER + " c"
        + " JOIN " + PWDB_TABLE_ACCOUNT + " a ON a.account_id = c.account_id"
        + " LEFT JOIN " + PWDB_TABLE_PROFILE + " p"
        + "   ON p.character_id = c.character_id"
        + " WHERE c.character_uuid = ? LIMIT 1"
    ))
    {
        PrintString("[PWDB:DB] Owner lookup prepare failed: " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    NWNX_SQL_PreparedString(0, sUuid);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Owner lookup failed for PC=" + sName
            + ": " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    int bKnown = FALSE;
    string sOwnerCdKey = "";
    int nExistingId = 0;
    int iExistingAccountId = 0;
    string sCharacterStatus = "active";

    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        sOwnerCdKey = NWNX_SQL_ReadDataInActiveRow(0);
        nExistingId = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
        SetLocalInt(GetModule(), PWDB_VAR_LAST_CHARACTER_ID, nExistingId);
        sCharacterStatus = NWNX_SQL_ReadDataInActiveRow(2);
        iExistingAccountId = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
        bKnown = TRUE;
    }

    // Known character presented under a different CD key: refuse.
    if (bKnown && sOwnerCdKey != sCdKey)
    {
        if (PWDB_DB_CaptureCdKeyResetCandidate(iExistingAccountId, sCdKey))
        {
            PrintString("[PWDB:DB] Captured panel-authorized CD-key candidate"
                + " account_id=" + IntToString(iExistingAccountId)
                + " candidate=" + GetStringLeft(sCdKey, 4) + "*");
        }
        PrintString("[PWDB:DB] CD key mismatch for PC=" + sName
            + " uuid=" + sUuid + " registered_to=" + GetStringLeft(sOwnerCdKey, 4)
            + "* presented=" + GetStringLeft(sCdKey, 4) + "*");
        PWDB_DB_SetLastResult(PWDB_RESULT_CDKEY_DENIED);
        return 0;
    }

    // A legacy BIC may reach this server before its account and UUID have been
    // imported into PWDB. Its established container key is the only ownership
    // evidence available at that point and must be checked before either
    // account or character INSERT can trust the presented key. Once the UUID
    // is known, the database is authoritative so an administrator-confirmed
    // key change can replace the stale container value after validation.
    sLegacyCdKey = GetStringLeft(sLegacyCdKey, 16);
    if (!bKnown && sLegacyCdKey != "" && sLegacyCdKey != sCdKey)
    {
        int iImportedAccountId = PWDB_DB_ImportLegacyIdentity(
            oPC,
            iCreationTimestamp,
            sLegacyCdKey,
            sCdKey
        );
        PrintString("[PWDB:DB] Legacy container CD key mismatch for PC=" + sName
            + " uuid=" + sUuid + " stored=" + GetStringLeft(sLegacyCdKey, 4)
            + "* presented=" + GetStringLeft(sCdKey, 4) + "* imported_account="
            + IntToString(iImportedAccountId));
        PWDB_DB_SetLastResult(PWDB_RESULT_CDKEY_DENIED);
        return 0;
    }

    // Ownership is checked first so deletion status cannot be probed with an
    // unrelated CD key.
    if (bKnown && sCharacterStatus == "deleted")
    {
        PrintString("[PWDB:DB] Character deletion requested for PC=" + sName
            + " character_id=" + IntToString(nExistingId));
        PWDB_DB_SetLastResult(PWDB_RESULT_CHARACTER_DELETED);
        return 0;
    }

    // Any remaining non-active character status blocks only this character.
    if (bKnown && sCharacterStatus != "active")
    {
        PrintString("[PWDB:DB] Character access denied for PC=" + sName
            + " character_id=" + IntToString(nExistingId)
            + " status=" + sCharacterStatus);
        PWDB_DB_SetLastResult(PWDB_RESULT_CHARACTER_DENIED);
        return 0;
    }

    // Check the presented account independently from the character UUID. This
    // also prevents a blocked account from entering with a newly created PC.
    if (!NWNX_SQL_PrepareQuery(
        "SELECT COALESCE(m.status, 'active')"
        + " FROM " + PWDB_TABLE_ACCOUNT + " a"
        + " LEFT JOIN " + PWDB_TABLE_ACCOUNT_MANAGEMENT + " m"
        + "   ON m.account_id = a.account_id"
        + " WHERE a.cd_key = ? LIMIT 1"
    ))
    {
        PrintString("[PWDB:DB] Account access prepare failed: " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    NWNX_SQL_PreparedString(0, sCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Account access lookup failed for PC=" + sName
            + ": " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        string sAccountStatus = NWNX_SQL_ReadDataInActiveRow(0);
        if (sAccountStatus != "active")
        {
            PrintString("[PWDB:DB] Account access denied for PC=" + sName
                + " status=" + sAccountStatus);
            PWDB_DB_SetLastResult(PWDB_RESULT_ACCOUNT_DENIED);
            return 0;
        }
    }

    // -------------------------------------------------------------------------
    // Step 2: upsert the account row.
    // -------------------------------------------------------------------------
    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_ACCOUNT + " (cd_key, player_name)"
        + " VALUES (?, ?)"
        + " ON DUPLICATE KEY UPDATE"
        + "   player_name = VALUES(player_name),"
        + "   last_seen   = CURRENT_TIMESTAMP"
    ))
    {
        PrintString("[PWDB:DB] Account prepare failed: " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    NWNX_SQL_PreparedString(0, sCdKey);
    NWNX_SQL_PreparedString(1, sPlayer);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Account registration failed for PC=" + sName
            + ": " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    // -------------------------------------------------------------------------
    // Step 3: upsert the character row. Account ownership and the observed
    // name are set on insert only. A normal login must not rename a persistent
    // identity; only the controlled rebuild migration can do that.
    // -------------------------------------------------------------------------
    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_CHARACTER
        + " (character_uuid, account_id, char_name, created_at, last_login_at)"
        + " SELECT ?, account_id, ?,"
        + " COALESCE(FROM_UNIXTIME(NULLIF(?, 0)), CURRENT_TIMESTAMP),"
        + " CURRENT_TIMESTAMP"
        + "   FROM " + PWDB_TABLE_ACCOUNT + " WHERE cd_key = ?"
        + " ON DUPLICATE KEY UPDATE"
        + "   created_at    = LEAST(created_at, VALUES(created_at)),"
        + "   last_login_at = CURRENT_TIMESTAMP"
    ))
    {
        PrintString("[PWDB:DB] Character prepare failed: " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    NWNX_SQL_PreparedString(0, sUuid);
    NWNX_SQL_PreparedString(1, sName);
    NWNX_SQL_PreparedInt(2, iCreationTimestamp);
    NWNX_SQL_PreparedString(3, sCdKey);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Character registration failed for PC=" + sName
            + ": " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    // -------------------------------------------------------------------------
    // Step 4: read the id back. Bound by UUID and CD key together, so the
    // returned row is proven to belong to the connecting account.
    // LAST_INSERT_ID() is not used: NWNX_SQL gives no guarantee that the next
    // call reuses the same MySQL connection.
    // -------------------------------------------------------------------------
    if (!NWNX_SQL_PrepareQuery(
        "SELECT c.character_id"
        + " FROM " + PWDB_TABLE_CHARACTER + " c"
        + " JOIN " + PWDB_TABLE_ACCOUNT + " a ON a.account_id = c.account_id"
        + " WHERE c.character_uuid = ? AND a.cd_key = ? LIMIT 1"
    ))
    {
        PrintString("[PWDB:DB] Identity lookup prepare failed: " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    NWNX_SQL_PreparedString(0, sUuid);
    NWNX_SQL_PreparedString(1, sCdKey);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Identity lookup failed for PC=" + sName
            + ": " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    int nCharacterId = 0;
    if (NWNX_SQL_ReadyToReadNextRow())
    {
        NWNX_SQL_ReadNextRow();
        nCharacterId = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    }

    if (nCharacterId <= 0)
    {
        PrintString("[PWDB:DB] No character_id resolved for PC=" + sName);
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    SetLocalInt(GetModule(), PWDB_VAR_LAST_CHARACTER_ID, nCharacterId);

    if (!PWDB_DB_CaptureCharacterSnapshot(oPC, nCharacterId))
    {
        PrintString("[PWDB:DB] Identity resolved without an initial character snapshot for PC="
            + sName + " character_id=" + IntToString(nCharacterId));
    }

    if (!PWDB_AccessRecordVerified(oPC))
    {
        PrintString("[PWDB:DB] Verified access history failed for PC=" + sName
            + ": " + NWNX_SQL_GetLastError());
        PWDB_DB_SetLastResult(PWDB_RESULT_DB_ERROR);
        return 0;
    }

    PWDB_DB_SetLastResult(PWDB_RESULT_OK);
    return nCharacterId;
}
