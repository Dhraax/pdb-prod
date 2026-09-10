/// ----------------------------------------------------------------------------
/// @system  PWDB Identity
/// @file    pwdb_i_user
/// @author  Dhraax
/// @brief   Public API for account and character identity persistence.
/// modified by: Dhraax
/// ----------------------------------------------------------------------------

#include "pwdb_i_db"
#include "mti_libreria"
#include "nwnx_admin"
#include "nwnx_events"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Create the identity and access tables and activate the pre-vault gate.
///     Call once from OnModuleLoad.
/// @returns TRUE when the schema and connection subscription are ready.
int PWDB_EnsureIdentitySchema();

/// @brief Register the character and cache its id, booting the player when
///     identity or account and character access policy denies the session.
///     Call from OnClientEnter before any system that persists data.
/// @param oPC Player character that just entered.
/// @returns Positive character_id when the session may persist; otherwise 0.
int PWDB_ResolveCharacterId(object oPC);

/// @brief Synchronize runtime-owned character metadata and panel-granted level
///     unlocks after the legacy login initialization has restored its stores.
/// @param oPC Registered player character whose state must be synchronized.
/// @param iCharacterId Character identifier returned by the early resolver.
void PWDB_SyncRegisteredCharacter(object oPC, int iCharacterId);

/// @brief Whether the most recent identity resolution denied character ownership.
/// @returns TRUE only when the character UUID belongs to another CD key.
int PWDB_WasOwnershipDenied();

/// @brief Whether the most recent identity resolution denied game login.
/// @returns TRUE for identity failure or explicit account/character denial.
int PWDB_WasLoginDenied();

/// @brief Read the cached character_id, resolving it when absent.
/// @param oPC Player character whose identity is required.
/// @returns Positive character_id on success; otherwise 0.
int PWDB_GetCharacterId(object oPC);

/// @brief Whether this session may write persistent data.
/// @param oPC Player character to check.
/// @returns TRUE when a valid character_id is available.
int PWDB_CanPersist(object oPC);

/// @brief Read how many rebuilds remain for a registered character.
/// @param oPC Player character whose persistent identity owns the counter.
/// @returns A non-negative available count, or -1 when identity or SQL fails.
int PWDB_GetRebuildsAvailable(object oPC);

/// @brief Remove the provisional database tree for a replacement character.
/// @param oPC Live replacement character whose cached id must match its UUID
///     and CD key in the database.
/// @returns TRUE only when the database confirmed complete cleanup.
int PWDB_CleanRebuildCharacter(object oPC);

/// @brief Bind the replacement BIC UUID to the character_id in the old container.
/// @param oPC Live replacement character carrying the restored old container.
/// @returns TRUE when ownership, single-use counter consumption, UUID
///     migration, and snapshot refresh succeed.
int PWDB_MigrateRebuiltCharacter(object oPC);

/// @brief Mark the current character deleted while preserving its database tree.
/// @param oPC Player character requesting deletion through the in-game NPC.
/// @returns Positive character_id when the tombstone is stored; otherwise 0.
int PWDB_MarkCharacterDeleted(object oPC);

/// @brief Delete a tombstoned character's server-vault BIC after its warning.
/// @param oPC Player character whose server-vault file will be deleted.
/// @param iCharacterId Persistent tombstone identifier retained for logging.
void PWDB_FinalizeDeletedCharacter(object oPC, int iCharacterId);

/// @brief Apply one database-granted unlock to the BioWare campaign store.
/// @param oPC Registered player character receiving the unlock.
/// @param iUnlockMask Complete database unlock bit mask.
/// @param iExistingMask Unlock bit mask already present in the campaign store.
/// @param iUnlockBit Bit representing this unlock.
/// @param iUnlockLevel Level permitted by this unlock.
/// @param sCampaignVariable Existing DESBLOQUEO campaign variable name.
void PWDB_ApplyLevelUnlock(
    object oPC,
    int iUnlockMask,
    int iExistingMask,
    int iUnlockBit,
    int iUnlockLevel,
    string sCampaignVariable
);

