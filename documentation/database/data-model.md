# PDB Data Model

The target model. This document is prescriptive: it states what the system
**is**, not what it could be. Where an alternative was rejected, the reason is
recorded so it is not re-litigated.

Decided 2026-08-07.

---

## 0. Resulting architecture

```text
NWN client
    |
    | NWNX_ON_CLIENT_CONNECT_BEFORE
    v
pwdb_ev_connect.nss                        pre-vault access gate
    |-- global CD-key ban
    |-- protected account-name ownership
    |-- attempted CD-key/IP history
    |
    | OnClientEnter
    v
wrap_on_clnt_ent.nss                        module event script
    |
    | GetPCPublicCDKey(oPC)   -> account natural key
    | GetObjectUUID(oPC)      -> character natural key
    | GetPCPlayerName(oPC)    -> display only
    | GetName(oPC)            -> display only
    | PB_FECHA_CREACION       -> original creation timestamp when available
    v
pwdb_i_user.nss                             public API, the only include
    |                                       other systems consume
    v
pwdb_i_db.nss                               prepared statements
    |
    v
NWNX_SQL
    |
    | MySQL protocol over the Docker Compose network (service "mysql")
    v
MySQL 8.4                                   volume mysql_data
    |
    +-- pwdb_account            one row per CD key
    |       |
    |       +--< pwdb_account_name_history
    |       +--< pwdb_account_cd_key_history
    |       +--< pwdb_account_ip_history
    |       +--< pwdb_character         one row per engine UUID
    |                |
    |                |  character_id    <-- the only join key
    |                |
    |                +--< cnr_tradeskill       (character_id, skill_name)
    |                +--< cnr_craft_selection  (character_id)
    |                +--< pwdb_character_level_unlock (character_id, unlock_level)
    |                +--< future system tables reference character_id
    |
    +-- recipe_metadata         global catalogue, no character_id
    +-- material_properties     global catalogue, no character_id
    +-- pwdb_cd_key_ban         global pre-vault deny policy
    +-- pwdb_dm_cd_key_whitelist
    |                            DM-only pre-vault allow policy
    +-- pwdb_dm_cd_key_whitelist_revision
                                 immutable whitelist administration audit
```

The resolved `character_id` travels back up and is cached for the session:

```text
MySQL  --(character_id)-->  CONTENEDOR_VARIABLES   (dmfi_pc_emote, plot item)
                                PWDB_CHARACTER_ID     overwritten every login
                                CNR_XP_<skill>        loaded at login
                                CNR_LEVEL_<skill>     loaded at login

            reads during play hit the container, never the database
```

### The other two stores

PDB runs three persistence engines. Only the one above moves to MySQL.

```text
NWScript
    |
    +--> NWNX_SQL ............... MySQL 8.4     identity + CNR   [this document]
    |
    +--> SqlPrepareQuery* ....... engine SQLite  NUI windows, inc_array
    |                                            server/database/*.sqlite3
    |                                            cannot target MySQL
    |
    +--> SetCampaign* ........... BioWare DB     CNR floats/strings
                                                 campaign "cnr_misc"
```

---

## 1. The three layers

```text
LAYER 1  IDENTITY  (persistent truth, the database)
    pwdb_account      one row per CD key
    pwdb_character    one row per engine UUID
                          |
LAYER 2  DOMAIN  (everything joins on character_id)
    cnr_tradeskill        cnr_craft_selection      future systems
                          |
LAYER 3  CACHE  (CONTENEDOR_VARIABLES, rewritten every login)
    PWDB_CHARACTER_ID     CNR_XP_<skill>     CNR_LEVEL_<skill>
```

Each layer may read from the one above it. **No layer may be the authority for
anything owned by a layer above it.** That single rule is what the rest of this
document enforces.

---

## 2. Layer 1 — Identity

