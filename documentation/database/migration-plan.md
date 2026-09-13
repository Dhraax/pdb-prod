# SQLite → MySQL Migration Plan

Status 2026-08-11: **implemented in DEV and retained as a historical migration
record.** Use [`pwdb-cnr-production-port.md`](pwdb-cnr-production-port.md) for
the current production transfer workflow and
[`../oficios/cnr/README.md`](../oficios/cnr/README.md) for current CNR status.

Plan for moving PDB's NWNX_SQL persistence from SQLite to MySQL 8.4, replacing
the former ad-hoc identity with the PWDB model from
[`pwdb-identity-porting-guide.md`](pwdb-identity-porting-guide.md), and
re-parenting CNR onto it.

Written 2026-08-07 against the `oficios` branch. Every count was measured, not
estimated.

## Decisions taken

| # | Decision |
|---|----------|
| 1 | **No production data to preserve.** Start from an empty database. No reconciliation, no dual-key transition |
| 2 | **UUID + CD key binding.** PWDB replaces the current identity outright |
| 3 | **CNR consumes the identity tables.** `player_characters` / `player_tradeskills` are retired; tradeskills hang off `pwdb_character` |
| 4 | `cnr_sqlite_init.nss` renamed to **`cnr_sql_init.nss`** — done, callers and docs updated |
| 5 | **Credentials stay in the tracked `config/nwserver.env`.** Accepted risk: this is a testing server, not a production deployment. `config/mysql.env` is still git-ignored. Revisit if a real production stack is ever built from this repo |

---

## 0. Scope — what migrates and what does not

**Get this right first.** NWN:EE runs three unrelated stores and only one moves.

| Store | API | Files | Migrates? |
|-------|-----|-------|-----------|
| **NWNX_SQL plugin** | `NWNX_SQL_*` | 6 files | **Yes** — this is the job |
| NWN:EE built-in SQLite | `SqlPrepareQuery*` | `src/nui/0i_database.nss` (26 calls), `src/shared/nss/inc_array.nss` (12) | **No.** Engine-internal, cannot target MySQL |
| BioWare campaign DB | `SetCampaign*`, campaign `cnr_misc` | `cnr_persist_inc.nss` | **No** — CNR floats/strings held by the retained stock consumers |

PDB will permanently run two databases. That is a property of the engine, not a
choice.

Current CNR files using NWNX_SQL directly:

| File | Calls | Role |
|------|-------|------|
| `src/cnr/nss/cnr_i_craft.nss` | multiple | Station catalogue, tools, recipes, properties, and crafting |
| `src/cnr/nss/cnr_i_skill.nss` | multiple | Tradeskill XP and profession limits |
| `src/cnr/nss/cnr_i_setting.nss` | multiple | Per-character crafting settings |

The old `cnr_sql_init`, `cnr_sql_c_item`, and `cnr_at_r_craft` paths no longer
own catalogue or player state. The first two remain compatibility stubs; the
legacy station action was removed with `cnr_c_recipe`.

The `.sqlite3` files under `server/database/` belong to the engine's SQLite.
Do not delete them.

---

## 1. Target architecture

```text
pwdb_account                    one row per CD key
  account_id  PK
  cd_key      UNIQUE
     |
     +--< pwdb_character        one row per engine UUID
            character_id   PK   <-- the only key child tables ever use
            character_uuid UNIQUE
            account_id     FK
               |
               +--< cnr_tradeskill      (character_id, skill_name)
               +--< cnr_craft_selection (character_id)
               +--< future systems...
```

### Why child tables carry `character_id` and not `UUID + CD key`

The relationship you described is real — a tradeskill *is* owned by the
character identified by UUID + CD key. The question is where that pair is
checked, and the answer is: **once, at login, not on every row.**

`PWDB_ResolveCharacterId()` validates UUID + CD key together and returns an
`INT`. Everything downstream joins on that integer. Reasons, in order of weight:

1. **The foreign key enforces what the pair asserts.** If a row holds a valid
   `character_id`, the UUID/CD-key pair was already verified. Storing the pair
   again in every table makes impossible states representable — a row carrying
   character A's UUID and account B's CD key. The database cannot stop that;
   a FK to `pwdb_character` can.
2. **One place to change.** Transferring a character between accounts updates a
   single row (`pwdb_character.account_id`). With the pair denormalised, it
   means rewriting every child table and any missed one becomes a silent
   inconsistency.
3. **Size.** `INT` is 4 bytes; `CHAR(36) + VARCHAR(16)` is ~56. With six
   tradeskills per character plus every future system table, that difference
   lands in every secondary index.
4. It is the pattern the porting guide prescribes (§9.3).

So: **UUID + CD key is the natural key, `character_id` is the join key.** They
are not competing designs; they are two layers of the same one.

### Where the resolved id is cached

