# PWDB Identity Bootstrap And Porting Guide

## 1. Purpose

This document is a self-contained implementation guide for adding persistent
account and character registration to another Neverwinter Nights: Enhanced
Edition module for the first time.

It extracts only the reusable identity foundation from Underworld PWDB:

- one account row per public CD key;
- one character row per engine-assigned character UUID;
- an account-to-character relationship;
- one integer `character_id` cached for the current login session;
- MySQL persistence through NWNX_SQL;
- Docker Compose configuration for MySQL and NWNX:EE;
- schema creation during module load;
- idempotent registration during client enter.

It deliberately excludes:

- HP and life-state persistence;
- logout and death handlers;
- return locations and coordinates;
- onboarding;
- generic persistent variables;
- HCR2 integration;
- NWNX_EVENTS, unless another system later needs an NWNX event.

Do not copy the complete Underworld `plugins/systems/pwdb/` directory when only
identity registration is required. The full plugin owns five tables and is
coupled to HP, death, reconnect, entry, and HCR2 behavior.

---

## 2. Resulting Architecture

```text
NWN client
    |
    | OnClientEnter
    v
NWScript identity plugin
    |
    | GetPCPublicCDKey(oPC)
    | GetPCPlayerName(oPC)
    | GetObjectUUID(oPC)
    | GetName(oPC)
    v
NWNX_SQL
    |
    | MySQL protocol over the Docker Compose network
    v
MySQL 8.4
    |
    +-- pwdb_account       one row per CD key
    |
    +-- pwdb_character     one row per character UUID
            |
            +-- future system tables reference character_id
```

Persistent identity has three distinct concepts:

| Concept | Value | Purpose |
|---------|-------|---------|
| Account natural key | public CD key | Groups characters belonging to one account |
| Character natural key | engine UUID | Stable character identity across renames and logins |
| Database join key | `character_id INT` | Small foreign key used by every child table |

Names are display and audit data only. Never identify an account with
`GetPCPlayerName()` and never identify a character with `GetName()`.

---

## 3. Required Components

### 3.1 Runtime

- Docker Engine with the Compose plugin.
- A pinned `nwnxee/unified` image containing NWNX_Core and NWNX_SQL.
- MySQL 8.4.
- A named Docker volume for MySQL data.
- A server-vault module deployment.

Underworld currently pins:

```text
nwnxee/unified:build8193.37
mysql:8.4
```

Do not use floating image tags in production. Upgrade the NWN:EE/NWNX image
and MySQL version deliberately and test them together.

### 3.2 Compile-time NWScript dependencies

The NWScript compiler must be able to find:

```text
nwnx_sql.nss
```

For the Core Framework integration shown later, it must also find:

```text
core_i_framework.nss
util_i_library.nss
```

The database implementation itself depends only on `nwnx_sql.nss`. The
framework and library includes are required only by `pwdb_l_plugin.nss`.

### 3.3 Runtime directory

This guide assumes Docker Compose runs from a runtime directory with this
shape:

```text
server/
  docker-compose.yml
  modules/
    mymodule.mod
  config/
    mysql.env
    nwserver.env
    mysql-init/
      01-nwnx-compatible-auth.sh
  logs/
```

The whole `server/` directory is mounted at `/nwn/home`. If another deployment
layout is used, change the volume paths without changing the container-side
NWN home contract.

---

## 4. Security And Identity Contract

### 4.1 Server vault is mandatory

Set:

```env
NWN_SERVERVAULT=1
```

The engine partitions character files by CD key before project code runs. The
database records account ownership, but the server vault is the primary layer
preventing a normal client from loading another account's character file.

### 4.2 UUID ownership

Use only:

```nwscript
GetObjectUUID(oPC)
```

Do not generate another UUID. Do not derive identity from character name,
player name, object tag, resref, or database ID.

### 4.3 CD key ownership

Use:

```nwscript
GetPCPublicCDKey(oPC)
```

The public CD key identifies the account row. It is not a password. Do not log
full CD keys during normal operation.

### 4.4 Character transfer policy

The Underworld behavior is intentionally conservative:

- a new UUID is linked to the account active when it is first seen;
- a later login with the same UUID updates name and login time;
- the upsert does not rewrite `account_id`;
- account transfers require an explicit administrative operation.

Do not silently re-parent a UUID to whichever CD key presents it most
recently. That makes a copied BIC an account-transfer mechanism.

For a stricter deployment, resolve the final `character_id` through both UUID
and CD key and deny the session when they disagree. Section 14 describes this
hardening option.

### 4.5 Secrets