```sql
CREATE TABLE pwdb_account (
  account_id  INT         NOT NULL AUTO_INCREMENT,
  cd_key      VARCHAR(16) NOT NULL,
  player_name VARCHAR(64) NULL,
  first_seen  DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_seen   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
                              ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (account_id),
  UNIQUE KEY uq_cd_key (cd_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE pwdb_character (
  character_id   INT         NOT NULL AUTO_INCREMENT,
  character_uuid CHAR(36)    NOT NULL,
  account_id     INT         NOT NULL,
  char_name      VARCHAR(64) NULL,
  created_at     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_login_at  DATETIME    NULL,
  rebuilds_available SMALLINT UNSIGNED NOT NULL DEFAULT 2,
  rebuilds_completed INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (character_id),
  UNIQUE KEY uq_character_uuid (character_uuid),
  KEY idx_account (account_id),
  CONSTRAINT fk_character_account
    FOREIGN KEY (account_id) REFERENCES pwdb_account(account_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Three concepts, kept distinct on purpose:

| Concept | Value | Source | Used for |
|---------|-------|--------|----------|
| Account natural key | CD key | `GetPCPublicCDKey(oPC)` | Grouping characters under one account |
| Character natural key | engine UUID | `GetObjectUUID(oPC)` | Stable identity across renames |
| **Join key** | `character_id` INT | the database | **Every other table in the system** |

Names (`player_name`, `char_name`) are display and audit data. They never become
the natural key of a PWDB account or character. Historical community names are
also used as a defensive lookup before the engine selects a name-keyed legacy
server-vault folder: the lookup proves which stable PWDB account may present
that routing name, not that the name itself is an identity credential. See
[`account-access-security.md`](account-access-security.md).

The one deliberate lifecycle exception is deleted-name reservation. A
`pwdb_character_profile` row with status `deleted` remains a tombstone for its
immutable UUID. Until `name_reuse_unlocked_at` is set, it also reserves the
normalized `(account_id, char_name)` pair so a new UUID cannot recreate the
same named character in the same account. This is an access-policy lookup, not
a new natural key: another account may use the name, and an administrator may
release the name without changing or reusing the deleted UUID.

DM access uses a separate closed allowlist keyed by the public CD key. The DM
password remains necessary, but it is no longer sufficient: the client-connect
event rejects a DM connection before the avatar list unless its normalized key
exists in `pwdb_dm_cd_key_whitelist`. `pwdb_cd_key_ban` is evaluated first, so a
global ban cannot be bypassed by a whitelist row. Whitelist changes are stored
separately in `pwdb_dm_cd_key_whitelist_revision` because removal must not erase
the administrative history.

`pwdb_character.created_at` comes from the character container's
`PB_FECHA_CREACION` Unix timestamp. Early identity validation may use the
current database time provisionally when a new character's container does not
exist yet. A post-initialization synchronization then replaces it with the
exact timestamp restored or created by the established character-variable
system. `last_login_at` continues to advance on each successful identity
resolution.

`rebuilds_available` and `rebuilds_completed` are persistent character-owned
counters. Every existing and new character receives two available rebuilds
when migration `0015_character_rebuild_counters` is applied. A successful
replacement-UUID migration decrements the available count and increments the
completed count in the same guarded SQL statement. Opening the DM tool,
requesting BIC deletion, cancelling, and provisional cleanup do not consume a
rebuild.

Deletion through the in-game NPC preserves the entire character-owned tree.
Only the server-vault BIC is removed. A separate exact-administrator purge is
the sole path that deletes the `pwdb_character` root and invokes the domain
tables' `ON DELETE CASCADE` behavior. It deliberately preserves account-level
CD-key and IP observations because those rows are shared by all characters on
the account.

---

## 3. Layer 2 — Domain

Every character-owned table follows one shape:

```sql
CREATE TABLE <system>_<thing> (
  character_id INT NOT NULL,
  ... ,
  PRIMARY KEY (character_id, ...),
  CONSTRAINT fk_<thing>_character
    FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

CNR's two tables:

```sql
CREATE TABLE cnr_tradeskill (
  character_id INT         NOT NULL,
  skill_name   VARCHAR(32) NOT NULL,
  skill_level  INT         NOT NULL DEFAULT 1,
  skill_xp     INT         NOT NULL DEFAULT 0,
  updated_at   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP
                               ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (character_id, skill_name),
  CONSTRAINT fk_tradeskill_character
    FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE cnr_craft_selection (
  character_id INT         NOT NULL,
  recipe_id    VARCHAR(64) NOT NULL,
  created_at   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (character_id),
  CONSTRAINT fk_selection_character
    FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Administrative identity metadata follows the same ownership rule without
turning the core identity rows into catch-all records:

```text
pwdb_account
    +-- pwdb_account_management
    +--< pwdb_character
             +-- pwdb_character_profile
             +--< pwdb_character_class >-- pwdb_class_definition

pwdb_identity_revision records every administrator or technical-team write.
```

Observed player and character names remain in the core rows and are refreshed
by login. Administrative display overrides, status and notes live in the
management/profile tables so runtime observation cannot overwrite them. See
[`account-character-management.md`](account-character-management.md) for the
complete DDL ownership, class and extension contract.

**Rule: no domain table stores `character_uuid`, `cd_key`, or any name.**
Join through `character_id`. Rejected alternative and why:

> Storing UUID + CD key in every domain table makes an impossible state
> representable — a row holding character A's UUID and account B's CD key.
> A foreign key to `pwdb_character` makes that state unreachable. It also means
> an account transfer is one `UPDATE` on one row instead of a sweep across every
> table, where the one you forget becomes a silent inconsistency.

Catalogue tables (`recipe_metadata`, `material_properties`) hold **no**
`character_id`. They are global reference data, reseeded from `cnr_sql_init.nss`
on every module load.

---

## 4. Layer 3 — Cache on `CONTENEDOR_VARIABLES`

All cached values live on the container item (`dmfi_pc_emote`), which is the
server's established place for character-scoped variables. It is a plot item:
it cannot be dropped, traded, or destroyed, and only a DM can remove it.

| Variable | Type | Object | Set by |
|----------|------|--------|--------|
| `PWDB_CHARACTER_ID` | int | container | `PWDB_ResolveCharacterId` at login |
| `CDKEY` | string | container | legacy initializer; synchronized only after PWDB ownership validation |
| `CNR_XP_<skill>` | int | container | CNR skill load at login |
| `CNR_LEVEL_<skill>` | int | container | CNR skill load at login |

Cost model:

| Operation | Queries |
|-----------|---------|
| Any login | 4 core identity queries + 1 profile upsert + up to 3 class upserts + 1 stale-class cleanup + 1 marker update + 2 per skill (ensure and load 7 skills) |
| Read XP in play | **0** — `GetLocalInt(oContainer, ...)` |
| Award XP | 1 write-through `UPDATE` |
| Logout | 0 required; optional flush as a safety net |

Reads during play cost nothing.

**The creation date is settled on the first login and then left alone.** It
lives in the character's container as `PB_FECHA_CREACION`, which is where the
older scripts read it, and `pwdb_character.created_at` holds the copy. On
login:

| The character | What happens |
|---|---|
| carries the variable (anyone from before this system) | the database takes that date |
| does not carry it | the date the database has is written into the container |

For a character created after this system exists, the date the database has is
the login that inserted its row, which is the moment it was created. Either way
the value stops moving after the first login, and the scripts that read the
container agree with the database instead of finding nothing.

**The profile is rewritten on every login, on purpose.** It used to be captured
once and skipped afterwards, which cost one query less and left the sheet
frozen on the day the character first connected: levelling up, multiclassing,
changing deity or raising a stat never reached the database. Six writes per
login buy a sheet that matches the character. `snapshot_captured_at` still
records the first capture only, so the date of the original snapshot survives.

### The rule that makes this safe

Container locals are serialised into the `.bic`, so **every cached value
survives logout**. That is fine for XP display, and dangerous for
`character_id`, because `character_id` comes from `AUTO_INCREMENT`: recreate the
database — routine in dev — and the same integer now points at a different
character.

Therefore:

> **`PWDB_CHARACTER_ID` is resolved from the database and overwritten on every
> login, before anything reads it. A value carried over from a previous session
> is never trusted.**

The cache is a *within-session* read optimisation that happens to persist, not
a store. Treat a stale value as absent.

`PWDB_GetCharacterId(oPC)` therefore reads the container and falls back to a
full resolve when the container is missing or the value is `<= 0` — which also
covers a DM removing the item mid-session.

**`GetObjectUUID(oPC)` is not cached anywhere.** It is an engine-local call with
no database access; caching it would save nothing and create a second copy of
the truth.

---

## 5. What the container stops being

The container remains the cache. What it stops being is the **primary source of
identity**.

There is one bounded migration exception. Existing BICs can carry the legacy
`CDKEY` value before their account and UUID have ever been imported into PWDB.
When the UUID lookup returns no row, `PWDB_ResolveCharacterId` compares that
stored key with the presented public key before trusting the presented key for
any account or character insert. A non-empty mismatch imports the account and
UUID under the stored legacy owner, records the rejected candidate and denies
the session. This makes the safely recovered account available to the panel:
an `activate_cd_keys` operator can open a recapture window and capture the key
on the next coordinated attempt, while an administrator with the same grant can
promote the observed key directly after verification. An empty value permits
genuine first registration. Once the UUID exists in PWDB, the database is
authoritative and the legacy value is overwritten only after successful
validation; this is what allows a panel-confirmed key replacement to
synchronize old character files.

This exception does not apply to `PWDB_CHARACTER_ID`: that database-generated
integer is never trusted from a persisted BIC.

The `GetRandomUUID()` block in `wrap_on_clnt_ent.nss:78-85` is deleted, not
migrated. Today that code invents an identifier and stores it; from now on
identity comes from `GetObjectUUID(oPC)` and the database, and the container
holds only the resolved `character_id`.

The distinction is the whole point:

| | Before | After |
|---|--------|-------|
| Where identity is decided | container (`GetRandomUUID`) | engine + database |
| What the container holds | the identity itself | a copy of a resolved lookup |
| If the value is missing | a **new identity** is invented, orphaning all rows | it is re-resolved from the database |
| If a DM removes the item | identity lost permanently | re-resolved on next read |

That is what fixes open-issues §2 and §3. It is not about where the value is
stored; it is about who is allowed to create it.

---

## 6. Login sequence

Exact order. The first phase runs before the engine sends the server-vault
character list; the second resolves the selected BIC.

```text
 1. Client-connect event reads community name, public CD key, IP and DM flag.
 2. Refuse an active global CD-key ban.
 3. Resolve a protected historical account name; record the attempted key/IP.
 4. Refuse an ambiguous name, blocked account or foreign key before the list.
 5. Unknown names and valid owners continue to character selection.
 6. oPC = GetEnteringObject()
 7. Skip character resolution if not a PC, or if DM / DM-possessed.
 8. sUuid  = GetObjectUUID(oPC)
    sCdKey = GetPCPublicCDKey(oPC)
 9. Refuse and boot if either is empty.
10. Look up the UUID before any identity write.
11. If the UUID is unknown and the BIC carries a different non-empty legacy
    `CDKEY`, import its account and UUID under that stored owner, record the
    rejected key as an attempt, and boot without a successful login.
12. UPSERT pwdb_account   BY cd_key          -> updates player_name, last_seen
13. UPSERT pwdb_character BY character_uuid  -> updates char_name, last_login_at
                                                account_id is NOT rewritten
14. SELECT character_id
       FROM pwdb_character c
       JOIN pwdb_account   a ON a.account_id = c.account_id
      WHERE c.character_uuid = ? AND a.cd_key = ?     <-- strict binding
15. 0 rows or ownership/status failure -> boot; no persistence this session
16. Record the verified community name, CD key and IP in aggregated history.
17. oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES)
18. SetLocalInt(oContainer, "PWDB_CHARACTER_ID", nId)   <-- always overwritten
19. Synchronize the validated key into legacy `CDKEY`.
20. CNR: ensure 7 tradeskill rows exist, load them onto the container
```

Step 14 is the strict-binding lookup (porting guide §14). A BIC copied under a
different CD key resolves to zero rows and gets no persistence — the database
refuses it even if something upstream did not.

Step 13 deliberately does **not** rewrite `account_id`. A character belongs to
the account that first created it. Transferring one is an administrative
operation, not a side effect of logging in.

---

## 7. Failure policy

Access validation is fail-closed. A database error in the client-connect gate
rejects the connection before the character list. A failed character identity
resolution boots the selected character before other module systems write
persistent state. No identity or domain write may fall back to a name, empty
key or zero identifier.

Never write with an empty or zero key. The current code writes rows keyed on
`''` when the UUID is missing (open-issues §2); that is the behaviour being
removed.

---

## 8. Read and write paths

**Read tradeskill XP during play:**

```nwscript
object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
int nXp = GetLocalInt(oContainer, "CNR_XP_" + sSkill);   // no query
```

**Award XP:**

```nwscript
int nId = PWDB_GetCharacterId(oPC);               // container, else resolve
if (nId <= 0) { /* log, refuse */ return; }