On `CONTENEDOR_VARIABLES` (`dmfi_pc_emote`), the server's established place for
character-scoped variables. It is a plot item: it cannot be dropped, traded or
destroyed, and only a DM can remove it.

`PWDB_CHARACTER_ID` is **overwritten from the database on every login** and
never trusted across sessions — `character_id` comes from `AUTO_INCREMENT`, so
a recreated database makes an old cached value point at a different character.
`PWDB_GetCharacterId()` falls back to a full resolve when the container is
missing or the value is `<= 0`.

`GetObjectUUID(oPC)` is not cached: it is an engine-local call that never
touches the database.

Full detail in [`data-model.md`](data-model.md) §4.

---

## 2. Incompatibilities found

### 2.1 `INSERT OR REPLACE INTO` — 707 occurrences

SQLite-only. MySQL's `REPLACE INTO` has the same delete-then-insert semantics,
so the bulk conversion is mechanical:

```
INSERT OR REPLACE INTO   →   REPLACE INTO
```

**Caveat that now matters more than before:** `REPLACE` deletes the row and
fires `ON DELETE CASCADE`. Once `cnr_tradeskill` has a FK to `pwdb_character`,
a `REPLACE` on the *parent* would cascade. The seed tables
(`recipe_metadata`, `material_properties`) have no children and stay safe, but
**all player-scoped writes must use `INSERT … ON DUPLICATE KEY UPDATE`**, not
`REPLACE`. That is 7 statements, not 707.

### 2.2 `TEXT` cannot be a key in MySQL

InnoDB needs a length. Measured maxima from the seed data:

| Column | Max seen | Target |
|--------|----------|--------|
| `recipeId` | 42 | `VARCHAR(64)` |
| `material` | 30 | `VARCHAR(48)` |
| `type` | 28 | `VARCHAR(48)` |
| `gem` | 13 | `VARCHAR(16)` |
| `baseResRef` | 28 | `VARCHAR(32)` |
| `displayName` | 53 | `VARCHAR(96)` |
| `customTag` | 14 | `VARCHAR(32)` |
| `propertyType` | 23 | `VARCHAR(32)` |
| `skill_name` | 12 | `VARCHAR(32)` |

Widest index, `UNIQUE(material, type, gem, propertyType, subtype)`:
`(48+48+16+32) × 4 + 4 = 580 bytes`, well inside InnoDB's 3072-byte limit.

Side finding, unrelated to this migration: `baseResRef` holds values up to 28
characters (`sute_her_127_075_n_DrinkHIGH`) but **NWN resrefs cap at 16**.
Either those are tags, or some recipes point at blueprints that cannot resolve.
Worth a separate look.

### 2.3 Not found

No `AUTOINCREMENT`, `INSERT OR IGNORE`, `PRAGMA`, or SQLite date functions in
NWNX_SQL code. The syntax surface is small.

---

## 3. Target schema