- Never commit real MySQL passwords.
- Commit `.example` files, not populated production files.
- Restrict actual env files to the deployment host.
- Use different development and production credentials and volumes.
- Use long URL-safe random passwords. The bootstrap shell script embeds the
  password in an SQL statement, so an apostrophe in the password requires
  additional SQL escaping.
- Do not publish MySQL port 3306 unless remote administration is explicitly
  required and protected.

Recommended ignore entries:

```gitignore
config/mysql.env
config/nwserver.env
*.sql.gz
backups/
```

Commit matching `.example` files containing placeholders. On the deployment
host, restrict populated env files to the service administrator, for example:

```bash
chmod 600 server/config/mysql.env server/config/nwserver.env
```

Use a separate database, application user, and named volume for every module
and environment. Sharing one MySQL container is possible, but sharing one
database schema creates table-name and lifecycle coupling.

---

## 5. MySQL Container Environment

Create `server/config/mysql.env`:

```env
MYSQL_ROOT_PASSWORD=replace_with_a_long_random_root_password
MYSQL_DATABASE=nwn_module
MYSQL_USER=nwn_module
MYSQL_PASSWORD=replace_with_a_different_long_random_password
```

Meaning:

| Variable | Consumer | Purpose |
|----------|----------|---------|
| `MYSQL_ROOT_PASSWORD` | MySQL container | Initial root password |
| `MYSQL_DATABASE` | MySQL container | Database created on first volume initialization |
| `MYSQL_USER` | MySQL container | Application user created on first initialization |
| `MYSQL_PASSWORD` | MySQL container | Application user password |

The application user values must match these NWNX variables exactly:

```text
MYSQL_USER       == NWNX_SQL_USERNAME
MYSQL_PASSWORD   == NWNX_SQL_PASSWORD
MYSQL_DATABASE   == NWNX_SQL_DATABASE
```

Docker only consumes the initialization variables when creating a fresh data
directory. Editing `mysql.env` does not change users stored in an existing
volume.

---

## 6. NWN:EE And NWNX Environment

Create `server/config/nwserver.env`. This is a minimal identity-focused
example; retain any unrelated settings already required by the target module.

```env
# NWN server identity.
NWN_PORT=5121
NWN_MODULE=mymodule
NWN_SERVERNAME=My Module
NWN_PUBLICSERVER=0
NWN_MAXCLIENTS=32
NWN_SERVERVAULT=1

# NWNX core.
NWNX_CORE_LOAD_PATH=/nwn/nwnx/
NWN_LD_PRELOAD=/nwn/nwnx/NWNX_Core.so
NWNX_CORE_SKIP=n
NWNX_CORE_LOG_LEVEL=4
NWNX_CORE_LOG_DATE=1
NWNX_CORE_HARD_EXIT=1

# NWNX_SQL MySQL backend.
NWNX_SQL_SKIP=n
NWNX_SQL_TYPE=MYSQL
NWNX_SQL_HOST=mysql
NWNX_SQL_PORT=3306
NWNX_SQL_USERNAME=nwn_module
NWNX_SQL_PASSWORD=replace_with_the_same_value_as_MYSQL_PASSWORD
NWNX_SQL_DATABASE=nwn_module
NWNX_SQL_CHARACTER_SET=utf8mb4
NWNX_SQL_USE_UTF8=true
NWNX_SQL_QUERY_METRICS=false
```

Required identity settings:

| Variable | Required value | Reason |
|----------|----------------|--------|
| `NWNX_CORE_SKIP` | `n` | Loads NWNX core |
| `NWNX_SQL_SKIP` | `n` | Loads NWNX_SQL |
| `NWNX_SQL_TYPE` | `MYSQL` | Selects MySQL SQL dialect and driver |
| `NWNX_SQL_HOST` | `mysql` | Uses Compose service DNS name |
| `NWNX_SQL_PORT` | `3306` | MySQL container port |
| `NWNX_SQL_CHARACTER_SET` | `utf8mb4` | Matches table character set |
| `NWN_SERVERVAULT` | `1` | Keeps character files partitioned by account key |

`NWNX_EVENTS_SKIP=n` is not required for account/character registration. Add
it only if the target module later subscribes to NWNX events such as
`NWNX_ON_CLIENT_DISCONNECT_BEFORE`.

---

## 7. MySQL Authentication Compatibility

NWNX's MySQL client requires `mysql_native_password` in the tested stack.
MySQL 8.4 must start with the native password plugin enabled, and the project
user must be changed to that authentication method during initial database
creation.

Create `server/config/mysql-init/01-nwnx-compatible-auth.sh`:

```sh
#!/bin/sh
set -eu

if [ -n "${MYSQL_USER:-}" ] && [ -n "${MYSQL_PASSWORD:-}" ]; then
  mysql --protocol=socket -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';
FLUSH PRIVILEGES;
SQL
fi
```

