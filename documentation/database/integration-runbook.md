# Integration Runbook — PWDB Identity + CNR

Everything needed to bring this system into another module. Written so it can
be applied to **production**, which carries fewer systems than dev — this is a
checklist, not a copy-and-paste of `src/`.

> Current porting checklist: [`pwdb-cnr-production-port.md`](pwdb-cnr-production-port.md).
> This runbook retains the historical implementation sequence and measured
> DEV results.

Keep this file updated as the integration progresses. Each phase records what
changed, so porting means replaying the list, not diffing two repositories.

---

## Status

| Phase | State |
|-------|-------|
| 1. MySQL infrastructure | **Done** |
| 2. PWDB identity (files + hooks) | **Done and verified in-game** (2026-08-07) |
| 3. CNR onto identity | **Done and verified in-game** (2026-08-08) |
| 4. SQL syntax conversion | **Done** (707 statements) |
| 5. First boot | **Done** |
| 6. Validation in-game | **Passed** |
| 7. Crafting rework — schema + code | **Built, not yet run** |
| 8. Crafting rework — catalogue migration | **Done** — 394 recipes |

Verified end to end on 2026-08-08 against a live server:

| Check | Result |
|-------|--------|
| MySQL healthy, NWNX_SQL connected (`MYSQL`, `utf8mb4`) | Pass |
| Six tables created on module load | Pass |
| One account, two characters, six tradeskills each | Historical pass before Sastrería was added — `QR4VQKV4` owns `Ertai Crowley` (id 1) and `Oficios` (id 4) |
| Crafted items carry the correct properties | Pass — validates the 339 corrected `material_properties` rows |
| Tradeskill XP survives a restart | Pass — Alquimia 5500 XP (level 8), Herreria 43357 XP (level 20) |
| Level curve derives from XP | Pass |
| Independent per-character crafting state | Pass — replaces the CD-key-keyed `temp_cnr_recipes` |

Still unverified, needs a deliberate setup: booting a character whose CD key
does not match the one registered for it.

**Gotcha found during the first run:** `linux_run_server-dev.sh` copies
`modules/PB_EE_PGCC.mod` as it exists *at that moment*. Running it while a
compile is still finishing stages the previous build, and the server loads a
`.mod` with no `.ncs` for the changed scripts — the hooks silently do nothing.
Always compile first, then stage. To check what actually shipped:

```bash
./tools/linux/neverwinter/nwn_erf -t -f server/modules/PB_EE_PGCC.mod | grep -x "wrap_on_mod_load.ncs"
```

---

## Phase 1 — Infrastructure

### Files added

| File | Tracked | Purpose |
|------|---------|---------|
| `config/mysql.env` | **No** (gitignored) | Real MySQL credentials |
| `config/mysql.env.example` | Yes | Template to copy |
| `config/mysql-init/01-nwnx-compatible-auth.sh` | Yes | Switches the app user to `mysql_native_password` |

### Files changed

**`docker-compose-dev.yml`**

- new `mysql:8.4` service: `command: ["mysqld", "--mysql-native-password=ON"]`,
  healthcheck, named volume `mysql_data`, mounts `config/mysql-init` read-only
  at `/docker-entrypoint-initdb.d`;
- `pb-server` gains `depends_on: mysql: {condition: service_healthy}`;
- **removed** the `/etc/timezone` and `/etc/localtime` bind mounts, replaced by
  `TZ=Europe/Madrid` on both services. Those paths do not exist on a Windows
  host and blocked `win_run_server.bat`.

**`config/nwserver-dev.env`** — the NWNX_SQL block:

```env
NWNX_SQL_SKIP=n
NWNX_SQL_TYPE=MYSQL          # era SQLITE
NWNX_SQL_HOST=mysql
NWNX_SQL_PORT=3306
NWNX_SQL_USERNAME=pdb_dev
NWNX_SQL_PASSWORD=<igual que MYSQL_PASSWORD>
NWNX_SQL_DATABASE=pdb_dev
NWNX_SQL_CHARACTER_SET=utf8mb4
NWNX_SQL_USE_UTF8=true
NWNX_SQL_QUERY_METRICS=false
```

`MYSQL_USER` / `MYSQL_PASSWORD` / `MYSQL_DATABASE` in `mysql.env` must match
`NWNX_SQL_USERNAME` / `NWNX_SQL_PASSWORD` / `NWNX_SQL_DATABASE` **exactly**.