```sql
-- Identity, owned by PWDB
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

-- CNR, hanging off identity
CREATE TABLE IF NOT EXISTS cnr_tradeskill (
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

CREATE TABLE IF NOT EXISTS cnr_craft_selection (
  character_id INT         NOT NULL,
  recipe_id    VARCHAR(64) NOT NULL,
  created_at   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (character_id),
  CONSTRAINT fk_selection_character
    FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Catalogue tables (`recipe_metadata`, `material_properties`) keep their current
shape with `VARCHAR` lengths from §2.2. They hold no player data and are
reseeded from `cnr_sql_init.nss` on every module load.

### What this retires

| Old | Replaced by | Note |
|-----|-------------|------|
| `player_characters` | `pwdb_account` + `pwdb_character` | The old table conflated account and character |
| `player_tradeskills` (keyed by generated UUID) | `cnr_tradeskill` (keyed by `character_id`) | Fixes open-issues §2 and §3 |
| `temp_cnr_recipes` (keyed by CDKey) | `cnr_craft_selection` (keyed by `character_id`) | Fixes open-issues §4 — two characters on one account no longer collide |
| `GetRandomUUID()` on the container | `GetObjectUUID(oPC)` | Engine-owned, cannot be lost with an item |

---

## 4. Phases

### Phase 1 — MySQL infrastructure

1. Add `mysql:8.4` to `docker-compose.yml` with
   `command: ["mysqld", "--mysql-native-password=ON"]`, a healthcheck, and a
   named volume (guide §8).
2. `depends_on: mysql: {condition: service_healthy}` on `pb-server`.
3. `config/mysql.env` plus a committed `config/mysql.env.example`. **`config/`
   is tracked by git** — confirm the real file is excluded before any commit.
4. `config/mysql-init/01-nwnx-compatible-auth.sh`, LF endings (guide §7).
5. `config/nwserver.env`: `NWNX_SQL_TYPE=MYSQL`, `NWNX_SQL_HOST=mysql`,
   `NWNX_SQL_PORT=3306`, credentials matching `mysql.env`,
   `NWNX_SQL_CHARACTER_SET=utf8mb4`.

**Fix while here:** the compose file bind-mounts `/etc/timezone` and
`/etc/localtime`, which do not exist on a Windows host and already break
`win_run_server.bat` (open-issues §11).

Exit: `docker compose config --quiet` passes, MySQL healthy, NWNX_SQL logs a
MySQL connection.

### Phase 2 — PWDB identity

1. Add `pwdb_c_config.nss`, `pwdb_i_db.nss`, `pwdb_i_user.nss` under
   `src/shared/nss/`. **Standalone integration** (guide §11.5) — PDB does not
   run Core Framework, so no `pwdb_l_plugin.nss`.
2. `PWDB_EnsureIdentitySchema()` from OnModuleLoad, preserving existing
   behaviour.
3. `PWDB_ResolveCharacterId(oPC)` at the top of `wrap_on_clnt_ent.nss`.
4. Use the **strict binding** lookup (guide §14) — decision 2:

```sql
SELECT c.character_id
FROM pwdb_character c
JOIN pwdb_account a ON a.account_id = c.account_id
WHERE c.character_uuid = ? AND a.cd_key = ?
LIMIT 1;
```

5. Delete the `GetRandomUUID()` block from `wrap_on_clnt_ent.nss:78-85`.

Exit: one login creates one account row and one character row; a second login
updates timestamps only; a third from a different character on the same account
adds one character row and no account row.

### Phase 3 — CNR onto identity

1. Replace `CreateAllCraftingTables()` in `cnr_sql_init.nss` with the §3 DDL.
2. Rewrite `cnr_persist_inc.nss` to take `character_id`:
   - resolve via `PWDB_GetCharacterId(oPC)`;
   - **refuse to write when it is 0** and log — no more silent empty-key rows.
3. Update `wrap_on_clnt_ent.nss` / `wrap_on_cl_leave.nss` to seed and flush
   `cnr_tradeskill` by `character_id`.
4. Point the crafting selection code at `cnr_craft_selection`.

This is the phase that makes the two systems one. Do not stop halfway — a
half-adopted identity model is worse than none.

### Phase 4 — SQL syntax

1. `INSERT OR REPLACE INTO` → `REPLACE INTO` across the seed statements (707,
   mechanical, script-applied).
2. Player-scoped writes (7 statements) → `INSERT … ON DUPLICATE KEY UPDATE`
   with **prepared parameters**, per §2.1 and open-issues §8.

Seed statements stay as direct queries; their values are compile-time
constants.

### Phase 5 — First boot

No data migration (decision 1). The database starts empty:

1. Create the volume, start MySQL, confirm healthy.
2. Start the server; confirm `NWNX_SQL_GetDatabaseType()` returns `MYSQL`.
3. Confirm both schema bootstraps log success.
4. Catalogue tables reseed automatically from `cnr_sql_init.nss`.

### Phase 6 — Validation

Manual; there is no NWScript test harness and none will be invented.

1. Two characters on one account → 1 `pwdb_account`, 2 `pwdb_character`.
2. Craft one item per profession; properties apply (exercises the 339 rows
   fixed on 2026-08-07).
3. Earn XP, restart, confirm it persisted against `character_id`.
4. Both characters hold independent crafting selections — the
   `temp_cnr_recipes` bug, gone.
5. Copy a BIC under another CD key: strict binding resolves no row and
   persistence stays disabled for that session.

---

## 5. Risks

| Risk | Mitigation |
|------|------------|
| MySQL init scripts run **only** on an empty volume | Get credentials right before first boot; changing them later needs a volume recreate |
| `REPLACE` cascading through the new FKs | Player-scoped writes use `ON DUPLICATE KEY UPDATE`, never `REPLACE` |
| Credentials in git | **Accepted** (decision 5). Testing server only |
| Windows host cannot start the stack | Fix the `/etc/timezone` mounts in phase 1 |
| Identity resolution fails at login | Guide §12 outage policy: allow login, log, disable dependent persistence for that session. Never write without a valid `character_id` |

---

## 6. Working constraints

- `.nss` files are **Windows-1252**. Edit/Write convert them to UTF-8 and
  destroy every accent. Use Python with `encoding='cp1252'`; verify with `file`
  and `grep -c $'\xef\xbf\xbd'`.
- `grep` returns nothing on these files unless you pass `-a`.
- `cnr_sql_init.nss` is LF; `cnr_sql_c_item.nss` and `cnr_recipe_utils.nss` are
  CRLF. Check with `file` before writing.
- New `pwdb_*` files are new code: they follow
  [`../nwscript/style-guide.md`](../nwscript/style-guide.md) — prototypes
  before definitions, `/// @author  Dhraax`, four spaces, braces on their own
  lines.
