/// ----------------------------------------------------------------------------
/// @system  PWDB Identity
/// @file    pwdb_i_access
/// @author  Dhraax
/// @brief   Pre-vault account access policy and aggregated connection history.
/// ----------------------------------------------------------------------------

#include "nwnx_sql"
#include "pwdb_c_config"

const int PWDB_ACCESS_ALLOWED          =  1;
const int PWDB_ACCESS_BANNED           = -1;
const int PWDB_ACCESS_ACCOUNT_BLOCKED  = -2;
const int PWDB_ACCESS_NAME_MISMATCH    = -3;
const int PWDB_ACCESS_AMBIGUOUS_NAME   = -4;
const int PWDB_ACCESS_DB_ERROR         = -5;

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Create and backfill the access-history and CD-key-ban tables.
/// @returns TRUE when every table and baseline row is ready.
int PWDB_DB_EnsureAccessSchema();

/// @brief Aggregate one pre-vault key and IP observation for a known account.
/// @param iAccountId Unambiguous account selected by the protected name.
/// @param sPlayerName Community name presented by the client.
/// @param sCdKey Public CD key presented by the client.
/// @param sIpAddress Network address reported by NWNX Events.
/// @returns TRUE when both applicable history rows were updated.
int PWDB_AccessRecordAttempt(
    int iAccountId,
    string sPlayerName,
    string sCdKey,
    string sIpAddress
);

/// @brief Validate one connection before the engine sends the character list.
///     The check is fail-closed on SQL errors and records attempted keys and IPs
///     against an unambiguous protected account name.
/// @param sPlayerName Community name presented by the connecting client.
/// @param sCdKey Public CD key presented by the connecting client.
/// @param sIpAddress Network address reported by NWNX Events.
/// @param bIsDm TRUE for a DM-client connection.
/// @returns One PWDB_ACCESS_* result.
int PWDB_AccessCheckConnection(
    string sPlayerName,
    string sCdKey,
    string sIpAddress,
    int bIsDm
);

/// @brief Record a connection after character ownership has been verified.
/// @param oPC Player character whose account has passed PWDB identity checks.
/// @returns TRUE when all aggregated observations were updated.
int PWDB_AccessRecordVerified(object oPC);