**`.gitignore`** — `config/mysql.env` excluded, `mysql.env.example` and
`mysql-init/` allowed.

**`linux_run_server-dev.sh`** and **`win_run_server.bat`** — now also copy
`config/mysql.env` and `config/mysql-init/` into `server/`.

### Porting to production

1. Copy `config/mysql-init/01-nwnx-compatible-auth.sh` (LF endings, executable).
2. Copy `config/mysql.env.example` → create `config/mysql.env` **with different
   credentials**. Do not reuse the dev password.
3. Apply the same `mysql` service block to `docker-compose.yml` (production
   uses its own compose file, which still has the `/etc/timezone` mounts —
   remove them there too if production ever runs on Windows).
4. Apply the same NWNX_SQL block to `config/nwserver.env`.
5. Production stages through its own script; make sure `mysql.env` and
   `mysql-init/` reach `server/config/`.

**Warning:** `mysql-init` scripts run **only when the data volume is empty**.
Get the credentials right before the first boot. Changing them later requires
recreating the volume (destructive) or altering the user by hand.

---

## Phase 2 — PWDB identity

### Files added — now under `src/pwdb/nss/`

| File | Lines | Role |
|------|-------|------|
| `pwdb_c_config.nss` | 23 | Table names, cache variable name, boot delay, player message |
| `pwdb_i_db.nss` | 283 | All SQL. Prepared statements throughout |
| `pwdb_i_user.nss` | 114 | Public API — **the only include other systems should use** |

Public API:

```nwscript
int PWDB_EnsureIdentitySchema();        // OnModuleLoad, once
int PWDB_ResolveCharacterId(object oPC);// OnClientEnter, once per login
int PWDB_WasOwnershipDenied();          // inspect the last resolution result
int PWDB_GetCharacterId(object oPC);    // anywhere, cached
int PWDB_CanPersist(object oPC);        // guard before writing
```

### Dependencies

- `nwnx_sql.nss` on the compiler include path.
- `mti_libreria.nss` — only for the `CONTENEDOR_VARIABLES` constant
  (`dmfi_pc_emote`). **If the target module has no such container**, either
  define the constant locally or drop the caching block; the system works
  without it, it just re-resolves more often.
- No Core Framework. No NWNX_EVENTS.

### Hooks wired

**`wrap_on_mod_load.nss`** (`Mod_OnModLoad`):

```nwscript
#include "pwdb_i_user"      // added after #include "init_skillranks"

void main()
{
    // PWDB: tablas de identidad persistente (cuenta / personaje).
    PWDB_EnsureIdentitySchema();
    ...
```

**`wrap_on_clnt_ent.nss`** (`Mod_OnClientEntr`):

```nwscript
#include "pwdb_i_user"      // added after #include "pb_constantes"

void main()
{
    object oPC = GetEnteringObject();

    // PWDB: resuelve la identidad antes que cualquier sistema que persista.
    // Expulsa si la CD key no coincide con la registrada para el personaje.
    if (!GetIsDM(oPC) && !GetIsDMPossessed(oPC))
    {
        PWDB_ResolveCharacterId(oPC);
        if (PWDB_WasOwnershipDenied())
        {
            return;
        }
    }
    ...
```

In a different module these go in whatever scripts are bound to `Mod_OnModLoad`
and `Mod_OnClientEntr`. Check `module.ifo`; do not assume the same names.

### Behaviour

| Situation | Result |
|-----------|--------|
| UUID not in the database | New character. Account and character rows created |
| UUID present, CD key matches | Normal login. Timestamps updated |
| **UUID present, CD key differs** | **Booted after 5s**, with a message and a log line. Nothing is written to the database |
| DM or DM-possessed | Skipped entirely, not registered |
| Database unreachable | Login proceeds; the session persists nothing. **Does not boot** |

The ownership check runs **before** any write, so a mismatched CD key never
touches the tables. `account_id` is set on insert only — a later login never
re-parents a character to a different account.

Log lines are prefixed `[PWDB:DB]` and `[PWDB]`. CD keys are truncated to four
characters in the mismatch log.

### Porting to production

1. Copy `src/pwdb/nss/` into an equivalent dedicated source directory.
2. Add the two hook blocks to the production `Mod_OnModLoad` and
   `Mod_OnClientEntr` scripts. **Merge, do not replace** — both scripts carry
   unrelated logic.