object oContainer = GetItemPossessedBy(oPC, CONTENEDOR_VARIABLES);
nXp += nAward;
SetLocalInt(oContainer, "CNR_XP_" + sSkill, nXp); // cache
// write-through, prepared, ON DUPLICATE KEY UPDATE
```

```sql
INSERT INTO cnr_tradeskill (character_id, skill_name, skill_level, skill_xp)
VALUES (?, ?, ?, ?)
ON DUPLICATE KEY UPDATE skill_level = VALUES(skill_level),
                        skill_xp    = VALUES(skill_xp);
```

**`ON DUPLICATE KEY UPDATE`, never `REPLACE`.** `REPLACE` deletes the row first,
which fires `ON DELETE CASCADE` on anything referencing it. Harmless today,
silently destructive the day a table hangs off `cnr_tradeskill`.

Bulk catalogue seeding keeps `REPLACE INTO` — those tables have no children and
no player data.

---

## 9. Adding a new system later

1. One table, `character_id INT NOT NULL` first column.
2. `FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id) ON DELETE CASCADE`.
3. Read `PWDB_GetCharacterId(oPC)`; refuse to write on 0.
4. Cache hot values on `CONTENEDOR_VARIABLES` if reads are frequent, and
   rewrite them at login. Never treat a cached value as authoritative.
5. Do not store UUID, CD key, or names. Join.

If a system needs account-wide state rather than per-character, hang it off
`pwdb_account.account_id` with the same shape. Shared storage, banking and
account-wide unlocks are the expected cases.

Do not represent mixed ownership through an unenforced `owner_type/owner_id`
pair. A bank supporting both account-wide and character-specific products uses
separate owner-link tables, each with a real foreign key.