/// @brief Map a denied pre-vault result to player-facing text.
/// @param iResult One PWDB_ACCESS_* result.
/// @returns Safe disconnect reason for the connecting client.
string PWDB_AccessDenialMessage(int iResult);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int PWDB_DB_EnsureAccessSchema()
{
    int bNames = NWNX_SQL_ExecuteQuery(
        "CREATE TABLE IF NOT EXISTS " + PWDB_TABLE_ACCOUNT_NAME_HISTORY + " ("
        + " account_id INT NOT NULL,"
        + " player_name VARCHAR(64) NOT NULL,"
        + " first_seen_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,"
        + " last_seen_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,"
        + " verified_count BIGINT NOT NULL DEFAULT 0,"
        + " PRIMARY KEY (account_id, player_name),"
        + " KEY ix_account_name_history_name (player_name),"
        + " FOREIGN KEY (account_id) REFERENCES " + PWDB_TABLE_ACCOUNT
        + "(account_id) ON DELETE CASCADE"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
    );
    int bKeys = NWNX_SQL_ExecuteQuery(
        "CREATE TABLE IF NOT EXISTS " + PWDB_TABLE_ACCOUNT_CDKEY_HISTORY + " ("
        + " account_id INT NOT NULL,"
        + " cd_key VARCHAR(16) NOT NULL,"
        + " first_seen_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,"
        + " last_seen_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,"
        + " attempt_count BIGINT NOT NULL DEFAULT 0,"
        + " verified_count BIGINT NOT NULL DEFAULT 0,"
        + " last_player_name VARCHAR(64) NULL,"
        + " PRIMARY KEY (account_id, cd_key),"
        + " KEY ix_account_cd_key_history_key (cd_key),"
        + " FOREIGN KEY (account_id) REFERENCES " + PWDB_TABLE_ACCOUNT
        + "(account_id) ON DELETE CASCADE"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
    );
    int bIps = NWNX_SQL_ExecuteQuery(
        "CREATE TABLE IF NOT EXISTS " + PWDB_TABLE_ACCOUNT_IP_HISTORY + " ("
        + " account_id INT NOT NULL,"
        + " ip_address VARCHAR(45) NOT NULL,"
        + " first_seen_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,"
        + " last_seen_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,"
        + " attempt_count BIGINT NOT NULL DEFAULT 0,"
        + " verified_count BIGINT NOT NULL DEFAULT 0,"
        + " PRIMARY KEY (account_id, ip_address),"
        + " KEY ix_account_ip_history_address (ip_address),"
        + " FOREIGN KEY (account_id) REFERENCES " + PWDB_TABLE_ACCOUNT
        + "(account_id) ON DELETE CASCADE"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
    );
    int bBans = NWNX_SQL_ExecuteQuery(
        "CREATE TABLE IF NOT EXISTS " + PWDB_TABLE_CDKEY_BAN + " ("
        + " cd_key VARCHAR(16) NOT NULL,"
        + " active BOOLEAN NOT NULL DEFAULT TRUE,"
        + " reason VARCHAR(500) NULL,"
        + " banned_at DATETIME NOT NULL,"
        + " unbanned_at DATETIME NULL,"
        + " updated_at DATETIME NOT NULL,"
        + " PRIMARY KEY (cd_key),"
        + " KEY ix_cd_key_ban_active (active)"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
    );

    if (!bNames || !bKeys || !bIps || !bBans)
    {
        PrintString("[PWDB:ACCESS] Access schema failed: " + NWNX_SQL_GetLastError());
        return FALSE;
    }

    int bBackfillNames = NWNX_SQL_ExecuteQuery(
        "INSERT IGNORE INTO " + PWDB_TABLE_ACCOUNT_NAME_HISTORY
        + " (account_id, player_name, first_seen_at, last_seen_at, verified_count)"
        + " SELECT account_id, player_name, first_seen, last_seen, 1"
        + " FROM " + PWDB_TABLE_ACCOUNT
        + " WHERE player_name IS NOT NULL AND player_name <> ''"
    );
    int bBackfillKeys = NWNX_SQL_ExecuteQuery(
        "INSERT IGNORE INTO " + PWDB_TABLE_ACCOUNT_CDKEY_HISTORY
        + " (account_id, cd_key, first_seen_at, last_seen_at, attempt_count,"
        + " verified_count, last_player_name)"
        + " SELECT account_id, cd_key, first_seen, last_seen, 1, 1, player_name"
        + " FROM " + PWDB_TABLE_ACCOUNT
    );
    if (!bBackfillNames || !bBackfillKeys)
    {
        PrintString("[PWDB:ACCESS] Access-history backfill failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }
    return TRUE;
}

int PWDB_AccessRecordAttempt(
    int iAccountId,
    string sPlayerName,
    string sCdKey,
    string sIpAddress
)
{
    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_ACCOUNT_CDKEY_HISTORY
        + " (account_id, cd_key, attempt_count, verified_count, last_player_name)"
        + " VALUES (?, ?, 1, 0, ?)"
        + " ON DUPLICATE KEY UPDATE last_seen_at = CURRENT_TIMESTAMP,"
        + " attempt_count = attempt_count + 1,"
        + " last_player_name = VALUES(last_player_name)"
    ))
    {
        return FALSE;
    }
    NWNX_SQL_PreparedInt(0, iAccountId);
    NWNX_SQL_PreparedString(1, sCdKey);
    NWNX_SQL_PreparedString(2, sPlayerName);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return FALSE;
    }

    if (sIpAddress == "")
    {
        return TRUE;
    }
    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_ACCOUNT_IP_HISTORY
        + " (account_id, ip_address, attempt_count, verified_count)"
        + " VALUES (?, ?, 1, 0)"
        + " ON DUPLICATE KEY UPDATE last_seen_at = CURRENT_TIMESTAMP,"
        + " attempt_count = attempt_count + 1"
    ))
    {
        return FALSE;
    }
    NWNX_SQL_PreparedInt(0, iAccountId);
    NWNX_SQL_PreparedString(1, sIpAddress);
    return NWNX_SQL_ExecutePreparedQuery();
}