/// @brief Read all existing DESBLOQUEO campaign values for a player.
/// @param oPC Registered player character whose campaign values are read.
/// @returns A bit mask in ascending unlock-level order.
int PWDB_ReadLevelUnlockMask(object oPC);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int PWDB_EnsureIdentitySchema()
{
    NWNX_Events_SubscribeEvent(
        NWNX_ON_CLIENT_CONNECT_BEFORE,
        "pwdb_ev_connect"
    );
    if (!PWDB_DB_EnsureIdentitySchema())
    {
        PrintString("[PWDB:ACCESS] Pre-vault gate is fail-closed after schema setup failed");
        return FALSE;
    }
    PrintString("[PWDB:ACCESS] Pre-vault connection gate active");
    return TRUE;
}

void PWDB_ApplyLevelUnlock(
    object oPC,
    int iUnlockMask,
    int iExistingMask,
    int iUnlockBit,
    int iUnlockLevel,
    string sCampaignVariable
)
{
    if ((iUnlockMask & iUnlockBit) == 0
        || (iExistingMask & iUnlockBit) != 0)
    {
        return;
    }

    SetCampaignInt("DESBLOQUEO", sCampaignVariable, 1, oPC);
    SendMessageToPC(
        oPC,
        ColorTexto(
            "Se te ha asignado el corte que permite subir al nivel "
            + IntToString(iUnlockLevel) + ".",
            TXT_COLOR_VERDE
        )
    );
}

int PWDB_ReadLevelUnlockMask(object oPC)
{
    int iMask = 0;
    if (GetCampaignInt("DESBLOQUEO", "NIVEL9", oPC) != 0)
    {
        iMask = iMask | 1;
    }
    if (GetCampaignInt("DESBLOQUEO", "NIVEL13", oPC) != 0)
    {
        iMask = iMask | 2;
    }
    if (GetCampaignInt("DESBLOQUEO", "NIVEL17", oPC) != 0)
    {
        iMask = iMask | 4;
    }
    if (GetCampaignInt("DESBLOQUEO", "NIVEL21", oPC) != 0)
    {
        iMask = iMask | 8;
    }
    if (GetCampaignInt("DESBLOQUEO", "NIVEL22", oPC) != 0)
    {
        iMask = iMask | 16;
    }
    if (GetCampaignInt("DESBLOQUEO", "NIVEL24", oPC) != 0)
    {
        iMask = iMask | 32;
    }
    if (GetCampaignInt("DESBLOQUEO", "NIVEL26", oPC) != 0)
    {
        iMask = iMask | 64;
    }
    if (GetCampaignInt("DESBLOQUEO", "NIVEL30", oPC) != 0)
    {
        iMask = iMask | 128;
    }
    if (GetCampaignInt("DESBLOQUEO", "NIVEL35", oPC) != 0)
    {
        iMask = iMask | 256;
    }
    return iMask;
}

void PWDB_SyncRegisteredCharacter(object oPC, int iCharacterId)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC) || iCharacterId <= 0
        || GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
        return;
    }

    object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    if (GetIsObjectValid(oContainer))
    {
        // The new-character initializer may have created this container after
        // early identity validation, so cache the already proven id now.
        SetLocalInt(oContainer, PWDB_VAR_CHARACTER_ID, iCharacterId);
    }

    // The creation date travels in the character's own container, which is
    // where the older systems read it from, and the database keeps a copy.
    //
    // A character who already carries it - anyone from before this system -
    // hands it over and the database takes that as the truth. A character who
    // does not gets the date the database has, which for a new one is the login
    // that created its row: the moment it was created. Writing it back means
    // it stops moving, and the scripts that read the container start agreeing
    // with the database instead of finding nothing.
    int iCreationTimestamp = ObtenerIntPersistente(oPC, "PB_FECHA_CREACION");
    if (iCreationTimestamp > 0)
    {
        PWDB_DB_SyncCreationTimestamp(iCharacterId, iCreationTimestamp);
    }
    else if (GetIsObjectValid(oContainer))
    {
        int iStoredTimestamp = PWDB_DB_GetCreationTimestamp(iCharacterId);
        if (iStoredTimestamp > 0)
        {
            GuardarIntPersistente(oPC, "PB_FECHA_CREACION", iStoredTimestamp);
        }
    }

    int iExistingMask = PWDB_ReadLevelUnlockMask(oPC);
    PWDB_DB_RecordLevelUnlockMask(iCharacterId, iExistingMask);
    int iUnlockMask = PWDB_DB_GetLevelUnlockMask(iCharacterId);
    PWDB_ApplyLevelUnlock(oPC, iUnlockMask, iExistingMask, 1, 9, "NIVEL9");
    PWDB_ApplyLevelUnlock(oPC, iUnlockMask, iExistingMask, 2, 13, "NIVEL13");
    PWDB_ApplyLevelUnlock(oPC, iUnlockMask, iExistingMask, 4, 17, "NIVEL17");
    PWDB_ApplyLevelUnlock(oPC, iUnlockMask, iExistingMask, 8, 21, "NIVEL21");
    PWDB_ApplyLevelUnlock(oPC, iUnlockMask, iExistingMask, 16, 22, "NIVEL22");
    PWDB_ApplyLevelUnlock(oPC, iUnlockMask, iExistingMask, 32, 24, "NIVEL24");
    PWDB_ApplyLevelUnlock(oPC, iUnlockMask, iExistingMask, 64, 26, "NIVEL26");
    PWDB_ApplyLevelUnlock(oPC, iUnlockMask, iExistingMask, 128, 30, "NIVEL30");
    PWDB_ApplyLevelUnlock(oPC, iUnlockMask, iExistingMask, 256, 35, "NIVEL35");
}