Save the script with LF line endings. Mount the directory read-only at:

```text
/docker-entrypoint-initdb.d
```

Important initialization behavior:

- scripts in this directory run only when `/var/lib/mysql` is empty;
- changing credentials later does not re-run the script;
- an old named volume therefore retains the old password and auth plugin;
- recreate the volume only as an intentional destructive operation, or alter
  the user manually while authenticated as an administrator.

---

## 8. Docker Compose

Create `server/docker-compose.yml`:

```yaml
services:
  nwserver:
    image: nwnxee/unified:build8193.37
    hostname: nwnee
    container_name: mymodule_nwserver
    tty: true
    stdin_open: true
    stop_signal: SIGINT
    env_file:
      - ./config/nwserver.env
    depends_on:
      mysql:
        condition: service_healthy
    ports:
      - "5121:5121/udp"
    volumes:
      - ./:/nwn/home
      - ./logs:/nwn/run/logs.0
      - ./logs:/nwn/data/bin/linux-x86/logs.0
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped

  mysql:
    image: mysql:8.4
    hostname: mysql
    command: ["mysqld", "--mysql-native-password=ON"]
    env_file:
      - ./config/mysql.env
    volumes:
      - mysql_data:/var/lib/mysql
      - ./config/mysql-init:/docker-entrypoint-initdb.d:ro
    healthcheck:
      test:
        - CMD-SHELL
        - mysqladmin ping -h 127.0.0.1 -u"$${MYSQL_USER}" -p"$${MYSQL_PASSWORD}" --silent
      interval: 5s
      timeout: 5s
      retries: 30
      start_period: 20s
    restart: unless-stopped

volumes:
  mysql_data:
```

Notes:

- Compose creates a private network automatically.
- `NWNX_SQL_HOST=mysql` resolves through the Compose service name.
- MySQL does not need a host `ports` mapping for the NWN server to reach it.
- `depends_on.condition: service_healthy` prevents the NWN container from
  starting before MySQL answers its health check.
- Mounting the runtime root at `/nwn/home` makes
  `server/modules/mymodule.mod` visible inside the container as
  `/nwn/home/modules/mymodule.mod`.
- `NWN_MODULE=mymodule` must match the module filename without `.mod`.
- Change container names and port mappings when multiple stacks share a host.

Validate configuration before starting:

```bash
cd server
docker compose config --quiet
```

Do not paste full `docker compose config` output into logs or tickets. Depending
on the Compose version, rendered configuration can contain environment values.

Start MySQL first when diagnosing a new installation:

```bash
docker compose up -d mysql
docker compose ps
docker compose logs --tail=200 mysql
```

Then start the NWN server:

```bash
docker compose up -d nwserver
docker compose logs --tail=200 nwserver
```

---

## 9. Database Schema

### 9.1 Relationship

```text
pwdb_account
  account_id PK
      |
      +--< pwdb_character.account_id FK
              character_id PK
              character_uuid UNIQUE
```

Cardinality:

- one `pwdb_account` row can own zero or many characters;
- one `pwdb_character` row belongs to exactly one account;
- one UUID can appear only once;
- one CD key can appear only once;
- character and player names need no uniqueness constraint.

### 9.2 Exact identity DDL