3. Confirm `nwnx_sql.nss` is on the compiler include path.
4. Resolve the `CONTENEDOR_VARIABLES` dependency (see Dependencies).
5. Compile and pack. The identity code needs a real script compile; a
   `--noCompile` install will ship the `.nss` without a `.ncs` and nothing will
   run.

---

## Phase 3 — CNR onto identity

### Schema replaced

`CreateAllCraftingTables()` in `cnr_sql_init.nss` now emits MySQL DDL and a
different set of tables:

| Dropped | Replaced by |
|---------|-------------|
| `player_characters` | `pwdb_account` + `pwdb_character` |
| `player_tradeskills` (keyed by a generated UUID) | `cnr_tradeskill (character_id, skill_name)` |
| `temp_cnr_recipes` (keyed by CD key) | `cnr_craft_selection (character_id)` |

Both new tables carry
`FOREIGN KEY (character_id) REFERENCES pwdb_character(character_id) ON DELETE CASCADE`.
Catalogue tables (`recipe_metadata`, `material_properties`) keep their shape
with `VARCHAR` lengths sized from the real seed data.

The old tables are **not dropped automatically**. On a database that already has
them, drop them by hand once the new ones are confirmed working.

### File added

`src/cnr/nss/cnr_i_skill.nss` (187 lines) — the tradeskill API:

```nwscript
int CnrSkill_Load(object oPC);                    // login: DB -> container cache
int CnrSkill_GetXP(object oPC, int nSkill);       // cached, no query
int CnrSkill_GetLevel(object oPC, int nSkill);    // cached, no query
int CnrSkill_SetXP(object oPC, int nSkill, int nXP); // write-through
```

Writes use `INSERT … ON DUPLICATE KEY UPDATE` with prepared parameters, never
`REPLACE` — `REPLACE` deletes the row first and would fire the cascade.

### Files changed

- **`cnr_persist_inc.nss`** — `CnrSetPersistentInt` / `CnrGetPersistentInt` now
  resolve through `PWDB_GetCharacterId` and delegate to `cnr_i_skill`. They keep
  the legacy signature so the 8 existing tradeskill call sites work unchanged.
  Non-tradeskill keys are still discarded **silently and deliberately**: merchant
  stock, leader XP and device flags are out of CNR's scope in PDB.
- **`wrap_on_clnt_ent.nss`** — `AssignUuidIfMissing()` and
  `SyncTradeskillXPWithDB()` **deleted**. The `GetRandomUUID()` identity is gone.
  `main()` now calls `CnrSkill_Load(oPC)` after PWDB resolution.
- **`wrap_on_cl_leave.nss`** — its duplicate `SyncTradeskillXPWithDB()` deleted.
  No logout flush is needed: XP is written through on every change.
- **`cnr_i_craft.nss`** — keeps the active recipe on the PC and reads the
  catalogue directly from MySQL; no selection row is persisted.
- **`cnr_sql_c_item.nss`** — retained as a no-op compatibility stub. Item
  properties are applied by the generic crafting engine.

### Scope on record

CNR covers **tradeskills, recipes and material properties**. Merchant stock,
selling and "leader XP" are not used in PDB. The silent no-op stays silent, with
no logging, by explicit decision.

---

## Phase 4 — SQL syntax

The former SQLite-only seed and selection writes were retired with
`cnr_sql_init` and `cnr_at_r_craft`. Catalogue SQL is generated under
`migration/`; player-scoped writes use prepared MySQL statements.

All player-scoped writes use `INSERT … ON DUPLICATE KEY UPDATE` with prepared
statements instead.

---

## Phase 7 — Crafting rework

The catalogue moves out of NWScript into MySQL and the stations build their
menus from it. Full detail in
[`../oficios/cnr/crafting-system.md`](../oficios/cnr/crafting-system.md).

Added: 8 tables (`migration/01_schema.sql`), seed data
(`migration/02_seed.sql`), 16 NWScript files and one conversation under
`src/cnr/`. Modified: `src/shared/nss/pb_chat.nss`.

Apply with:

```bash
./linux_apply_sql.sh \
  migration/pwdb/01_identity_schema.sql \
  migration/cnr/00_player_state_schema.sql \
  migration/01_schema.sql \
  migration/02_seed.sql \
  migration/03_catalogue.sql
```

`migration/03_catalogue.sql` is generated, not hand-written. Regenerate it with
`python3 migration/build_catalogue.py` after changing
`migration/catalogue/*.json` or another catalogue authoring source.