void PWDB_FinalizeDeletedCharacter(object oPC, int iCharacterId)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC))
    {
        return;
    }

    WriteTimestampedLogEntry("[PWDB] Deleted tombstoned BIC for " + GetName(oPC)
        + " (account " + GetPCPlayerName(oPC) + ", character_id "
        + IntToString(iCharacterId) + ").");
    NWNX_Administration_DeletePlayerCharacter(
        oPC,
        FALSE,
        PWDB_MSG_CHARACTER_DELETED
    );
}

int PWDB_MarkCharacterDeleted(object oPC)
{
    int iCharacterId = PWDB_GetCharacterId(oPC);
    if (iCharacterId <= 0
        || !PWDB_DB_MarkCharacterDeleted(oPC, iCharacterId))
    {
        return 0;
    }
    return iCharacterId;
}

int PWDB_ResolveCharacterId(object oPC)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC))
    {
        return 0;
    }

    // DMs are not registered. They own no persistent character state.
    if (GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
        return 0;
    }

    object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    int iCreationTimestamp = ObtenerIntPersistente(oPC, "PB_FECHA_CREACION");
    string sLegacyCdKey = "";
    if (GetIsObjectValid(oContainer))
    {
        sLegacyCdKey = GetLocalString(oContainer, "CDKEY");
    }

    int nCharacterId = PWDB_DB_ResolveCharacterId(
        oPC,
        iCreationTimestamp,
        sLegacyCdKey
    );

    if (nCharacterId <= 0)
    {
        int iResult = PWDB_DB_GetLastResult();
        string sMessage = PWDB_MSG_VALIDATION_FAILED;
        string sReason = "identity validation failed";

        if (iResult == PWDB_RESULT_CDKEY_DENIED)
        {
            sMessage = PWDB_MSG_CDKEY_MISMATCH;
            sReason = "CD key does not match the registered character owner";
        }
        else if (iResult == PWDB_RESULT_ACCOUNT_DENIED)
        {
            sMessage = PWDB_MSG_ACCOUNT_BLOCKED;
            sReason = "account status denies game login";
        }
        else if (iResult == PWDB_RESULT_CHARACTER_DENIED)
        {
            sMessage = PWDB_MSG_CHARACTER_BLOCKED;
            sReason = "character status denies game login";
        }

        if (iResult == PWDB_RESULT_CHARACTER_DELETED)
        {
            int iCharacterId = PWDB_DB_GetLastCharacterId();
            SendMessageToPC(oPC, PWDB_MSG_CHARACTER_DELETED);
            DelayCommand(
                PWDB_DELETE_DELAY,
                PWDB_FinalizeDeletedCharacter(oPC, iCharacterId)
            );
            WriteTimestampedLogEntry("[PWDB] Scheduled tombstoned BIC deletion for "
                + GetName(oPC) + " (account " + GetPCPlayerName(oPC)
                + ", character_id " + IntToString(iCharacterId) + ").");
            return 0;
        }

        BootPC(oPC, sMessage);
        WriteTimestampedLogEntry("[PWDB] Booted " + GetName(oPC)
            + " (account " + GetPCPlayerName(oPC) + "): " + sReason + ".");
        return 0;
    }

    // Cache on the container. Always overwritten: character_id comes from
    // AUTO_INCREMENT, so a value left over from a previous session may point at
    // a different character after the database is recreated.
    if (GetIsObjectValid(oContainer))
    {
        SetLocalInt(oContainer, PWDB_VAR_CHARACTER_ID, nCharacterId);

        // PWDB has already proven the UUID/account binding. Keep the legacy
        // per-character security value aligned before its later login check.
        // This also completes an administratively confirmed account-key reset
        // for every character container as each character next logs in.
        string sValidatedCdKey = GetPCPublicCDKey(oPC);
        if (sValidatedCdKey != "")
        {
            SetLocalString(oContainer, "CDKEY", sValidatedCdKey);
        }
    }
    else
    {
        WriteTimestampedLogEntry("[PWDB] " + GetName(oPC)
            + " has no " + CONTENEDOR_VARIABLES
            + "; identity resolved but not cached.");
    }

    return nCharacterId;
}