int PWDB_AccessCheckConnection(
    string sPlayerName,
    string sCdKey,
    string sIpAddress,
    int bIsDm
)
{
    sPlayerName = GetStringLeft(sPlayerName, 64);
    sCdKey = GetStringLeft(sCdKey, 16);
    sIpAddress = GetStringLeft(sIpAddress, 45);
    if (sCdKey == "")
    {
        return PWDB_ACCESS_DB_ERROR;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT COUNT(*) FROM " + PWDB_TABLE_CDKEY_BAN
        + " WHERE cd_key = ? AND active = TRUE"
    ))
    {
        return PWDB_ACCESS_DB_ERROR;
    }
    NWNX_SQL_PreparedString(0, sCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        return PWDB_ACCESS_DB_ERROR;
    }
    NWNX_SQL_ReadNextRow();
    int bBanned = StringToInt(NWNX_SQL_ReadDataInActiveRow(0)) > 0;

    if (bIsDm)
    {
        return bBanned ? PWDB_ACCESS_BANNED : PWDB_ACCESS_ALLOWED;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT COUNT(*),"
        + " COALESCE(SUM(a.cd_key = ?), 0),"
        + " COALESCE(SUM(COALESCE(m.status, 'active') <> 'active'), 0),"
        + " COALESCE(SUM(r.confirmed_at IS NULL"
        + "   AND r.expires_at > CURRENT_TIMESTAMP), 0),"
        + " COALESCE(MIN(a.account_id), 0)"
        + " FROM " + PWDB_TABLE_ACCOUNT_NAME_HISTORY + " n"
        + " JOIN " + PWDB_TABLE_ACCOUNT + " a ON a.account_id = n.account_id"
        + " LEFT JOIN " + PWDB_TABLE_ACCOUNT_MANAGEMENT + " m"
        + "   ON m.account_id = a.account_id"
        + " LEFT JOIN " + PWDB_TABLE_ACCOUNT_CDKEY_RESET + " r"
        + "   ON r.account_id = a.account_id"
        + " WHERE n.player_name = ?"
    ))
    {
        return PWDB_ACCESS_DB_ERROR;
    }
    NWNX_SQL_PreparedString(0, sCdKey);
    NWNX_SQL_PreparedString(1, sPlayerName);
    if (!NWNX_SQL_ExecutePreparedQuery() || !NWNX_SQL_ReadyToReadNextRow())
    {
        return PWDB_ACCESS_DB_ERROR;
    }
    NWNX_SQL_ReadNextRow();
    int iNameAccounts = StringToInt(NWNX_SQL_ReadDataInActiveRow(0));
    int iMatchingKeys = StringToInt(NWNX_SQL_ReadDataInActiveRow(1));
    int iBlockedAccounts = StringToInt(NWNX_SQL_ReadDataInActiveRow(2));
    int iActiveResets = StringToInt(NWNX_SQL_ReadDataInActiveRow(3));
    int iAccountId = StringToInt(NWNX_SQL_ReadDataInActiveRow(4));

    if (iNameAccounts == 1
        && !PWDB_AccessRecordAttempt(iAccountId, sPlayerName, sCdKey, sIpAddress))
    {
        PrintString("[PWDB:ACCESS] Attempt history failed for account_id="
            + IntToString(iAccountId) + ": " + NWNX_SQL_GetLastError());
        return PWDB_ACCESS_DB_ERROR;
    }
    if (bBanned)
    {
        return PWDB_ACCESS_BANNED;
    }
    if (iNameAccounts > 1)
    {
        return PWDB_ACCESS_AMBIGUOUS_NAME;
    }
    if (iNameAccounts == 0)
    {
        return PWDB_ACCESS_ALLOWED;
    }
    if (iBlockedAccounts > 0)
    {
        return PWDB_ACCESS_ACCOUNT_BLOCKED;
    }
    if (iMatchingKeys == 0 && iActiveResets == 0)
    {
        return PWDB_ACCESS_NAME_MISMATCH;
    }
    return PWDB_ACCESS_ALLOWED;
}