```sql
CREATE TABLE IF NOT EXISTS pwdb_account (
  account_id  INT         NOT NULL AUTO_INCREMENT,
  cd_key      VARCHAR(16) NOT NULL,
  player_name VARCHAR(64) NULL,
  first_seen  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_seen   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
                              ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (account_id),
  UNIQUE KEY uq_cd_key (cd_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS pwdb_character (
  character_id   INT         NOT NULL AUTO_INCREMENT,
  character_uuid CHAR(36)    NOT NULL,
  account_id     INT         NOT NULL,
  char_name      VARCHAR(64) NULL,
  created_at     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_login_at  DATETIME    NULL,
  PRIMARY KEY (character_id),
  UNIQUE KEY uq_character_uuid (character_uuid),
  KEY idx_account (account_id),
  CONSTRAINT fk_character_account
    FOREIGN KEY (account_id) REFERENCES pwdb_account(account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Column rules:

| Column | Rule |
|--------|------|
| `account_id` | Surrogate join key; never exposed as account identity |
| `cd_key` | Natural account key; unique and immutable during normal login |
| `player_name` | Last seen account display name; safe to update |
| `first_seen` | Insert timestamp; never overwritten by login |
| `last_seen` | Explicitly updated on every account upsert |
| `character_id` | Surrogate join key cached on the PC during the session |
| `character_uuid` | Natural character identity from `GetObjectUUID` |
| `account_id` on character | Original owner; not rewritten by normal upsert |
| `char_name` | Last seen character name; display only |
| `created_at` | Insert timestamp |
| `last_login_at` | Updated on every character upsert |

The account foreign key intentionally has no `ON DELETE CASCADE`. Deleting an
account that still owns characters should fail. Delete or transfer its
characters deliberately first.

### 9.3 Future child-table pattern

Every future character-owned system should use `character_id`:

```sql
CREATE TABLE example_character_settings (
  character_id INT         NOT NULL,
  setting_name VARCHAR(64) NOT NULL,
  setting_value TEXT       NULL,
  PRIMARY KEY (character_id, setting_name),
  CONSTRAINT fk_example_settings_character
    FOREIGN KEY (character_id)
    REFERENCES pwdb_character(character_id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Do not repeat CD key, UUID, player name, or character name in every system
table. Join through `character_id`.

---

## 10. Schema Ownership Strategy

Underworld uses code-driven bootstrap:

```text
OnModuleLoad
    > PWDB_EnsureIdentitySchema()
    > CREATE TABLE IF NOT EXISTS pwdb_account
    > CREATE TABLE IF NOT EXISTS pwdb_character
```

Advantages:

- a clean database needs no manual schema command;
- repeated server starts are idempotent;
- schema failure appears in the NWN server log.

Limitation:

`CREATE TABLE IF NOT EXISTS` does not migrate an existing table. Adding a
column to the NWScript string does nothing to a table already present.

Before production data matters, choose one migration policy:

1. Maintain numbered SQL migrations and apply each exactly once; or
2. Stop the server, back up the database, apply reviewed `ALTER TABLE`
   statements manually, then restart.

Dropping and recreating tables is acceptable only while all stored data is
disposable.

Do not place the schema DDL in `docker-entrypoint-initdb.d` if NWScript owns
bootstrap. Having two independent schema definitions creates drift.

---

## 11. Minimal NWScript Implementation

Use these four files:

```text
plugins/systems/pwdb/
  pwdb_c_config.nss
  pwdb_i_db.nss
  pwdb_i_user.nss
  pwdb_l_plugin.nss       Core Framework integration only
```

All filenames satisfy NWN's 16-character resref limit.

### 11.1 `pwdb_c_config.nss`

```nwscript
/// ----------------------------------------------------------------------------
/// @system  PWDB Identity
/// @file    pwdb_c_config
/// @author  PROJECT AUTHOR
/// @brief   Constants for persistent account and character identity.
/// ----------------------------------------------------------------------------

const string PWDB_TABLE_ACCOUNT   = "pwdb_account";
const string PWDB_TABLE_CHARACTER = "pwdb_character";
const string PWDB_VAR_CHARACTER_ID = "PWDB_CHARACTER_ID";
```

### 11.2 `pwdb_i_db.nss`

```nwscript
/// ----------------------------------------------------------------------------
/// @system  PWDB Identity
/// @file    pwdb_i_db
/// @author  PROJECT AUTHOR
/// @brief   Internal MySQL persistence for account and character identity.
/// ----------------------------------------------------------------------------

#include "nwnx_sql"
#include "pwdb_c_config"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Create the account and character identity tables.
/// @returns TRUE when both schema statements succeed; otherwise FALSE.
int PWDB_DB_EnsureIdentitySchema();

/// @brief Upsert account and character rows, then cache character_id on oPC.
/// @param oPC Player character being registered.
/// @returns Positive character_id on success; otherwise 0.
int PWDB_DB_ResolveCharacterId(object oPC);

/// @brief Read the cached character_id, resolving it when absent.
/// @param oPC Player character whose identity is required.
/// @returns Positive character_id on success; otherwise 0.
int PWDB_DB_GetCharacterId(object oPC);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

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
        + "                           ON UPDATE CURRENT_TIMESTAMP,"
        + "  PRIMARY KEY (account_id),"
        + "  UNIQUE KEY uq_cd_key (cd_key)"
        + ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
    );

    if (!bAccount)
    {
        PrintString("[PWDB:DB] Account schema failed: "
            + NWNX_SQL_GetLastError());
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
        PrintString("[PWDB:DB] Character schema failed: "
            + NWNX_SQL_GetLastError());
        return FALSE;
    }

    PrintString("[PWDB:DB] Identity schema ready");
    return TRUE;
}

int PWDB_DB_ResolveCharacterId(object oPC)
{
    if (!GetIsObjectValid(oPC) || !GetIsPC(oPC))
        return 0;

    string sUuid   = GetObjectUUID(oPC);
    string sCdKey  = GetPCPublicCDKey(oPC);
    string sPlayer = GetPCPlayerName(oPC);
    string sName   = GetName(oPC);

    if (sUuid == "" || sCdKey == "")
    {
        PrintString("[PWDB:DB] Refused empty UUID or CD key for PC=" + sName);
        return 0;
    }

    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_ACCOUNT + " (cd_key, player_name)"
        + " VALUES (?, ?)"
        + " ON DUPLICATE KEY UPDATE"
        + "   player_name = VALUES(player_name),"
        + "   last_seen   = CURRENT_TIMESTAMP"
    ))
    {
        PrintString("[PWDB:DB] Account prepare failed: "
            + NWNX_SQL_GetLastError());
        return 0;
    }

    NWNX_SQL_PreparedString(0, sCdKey);
    NWNX_SQL_PreparedString(1, sPlayer);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Account registration failed for PC=" + sName
            + ": " + NWNX_SQL_GetLastError());
        return 0;
    }

    if (!NWNX_SQL_PrepareQuery(
        "INSERT INTO " + PWDB_TABLE_CHARACTER
        + " (character_uuid, account_id, char_name, last_login_at)"
        + " SELECT ?, account_id, ?, CURRENT_TIMESTAMP"
        + "   FROM " + PWDB_TABLE_ACCOUNT + " WHERE cd_key = ?"
        + " ON DUPLICATE KEY UPDATE"
        + "   char_name     = VALUES(char_name),"
        + "   last_login_at = CURRENT_TIMESTAMP"
    ))
    {
        PrintString("[PWDB:DB] Character prepare failed: "
            + NWNX_SQL_GetLastError());
        return 0;
    }

    NWNX_SQL_PreparedString(0, sUuid);
    NWNX_SQL_PreparedString(1, sName);
    NWNX_SQL_PreparedString(2, sCdKey);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Character registration failed for PC=" + sName
            + ": " + NWNX_SQL_GetLastError());
        return 0;
    }

    if (!NWNX_SQL_PrepareQuery(
        "SELECT character_id FROM " + PWDB_TABLE_CHARACTER
        + " WHERE character_uuid = ? LIMIT 1"
    ))
    {
        PrintString("[PWDB:DB] Identity lookup prepare failed: "
            + NWNX_SQL_GetLastError());
        return 0;
    }

    NWNX_SQL_PreparedString(0, sUuid);

    if (!NWNX_SQL_ExecutePreparedQuery())
    {
        PrintString("[PWDB:DB] Identity lookup failed for PC=" + sName
            + ": " + NWNX_SQL_GetLastError());
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
        return 0;
    }

    SetLocalInt(oPC, PWDB_VAR_CHARACTER_ID, nCharacterId);
    PrintString("[PWDB:DB] Resolved PC=" + sName
        + " character_id=" + IntToString(nCharacterId));
    return nCharacterId;
}

int PWDB_DB_GetCharacterId(object oPC)
{
    int nCharacterId = GetLocalInt(oPC, PWDB_VAR_CHARACTER_ID);
    if (nCharacterId > 0)
        return nCharacterId;

    return PWDB_DB_ResolveCharacterId(oPC);
}
```

All player-controlled values use prepared parameters. DDL uses direct query
execution because table and column identifiers are compile-time constants.

Do not use `LAST_INSERT_ID()` here. NWNX_SQL does not provide a contract that
the next NWScript call will use the same underlying MySQL connection. Reading
the ID back by UUID is deterministic.

### 11.3 `pwdb_i_user.nss`

This is the only include other systems should consume.

```nwscript
/// ----------------------------------------------------------------------------
/// @system  PWDB Identity
/// @file    pwdb_i_user
/// @author  PROJECT AUTHOR
/// @brief   Public API for account and character identity persistence.
/// ----------------------------------------------------------------------------

#include "pwdb_i_db"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

/// @brief Create identity tables when they do not exist.
/// @returns TRUE on success; otherwise FALSE.
int PWDB_EnsureIdentitySchema();

/// @brief Register or refresh a player account and character.
/// @param oPC Player character to register.
/// @returns Positive character_id on success; otherwise 0.
int PWDB_ResolveCharacterId(object oPC);

/// @brief Return the session-cached character_id, resolving it if needed.
/// @param oPC Player character whose ID is needed.
/// @returns Positive character_id on success; otherwise 0.
int PWDB_GetCharacterId(object oPC);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

int PWDB_EnsureIdentitySchema()
{
    return PWDB_DB_EnsureIdentitySchema();
}

int PWDB_ResolveCharacterId(object oPC)
{
    return PWDB_DB_ResolveCharacterId(oPC);
}

int PWDB_GetCharacterId(object oPC)
{
    return PWDB_DB_GetCharacterId(oPC);
}
```

### 11.4 Core Framework integration: `pwdb_l_plugin.nss`

Use this option when the target module already runs NWN Core Framework and
sm-utils.

```nwscript
/// ----------------------------------------------------------------------------
/// @system  PWDB Identity
/// @file    pwdb_l_plugin
/// @author  PROJECT AUTHOR
/// @brief   Core Framework registration for persistent player identity.
/// ----------------------------------------------------------------------------

#include "util_i_library"
#include "core_i_framework"
#include "pwdb_i_user"

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

void pwdb_OnModuleLoad();
void pwdb_OnClientEnter();

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------

void pwdb_OnModuleLoad()
{
    PWDB_EnsureIdentitySchema();
}

void pwdb_OnClientEnter()
{
    object oPC = GetEnteringObject();

    if (!GetIsObjectValid(oPC)
        || !GetIsPC(oPC)
        || GetIsDM(oPC)
        || GetIsDMPossessed(oPC))
    {
        return;
    }

    if (PWDB_ResolveCharacterId(oPC) <= 0)
    {
        PrintString("[PWDB] Identity unavailable for PC=" + GetName(oPC));
    }
}

void OnLibraryLoad()
{
    if (!GetIfPluginExists("pwdb"))
    {
        object oPlugin = CreatePlugin("pwdb");
        SetName(oPlugin, "[Plugin] PWDB Identity");
        SetDescription(oPlugin,
            "MySQL account and character registration through NWNX_SQL.");

        RegisterEventScript(oPlugin, MODULE_EVENT_ON_MODULE_LOAD,
            "pwdb_OnModuleLoad", 9.0);

        RegisterEventScript(oPlugin, MODULE_EVENT_ON_CLIENT_ENTER,
            "pwdb_OnClientEnter", EVENT_PRIORITY_FIRST);
    }

    RegisterLibraryScript("pwdb_OnModuleLoad", 1);
    RegisterLibraryScript("pwdb_OnClientEnter", 2);
}

void OnLibraryScript(string sScript, int nEntry)
{
    switch (nEntry)
    {
        case 1: pwdb_OnModuleLoad();  break;
        case 2: pwdb_OnClientEnter(); break;
        default:
            PrintString("[PWDB] Unknown library entry: " + sScript);
    }
}
```

Framework configuration must discover and activate the plugin:

```nwscript
const string INSTALLED_LIBRARIES = "*_l_plugin";
const string INSTALLED_PLUGINS = "";
```

An empty `INSTALLED_PLUGINS` activates all discovered plugins. If the target
module uses an explicit whitelist, add plugin ID `pwdb` to that list.

`EVENT_PRIORITY_FIRST` ensures identity is cached before another login handler
tries to use `PWDB_GetCharacterId(oPC)`.

### 11.5 Standalone module-event integration

Use this option when the target module does not run Core Framework. Do not use
it together with `pwdb_l_plugin.nss`.

Merge this call into the module's existing OnModuleLoad script:

```nwscript
#include "pwdb_i_user"

void main()
{
    PWDB_EnsureIdentitySchema();

    // Preserve the module's existing OnModuleLoad behavior here.
}
```

Merge this call near the start of the existing OnClientEnter script:

```nwscript
#include "pwdb_i_user"

void main()
{
    object oPC = GetEnteringObject();

    if (GetIsObjectValid(oPC)
        && GetIsPC(oPC)
        && !GetIsDM(oPC)
        && !GetIsDMPossessed(oPC))
    {
        PWDB_ResolveCharacterId(oPC);
    }

    // Preserve the module's existing OnClientEnter behavior here.
}
```

Assign the compiled scripts to the module event slots in Aurora Toolset, or
through the target module's source/build system. Do not replace existing event
logic without merging it.

---

## 12. Login Sequence

Every valid player login performs this idempotent sequence:

```text
1. Read UUID, CD key, account display name, and character display name.
2. Reject empty UUID or CD key.
3. Upsert pwdb_account by unique cd_key.
4. Update player_name and last_seen.
5. Insert pwdb_character using account_id selected by cd_key.
6. On duplicate UUID, update char_name and last_login_at only.
7. Select character_id by UUID.
8. Store character_id in local variable PWDB_CHARACTER_ID on the PC.
9. All later systems use the cached integer.
```

Registration is not the same as application onboarding. Account and character
rows are created automatically on first sight. If the module later needs a
first-login flow, add a dedicated nullable timestamp or status column such as
`onboarded_at`; do not infer onboarding from character name or login count.

The cache is session-only and deliberately not persistent. The database row is
resolved once again at the next login.

The three statements are not one SQL transaction. This is intentional for the
portable NWNX_SQL path: the operations are idempotent, and a later login repairs
an account-only partial registration. If any statement fails, return 0 and do
not let dependent systems write without a valid `character_id`.

Choose an outage policy explicitly:

- optional persistence: allow login, log the failure, and disable dependent
  persistence for that session;
- mandatory identity: show a clear message and reject or disconnect the player
  through the target module's established login policy.

The example implements optional persistence. It does not kick a player.

---

## 13. Build And Packaging Requirements

Before starting the runtime, confirm:

- all `pwdb_*.nss` sources are inside the module build inputs;
- `pwdb_l_plugin.nss` is compiled and packed when using Core Framework;
- `nwnx_sql.nss` is on the compiler include path;
- the compiled module is named exactly as `NWN_MODULE` expects;
- the deployed `.mod` is inside `server/modules/`;
- no stale `.ncs` from an earlier implementation is being loaded;
- Core Framework configuration is included before framework source defaults
  when using the plugin integration.

The identity code is NWScript. It requires a script compile and a module
reload or server restart. Docker env changes require container recreation.
MySQL initialization changes may require a fresh database volume.

---

## 14. Optional Strict Account Binding

Base Underworld behavior resolves an existing character by UUID because the
server vault already controls which BIC the client can load.

For defense in depth, replace the final lookup with:

```sql
SELECT c.character_id
FROM pwdb_character c
JOIN pwdb_account a ON a.account_id = c.account_id
WHERE c.character_uuid = ?
  AND a.cd_key = ?
LIMIT 1;
```

Bind UUID at position 0 and current public CD key at position 1. A UUID copied
under another CD key then resolves to no row and persistence remains disabled
for that session.

Choose policy before launch:

| Policy | Behavior |
|--------|----------|
| UUID-only resolution | Matches current Underworld; server vault is primary protection |
| UUID plus CD-key resolution | Rejects copied or mismatched BICs at database layer |
| Automatic re-parenting | Not recommended; turns login into an implicit account transfer |

Account transfers should be an audited administrative operation that changes
`pwdb_character.account_id` after ownership has been verified.

---

## 15. First Boot Procedure

1. Create runtime directories and files.
2. Put `mymodule.mod` in `server/modules/`.
3. Populate `mysql.env` and `nwserver.env` with matching application
   credentials.
4. Validate Compose configuration.
5. Start MySQL.
6. Wait for healthy status and inspect MySQL logs.
7. Start the NWN server.
8. Confirm NWNX_SQL loads.
9. Confirm schema bootstrap log appears.
10. Log in with one normal player character.
11. Confirm a positive `character_id` is resolved.
12. Inspect both rows from MySQL.
13. Log in again and confirm no duplicate rows appear.
14. Rename a test character and confirm the same UUID row updates its display
    name.
15. Log in with a second character on the same CD key and confirm a second
    character row references the same account row.

Commands:

```bash
cd server
docker compose config --quiet
docker compose up -d mysql
docker compose ps
docker compose logs --tail=200 mysql
docker compose up -d nwserver
docker compose logs --tail=300 nwserver
```

Expected NWN log lines:

```text
[PWDB:DB] Identity schema ready
[PWDB:DB] Resolved PC=<character name> character_id=<positive integer>
```

---

## 16. Database Verification

Open a MySQL shell without placing the password directly in the host command
history:

```bash
docker compose exec mysql sh -lc \
  'mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"'
```

Verify schema:

```sql
SHOW TABLES;
SHOW CREATE TABLE pwdb_account;
SHOW CREATE TABLE pwdb_character;
```

Verify registrations:

```sql
SELECT
  account_id,
  cd_key,
  player_name,
  first_seen,
  last_seen
FROM pwdb_account
ORDER BY account_id;

SELECT
  character_id,
  character_uuid,
  account_id,
  char_name,
  created_at,
  last_login_at
FROM pwdb_character
ORDER BY character_id;
```

Verify one-to-many ownership without displaying CD keys:

```sql
SELECT
  a.account_id,
  a.player_name,
  COUNT(c.character_id) AS character_count
FROM pwdb_account a
LEFT JOIN pwdb_character c ON c.account_id = a.account_id
GROUP BY a.account_id, a.player_name
ORDER BY a.account_id;
```

Expected invariants:

- repeated login leaves account and character row counts unchanged;
- `last_seen` and `last_login_at` advance;
- character rename updates `char_name` only;
- multiple characters on one CD key share `account_id`;
- every character has a valid account foreign key;
- UUIDs and CD keys remain unique.

---

## 17. Troubleshooting

| Symptom | Likely cause | Check or fix |
|---------|--------------|--------------|
| No PWDB log lines | Scripts not packed or event not registered | Inspect deployed module and event/plugin registration |
| `Expected MYSQL` warning | Wrong `NWNX_SQL_TYPE` or plugin environment | Set `NWNX_SQL_TYPE=MYSQL` and recreate NWN container |
| Connection refused | MySQL unhealthy or wrong host | Use host `mysql`; inspect `docker compose ps` and MySQL logs |
| Access denied | Credential mismatch or stale volume | Compare both env files; alter user or deliberately recreate volume |
| Auth plugin error | Native password plugin missing | Add MySQL command and init script; initialize a fresh volume |
| Unknown database | Database names differ | Match `MYSQL_DATABASE` and `NWNX_SQL_DATABASE` |
| Table missing | OnModuleLoad did not execute | Verify event hook and schema failure logs |
| Foreign key creation fails | Account table missing or incompatible engine/charset | Create account first; use InnoDB and matching types |
| Every login inserts new character | UUID is not stable or unique constraint missing | Log diagnostic UUID safely; inspect `uq_character_uuid` |
| `character_id` is 0 | Earlier upsert/select failed | Read `NWNX_SQL_GetLastError()` output |
| Character linked to unexpected account | BIC/UUID copied or transfer performed | Review ownership policy; use strict binding if required |
| Env edit has no effect | Container not recreated | Run `docker compose up -d --force-recreate nwserver` |
| Schema edit has no effect | `CREATE TABLE IF NOT EXISTS` is not migration | Apply reviewed `ALTER TABLE` or rebuild disposable table |

Do not print passwords, root credentials, or full CD keys while debugging.

---

## 18. Backup And Restore

Create a logical backup before schema changes:

```bash
cd server
mkdir -p backups
docker compose exec -T mysql sh -lc \
  'mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
  --single-transaction --routines --triggers "$MYSQL_DATABASE"' \
  | gzip > backups/nwn-module-$(date +%Y%m%d-%H%M%S).sql.gz
```

Test restores in a separate development database. A backup that has never
been restored is not a verified backup.

Example restore into an empty test database:

```bash
gunzip -c backups/FILE.sql.gz \
  | docker compose exec -T mysql sh -lc \
    'mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"'
```

Keep database backups outside the repository and outside the same Docker
volume they protect.

---

## 19. Resetting A Disposable Development Database

This operation destroys all database data in the Compose project. Confirm the
Compose project and volume names before running it.

```bash
cd server
docker compose down
docker volume ls
docker compose down -v
docker compose up -d mysql
docker compose up -d nwserver
```

`docker compose down -v` is appropriate only for disposable development data.
Never use it as a production migration method.

---

## 20. Production Checklist

- [ ] NWN and MySQL images use pinned versions.
- [ ] Development and production use separate databases and named volumes.
- [ ] Production credentials are not committed.
- [ ] MySQL port 3306 is not exposed publicly.
- [ ] `NWN_SERVERVAULT=1` is enabled.
- [ ] NWNX_Core and NWNX_SQL load successfully.
- [ ] MySQL reports healthy before NWN starts.
- [ ] MySQL user and NWNX credentials match.
- [ ] Native password compatibility is configured for the tested stack.
- [ ] Schema bootstrap runs before player login handlers consume identity.
- [ ] All dynamic SQL values use prepared parameters.
- [ ] UUID and CD key empty-value guards are present.
- [ ] Account-transfer policy is documented.
- [ ] Child tables use `character_id` foreign keys.
- [ ] Backup and restore have been tested.
- [ ] Schema migration procedure exists before persistent production data is
      accepted.
- [ ] Manual tests cover repeat login, rename, multiple characters per account,
      restart, and database outage behavior.

---

## 21. Underworld Source Mapping

This guide is extracted from these repository sources:

| Source | Relevant responsibility |
|--------|-------------------------|
| `documentation/pwdb.md` | PWDB backend, identity, login, and source-of-truth contract |
| `documentation/database/schema.md` | Canonical Underworld schema and identity reasoning |
| `documentation/database/setup.md` | MySQL/NWNX environment and operational behavior |
| `docker-compose.yml` | Production MySQL and NWN service wiring |
| `docker-compose.yml` | Development service wiring and volume separation |
| `config/mysql-init/01-nwnx-compatible-auth.sh` | MySQL auth compatibility bootstrap |
| `plugins/systems/pwdb/pwdb_i_db.nss` | DDL, prepared upserts, lookup, and session cache |
| `plugins/systems/pwdb/pwdb_l_plugin.nss` | Core Framework module-load and client-enter registration |

The live Underworld schema contains additional columns and child tables for
systems excluded from this port. This guide is the minimal identity slice, not
a second canonical definition of the complete Underworld PWDB schema.