int PWDB_WasOwnershipDenied()
{
    return PWDB_DB_GetLastResult() == PWDB_RESULT_CDKEY_DENIED;
}

int PWDB_WasLoginDenied()
{
    return PWDB_DB_GetLastResult() != PWDB_RESULT_OK;
}

int PWDB_GetCharacterId(object oPC)
{
    if (GetLocalInt(oPC, PWDB_VAR_REBUILD_CLEANED))
    {
        return 0;
    }

    object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);

    if (GetIsObjectValid(oContainer))
    {
        int nCached = GetLocalInt(oContainer, PWDB_VAR_CHARACTER_ID);
        if (nCached > 0)
        {
            return nCached;
        }
    }

    // No container, or no cached value: resolve again. Covers a DM removing the
    // item mid-session and the first read after a failed login.
    return PWDB_ResolveCharacterId(oPC);
}

int PWDB_CanPersist(object oPC)
{
    return PWDB_GetCharacterId(oPC) > 0;
}

int PWDB_GetRebuildsAvailable(object oPC)
{
    int iCharacterId = PWDB_GetCharacterId(oPC);
    if (iCharacterId <= 0)
    {
        return -1;
    }
    return PWDB_DB_GetRebuildsAvailable(iCharacterId);
}

int PWDB_CleanRebuildCharacter(object oPC)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC)
        || GetIsDM(oPC) || GetIsDMPossessed(oPC))
    {
        return FALSE;
    }

    object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    if (!GetIsObjectValid(oContainer))
    {
        return FALSE;
    }

    int iCharacterId = GetLocalInt(oContainer, PWDB_VAR_CHARACTER_ID);
    if (iCharacterId <= 0
        || !PWDB_DB_CleanRebuildCharacter(oPC, iCharacterId))
    {
        return FALSE;
    }

    SetLocalInt(oPC, PWDB_VAR_REBUILD_CLEANED, TRUE);
    return TRUE;
}

int PWDB_MigrateRebuiltCharacter(object oPC)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC)
        || GetIsDM(oPC) || GetIsDMPossessed(oPC)
        || !GetLocalInt(oPC, PWDB_VAR_REBUILD_CLEANED))
    {
        return FALSE;
    }

    object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
    if (!GetIsObjectValid(oContainer))
    {
        return FALSE;
    }

    int iCharacterId = GetLocalInt(oContainer, PWDB_VAR_CHARACTER_ID);
    if (iCharacterId <= 0
        || !PWDB_DB_MigrateRebuiltCharacter(oPC, iCharacterId))
    {
        return FALSE;
    }

    SetLocalInt(oContainer, PWDB_VAR_CHARACTER_ID, iCharacterId);
    DeleteLocalInt(oPC, PWDB_VAR_REBUILD_CLEANED);
    return TRUE;
}