int PWDB_AccessRecordVerified(object oPC)
{
    string sPlayerName = GetStringLeft(GetPCPlayerName(oPC), 64);
    string sCdKey = GetStringLeft(GetPCPublicCDKey(oPC), 16);
    string sIpAddress = GetStringLeft(GetPCIPAddress(oPC), 45);

    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_ACCOUNT_NAME_HISTORY
        + " (account_id, player_name, verified_count)"
        + " SELECT account_id, ?, 1 FROM " + PWDB_TABLE_ACCOUNT
        + " WHERE cd_key = ?"
        + " ON DUPLICATE KEY UPDATE last_seen_at = CURRENT_TIMESTAMP,"
        + " verified_count = verified_count + 1"
    ))
    {
        return FALSE;
    }
    NWNX_SQL_PreparedString(0, sPlayerName);
    NWNX_SQL_PreparedString(1, sCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return FALSE;
    }

    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_ACCOUNT_CDKEY_HISTORY
        + " (account_id, cd_key, attempt_count, verified_count, last_player_name)"
        + " SELECT account_id, ?, 0, 1, ? FROM " + PWDB_TABLE_ACCOUNT
        + " WHERE cd_key = ?"
        + " ON DUPLICATE KEY UPDATE last_seen_at = CURRENT_TIMESTAMP,"
        + " verified_count = verified_count + 1,"
        + " last_player_name = VALUES(last_player_name)"
    ))
    {
        return FALSE;
    }
    NWNX_SQL_PreparedString(0, sCdKey);
    NWNX_SQL_PreparedString(1, sPlayerName);
    NWNX_SQL_PreparedString(2, sCdKey);
    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        return FALSE;
    }

    if (sIpAddress == "")
    {
        return TRUE;
    }
    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_ACCOUNT_IP_HISTORY
        + " (account_id, ip_address, attempt_count, verified_count)"
        + " SELECT account_id, ?, 0, 1 FROM " + PWDB_TABLE_ACCOUNT
        + " WHERE cd_key = ?"
        + " ON DUPLICATE KEY UPDATE last_seen_at = CURRENT_TIMESTAMP,"
        + " verified_count = verified_count + 1"
    ))
    {
        return FALSE;
    }
    NWNX_SQL_PreparedString(0, sIpAddress);
    NWNX_SQL_PreparedString(1, sCdKey);
    return NWNX_SQL_ExecutePreparedQuery();
}

string PWDB_AccessDenialMessage(int iResult)
{
    if (iResult == PWDB_ACCESS_BANNED)
    {
        return PWDB_MSG_CDKEY_BANNED;
    }
    if (iResult == PWDB_ACCESS_ACCOUNT_BLOCKED)
    {
        return PWDB_MSG_ACCOUNT_BLOCKED;
    }
    if (iResult == PWDB_ACCESS_NAME_MISMATCH)
    {
        return PWDB_MSG_ACCOUNT_NAME_MISMATCH;
    }
    if (iResult == PWDB_ACCESS_AMBIGUOUS_NAME)
    {
        return PWDB_MSG_ACCOUNT_NAME_AMBIGUOUS;
    }
    return PWDB_MSG_VALIDATION_FAILED;
}