The DEV station placeables are switched to the database engine. A production
port must configure `OnUsed = cnr_device_ou`,
`Conversation = cnr_c_station`, and leave `OnInventoryDisturbed`, `OnOpen`, and
`OnClosed` empty. There is no legacy station fallback.

---

## Build and run

```bash
./linux_build-dev.sh          # compile src/ and pack modules/PB_EE_PGCC.mod
./linux_run_server-dev.sh     # stage into server/ and start the stack
```

| Command | Does |
|---------|------|
| `./linux_build-dev.sh` | Incremental compile, then full repack of the `.mod` |
| `./linux_build-dev.sh --check` | Verify all of `src/` compiles. Writes nothing |
| `./linux_build-dev.sh --check a.nss b.nss` | Verify only those files |
| `./linux_build-dev.sh --clean` | Clear the cache and rebuild everything |
| `./linux_run_server-dev.sh` | Stage and start. Warns if a `.nss` is newer than the `.mod` |
| `./linux_stop_server.sh` | Stop the stack |

The compiler is `tools/linux/neverwinter/nwn_script_comp`, which wraps the
game's official `libnwnscriptcomp.so` and therefore matches Aurora exactly. It
is Nasher's default from 1.0 onward (bundled: 1.1.1), so `nssFlags` stays empty
and Nasher builds the invocation itself.

Baseline as of 2026-08-08: `--check` over all of `src/` reports
**5421 successful, 311 skipped, 0 errored** in about 4 minutes. The 311 skipped
are includes, which have no `main()`. Any error is therefore a regression, not
pre-existing noise.

### src/ is the only source

`modules/PB_EE_PGCC/` is an unpacked working copy. It is untracked, Nasher does
not build from it, and editing it there diverges silently from what ships.

This cost a full debugging cycle on 2026-08-08: the module kept running old
bytecode with `INSERT OR REPLACE` long after `src/` had been converted, because
the build was reading a different copy.

**A recent `.mod` timestamp proves it was repacked, not recompiled.** Nasher
compiles incrementally through `.nasher/cache/default/` but repacks the whole
`.mod` every time. To check what actually shipped, read the bytecode:

```bash
rm -rf /tmp/modx && mkdir /tmp/modx && cd /tmp/modx
<repo>/tools/linux/neverwinter/nwn_erf -x -f <repo>/server/modules/PB_EE_PGCC.mod cnr_sql_init.ncs
strings -a cnr_sql_init.ncs | grep -c "ENGINE=InnoDB"     # expect 4
strings -a cnr_sql_init.ncs | grep -c "INSERT OR REPLACE" # expect 0
```

### Accented text is fine — check the client, not the data

Spanish material names round-trip correctly. `NWNX_SQL_USE_UTF8=true` converts
the Windows-1252 bytes from the `.ncs` into UTF-8 on insert:

```
Cuero de bestia mítica     22 chars, 23 bytes
Cuero de dragón de ácido   24 chars, 26 bytes
```

If they render as `m?tica`, that is the `mysql` client, not the stored data.
Pass `--default-character-set=utf8mb4`:

```bash
docker compose exec -T mysql mysql --default-character-set=utf8mb4   -u pdb_dev -p"$PW" pdb_dev -e "SELECT ..."
```

### Verifying the first boot

```bash
cd server
docker compose logs --tail=50 mysql | grep -i "ready for connections"
docker compose logs pb-server | grep -iE "nwnx_sql|pwdb"
```

Expected, in order:

```
[PWDB:DB] Identity schema ready
[PWDB:DB] Resolved PC=<nombre> character_id=1
```

Then check the tables:

```bash
docker compose exec mysql mysql -u pdb_dev -p pdb_dev \
  -e "SELECT account_id, cd_key, player_name FROM pwdb_account;
      SELECT character_id, character_uuid, account_id, char_name FROM pwdb_character;"
```

### If it fails

| Symptom | Cause |
|---------|-------|
| `[PWDB:DB] Expected MYSQL, received SQLITE` | `NWNX_SQL_TYPE` still `SQLITE`, or the container is using a stale `server/config/nwserver-dev.env` |
| NWNX_SQL cannot authenticate | `mysql-init` did not run — the volume already existed. Recreate it or alter the user by hand |
| No `[PWDB]` lines at all | The module was packed without compiling, or the hooks are in scripts not bound to the module events |
| Nothing connects, MySQL healthy | `NWNX_SQL_HOST` must be `mysql`, the Compose service name |
