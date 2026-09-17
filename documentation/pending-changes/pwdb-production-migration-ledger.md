# PWDB Production Migration Ledger

## Purpose

This is the durable execution record for moving PWDB and its administration
panel from `pdb-dev` to `pdb-prod`. Use it as the reference for every follow-up
request, deployment decision and validation result.

The earlier [production port survey](pwdb-production-port-audit.md) records how
the two repositories were compared and why the current decisions were taken.
This ledger records what was actually changed, what is merely present in the
PROD working tree, what has been verified, and what still has to happen.

Last updated: 2026-09-12.

## Status vocabulary

| Status | Meaning |
|--------|---------|
| Present | The file exists in the target working tree; this alone does not prove it is versioned or shipped |
| Implemented | The accepted source/configuration change exists in the target working tree |
| Statically verified | A compiler, parser or deterministic configuration check passed |
| Built | Nasher produced the intended module artifact |
| Rehearsed | The production stack was run locally and its observable behavior was checked |
| Deployed | The reviewed files and private configuration reached the production host |
| Runtime verified | The behavior was observed against the production-like or production runtime |

No item in this document may be described as built, rehearsed, deployed or
runtime verified without the corresponding observed evidence.

## Accepted scope

The first production slice is PWDB-only at module level. It includes identity,
access history, CD-key ownership and bans, account/character administration,
the rebuild workflow, MySQL, panel integration and persistent logging.

The following remain outside this module slice:

- CNR area and station placement, and retirement of the legacy harvesting,
  potion and skinning system (MIG-015 ports the CNR engine and resources
  without activating either);
- the arcane-fire rework;
- caster-level and spell/effect reworks;
- production maps, HAKs, TLKs and palette changes not required by PWDB;
- redesign of the legacy disguise system.

CNR database tables and catalogue SQL are included in the empty-database
baseline because the existing Alembic history depends on those tables. Their
presence in MySQL does not activate CNR gameplay in the module.

## Current overall state

| Boundary | Current state | Highest proven status |
|----------|---------------|-----------------------|
| Dedicated PWDB NWScript | Complete in `pdb-prod`, including production load and activation wrappers | Statically verified |
| PROD event integration | Module load, client enter and item activation are wired | Statically verified |
| Rebuild tool | UTI, dialogues and scripts are present; PROD migration no longer requires CNR | Statically verified |
| Nasher/build identity | Configured for `PB_EE_PROD.mod` and PROD source layout | Statically inspected |
| Local development Compose | MySQL-enabled and retains the image's normal entrypoint | Statically verified |
| Production rehearsal/host Compose | MySQL-enabled, persistent, log-preserving and panel-network compatible | Statically verified |
| CNR structural port | Engine, blueprints, palette entries and legacy bridges are present in `pdb-prod`; no station placed | Statically verified |
| Database baseline | Manual SQL and Alembic `0001` through `0022` are present | Present; not applied |
| Administration panel | Backend, frontend, migrations and container definitions are present | Present; Compose verified |
| Production module artifact | Not produced by this work | Not built |
| Containers and database | Not started or changed by this work | Not rehearsed |
| Host | No files or data were transferred | Not deployed |

## MIG-001 — Repository comparison and scope decision

Status: complete.

The current DEV working tree was compared with the production module and the
supplied legacy production Compose. The comparison established these decisions:

1. Preserve PROD-owned module behavior instead of replacing the whole module
   with DEV.
2. Port the complete PWDB boundary first.
3. Do not pull CNR or spell reworks into PROD merely to satisfy copied include
   dependencies.
4. Use one host-oriented production Compose for the final local rehearsal and
   the real host.
5. Keep `docker-compose.yml` as the ordinary local development variant,
   without the custom server entrypoint.
6. Keep credentials out of Compose YAML and documentation.

## MIG-002 — PWDB module source and event wiring

Status: implemented and statically verified.

### Dedicated PWDB sources

The target directory is `pdb-prod/src/pwdb/nss/`.

| File | Role | PROD state |
|------|------|------------|
| `pwdb_c_config.nss` | Constants, result codes, messages and persisted-key contract | Present and equal to the DEV source used for the port |
| `pwdb_ev_connect.nss` | `NWNX_ON_CLIENT_CONNECT_BEFORE` handler for pre-vault account/CD-key authorization and global bans | Present and equal to DEV |
| `pwdb_i_access.nss` | Access-history and connection-gate logic | Present and equal to DEV |
| `pwdb_i_db.nss` | NWNX_SQL database operations and schema access | Present and equal to DEV |
| `pwdb_i_user.nss` | Identity resolution, legacy-container import, account/character state and synchronization | Present and equal to DEV |
| `pwdb_mod_act.nss` | Rebuild-wand activation wrapper; delegates unrelated items to `pb_mod_activate` | Present in PROD but currently untracked |
| `pwdb_mod_load.nss` | Production load wrapper; initializes PWDB and then executes `wrap_on_mod_load` | Added in PROD and currently untracked |

### Module event assignments

`pdb-prod/src/module/ifo/module.ifo.json` now assigns:

| Module event | Script |
|--------------|--------|
| `Mod_OnModLoad` | `pwdb_mod_load` |
| `Mod_OnClientEntr` | `wrap_on_clnt_ent` |
| `Mod_OnActvtItem` | `pwdb_mod_act` |

`pwdb_mod_load` calls `PWDB_EnsureIdentitySchema()` before delegating to the
unchanged production `wrap_on_mod_load`. This avoids recoding or replacing the
legacy Windows-1252 load handler.

### Client-entry order

The production `wrap_on_clnt_ent.nss` now performs the PWDB portion in this
order:

1. Ignore DM and DM-possessed characters for persistent player identity.
2. Call `PWDB_ResolveCharacterId()` before gameplay systems mutate account-owned
   or character-owned state.
3. Return immediately when `PWDB_WasLoginDenied()` reports a refusal.
4. Allow the existing new-character initializer to create the legacy variable
   container when needed.
5. Call `PWDB_SyncRegisteredCharacter()` to synchronize the proven identity,
   creation date, unlocks and legacy container.
6. Continue into the original PROD disguise and gameplay entry behavior.

The legacy per-character `CONTENEDOR_VARIABLES.CDKEY` check remains as a later
defense. The authoritative account/CD-key association and global ban are in
MySQL. For a known protected account, the pre-vault NWNX event can reject a
foreign or banned key before the character list. A completely unknown legacy
account still cannot be imported safely until a character and its container are
selected; this is the previously documented engine boundary.

DEV-only calls to CNR skill loading, arcane-fire release, caster-level setup and
the generalized spell-effect sweep were removed from the PROD integration.

## MIG-003 — Character rebuild workflow

Status: implemented and statically verified; not tested in game.

The production slice contains:

- `src/shared/uti/dmfi_rebuild.uti.json`;
- `src/shared/dlg/rebuild_tool.dlg.json`;
- `src/shared/dlg/borrarpjs.dlg.json`;
- `src/shared/nss/rebuild_prompt.nss`;
- `src/shared/nss/rebuild_cancel.nss`;
- `src/shared/nss/rebuild_bic.nss`;
- `src/shared/nss/rebuild_clean.nss`;
- `src/shared/nss/rebuild_migrate.nss`;
- `src/pwdb/nss/pwdb_mod_act.nss`.

The deletion dialogue routes confirmation and cancellation through the rebuild
scripts. `rebuild_migrate.nss` now includes PWDB directly and no longer imports
or reloads `cnr_i_skill`, which is absent from the accepted PROD module slice.
After a successful replacement it rebinds the new UUID and synchronizes the
restored container.

The activation wrapper handles the rebuild item and delegates all other module
item activations to the existing `pb_mod_activate` script.

## MIG-004 — Production artifact and local staging

Status: implemented; focused compilation passed; full build not run.

### Nasher

`pdb-prod/nasher.cfg` now:

- identifies the package as `PROD PDB EE`;
- includes `src/**/*.{nss,json}`;
- routes `pwdb_*.nss` to `src/pwdb/$ext` before the generic shared rule;
- emits `PB_EE_PROD.mod`;
- does not introduce DEV-only CNR or NUI routing.

### Build and staging scripts

`pdb-prod/linux_build.sh` now compiles against the two script roots that
actually exist in PROD, `src/shared/nss` and `src/pwdb/nss`, and expects
`modules/PB_EE_PROD.mod`.

`pdb-prod/linux_run_server.sh` stages that same artifact together with the
development server env, MySQL env, MySQL initialization helper, Grafana
provisioning and TLK files. It then uses `docker-compose.yml`, which does not
invoke the custom production runner.

The filenames retain `-dev` for compatibility with the existing workflow; the
artifact identity is production-correct.

## MIG-005 — MySQL and NWNX runtime configuration

Status: implemented and Compose-verified; not started.

### Services and versions

The maintained Compose boundary uses:

| Service | Image |
|---------|-------|
| NWN:EE/NWNX:EE | `nwnxee/unified:build8193.37` |
| MySQL | `mysql:8.4` |
| InfluxDB | `influxdb:1.7`, `metrics` profile only |
| Grafana | `grafana/grafana:6.0.1`, `metrics` profile only |

InfluxDB and Grafana do not start by default. `NWNX_METRICS_INFLUXDB_SKIP=y`
leaves them nothing to record, the online host has never run them, and Grafana
6.0.1 would otherwise publish port 3000 on a public machine. They start with
`docker compose --profile metrics up -d` for a measurement window.

MySQL uses a named `mysql_data` volume, a health check, the
`--mysql-native-password=ON` server option required by this NWNX_SQL generation,
and `config/mysql-init/01-nwnx-compatible-auth.sh` for an empty volume.

### Required PWDB plugins and options

The production and development server envs keep the existing PROD plugin
selection and explicitly provide:

- `NWNX_EVENTS_SKIP=n`;
- `NWNX_ADMINISTRATION_SKIP=n`;
- `NWNX_SQL_SKIP=n`;
- MySQL type, host, port, character set and UTF-8 settings;
- `NWNX_TWEAKS_UNHARDCODE_SPECIAL_ABILITY_TARGET_TYPE=y`.

The last option was the one supported legacy PROD tweak missing from both
maintained environments. Removed Data, Time and BehaviourTree plugin variables
were deliberately not restored.

The productive runner derives `NWNX_SQL_USERNAME`, `NWNX_SQL_PASSWORD` and
`NWNX_SQL_DATABASE` from the corresponding `MYSQL_*` variables. It refuses to
launch NWN when SQL is enabled but these values are incomplete. This keeps one
private credential source instead of duplicating database secrets.

### Credential ownership

| File | Values owned there | Deployment handling |
|------|--------------------|---------------------|
| `config/nwserver.env` | Server identity, player password, DM password, administration password and non-secret NWNX behavior | Edit for the host; never copy values into documentation |
| `config/nwserver.env` | Local/test NWN and explicit NWNX_SQL connection settings | Local rehearsal only |
| `config/mysql.env` | MySQL root password, database, application user/password and panel MFA encryption key | Ignored/private; create from `config/mysql.env.example`, preserve across restarts and back it up privately |
| `config/grafana.env` | Grafana administrator password | Only needed where the `metrics` profile is started; not required on the host |
| `config/influxdb.env` | InfluxDB database and users/passwords | Only needed where the `metrics` profile is started; not required on the host |
| `cnr-editor/.env` | Non-secret panel origin, port, write gate, network and cookie policy | Create from `.env.example`; do not place database or MFA secrets here |

Changing MySQL env values does not rewrite users inside an already initialized
volume. Credential changes after first initialization require an explicit MySQL
operation; replacing the file alone is insufficient.

## MIG-006 — Persistent logs and controlled restart

Status: implemented and shell/Compose-verified; runtime behavior not yet
rehearsed.

`docker-compose.yml` is the production-rehearsal and host definition. It:

- fixes the Compose project name as `server`, giving the shared network the
  stable name `server_default`;
- resolves every bind mount and env file relative to the directory holding the
  Compose file, so the host runs it from its server directory with no path
  edits, and publishes the game port as `0.0.0.0:5121:5121/udp`, as the host's
  previous Compose did;
- invokes `/nwn/home/run-server.sh` as the NWN container entrypoint;
- mounts the production root at `/nwn/home`;
- does not bind-mount the host log directory onto `/nwn/run/logs.0`, because
  such a mount cannot be moved during rotation;
- waits for healthy MySQL;
- sends SIGINT and allows a two-minute graceful stop;
- caps Docker's own local log storage at five files of 20 MB each.

`run-server.sh`:

- mirrors stdout and stderr live to `logs/console_<timestamp>.log`;
- moves runtime `logs.*` directories to `logs/<timestamp>/` on a normal stop or
  server-process crash;
- recovers `logs.*` left in the same container after an unclean restart into
  `logs/recovered_<timestamp>/`;
- persists the server vault, database, module, override, save, TLK and related
  NWN home directories;
- preserves `cryptographic_secret` and `settings.tml`;
- uses only the maintained `NWN_NWSYNCURL` name and no longer passes a duplicate
  obsolete `NWNX_NWSYNCURL` argument.

`server-restart.sh` is a credential-free host command. It validates the
productive Compose, ensures MySQL is running, stops only
`pb-server` with a 120-second timeout, then recreates it. It deliberately leaves
MySQL, its persistent volume and the panel's shared network running.

## MIG-007 — Database baseline and Alembic

Status: complete on disk and execution-ready; nothing applied.

A database created from zero has two migration layers. Alembic alone is not a
standalone bootstrap because its first revisions expect base PWDB/CNR tables.

`db-apply.sh` recognizes the PROD repository root as well as the two older
staged layouts. It starts MySQL, waits for readiness, creates a private safety
dump and applies the manual SQL in this order:

1. `migration/pwdb/01_identity_schema.sql`;
2. `migration/cnr/00_player_state_schema.sql`;
3. `migration/01_schema.sql`;
4. `migration/02_seed.sql`;
5. `migration/03_catalogue.sql`;
6. `migration/05_arcane.sql`;
7. `migration/04_drop_legacy.sql`.

It records player-state row counts before and after and fails if identity or CNR
progress shrinks. On an empty database the initial counts are zero.

After that baseline exists, the panel API entrypoint runs Alembic in order from
`0001_editor_identity.py` through `0022_level_unlock_applied.py`.

No migration, dump, restore or database initialization was executed during this
work.

## MIG-008 — Administration panel deployment boundary

Status: application files present; Compose configuration verified; panel not
built or started.

The copied panel includes its backend, frontend, container definitions, tests
and all Alembic revisions through `0022`. The relevant administration behavior
includes:

- historical CD keys and IPs per account;
- full CD-key visibility for authorized administrators;
- search by any historical account name, CD key or IP;
- global persistent CD-key ban/unban;
- controlled assignment of a historical key as the account's primary key;
- the `activate_cd_keys` permission for administrative recovery;
- account and character status controls;
- audit records for administrative changes;
- MFA, recovery codes and login throttling for panel users.

The panel joins `server_default` and reaches the MySQL service as `mysql`.
`cnr-editor/.env.example` is ready for a local rehearsal with
`http://localhost:8088` and insecure cookies. The ignored `cnr-editor/remote.env`
describes the development host and is not a production template.

The production host uses the tracked `cnr-editor/host.env.example`, copied to
`cnr-editor/.env` inside the host's server directory, next to
`docker-compose.yml`, `config/` and `web-restart.sh`. It:

- binds the web container to `127.0.0.1:8088`, so the panel is never published
  on the host's public interface;
- reads `../config/mysql.env`, the game stack's own credential file, which also
  carries `CNR_EDITOR_MFA_ENCRYPTION_KEY`;
- joins `server_default`, the network of the Compose project `server`;
- keeps catalogue writes disabled.

Its default access is an SSH tunnel (`ssh -L 8088:127.0.0.1:8088`) to
`http://localhost:8088`: the transport is encrypted by SSH and nothing new is
exposed. A public name instead needs DNS and an HTTPS reverse proxy pointed at
`127.0.0.1:8088`, with that exact `https://` origin and
`CNR_EDITOR_COOKIE_SECURE=true`.

`CNR_EDITOR_FRONTEND_ORIGIN` is an application origin/CORS setting, not a
listening-address setting. A public URL additionally requires DNS and an HTTPS
reverse proxy to the panel web service. Plain HTTP is not an acceptable public
transport for passwords, MFA codes or administration cookies.

The production administrator must be created interactively after Alembic
reaches head. Copying DEV sessions, recovery codes, password material or an MFA
seed tied to a different encryption key is not part of this migration.

## Deterministic verification record

| Check | Result |
|-------|--------|
| Focused NWScript compile of `wrap_on_clnt_ent.nss`, `rebuild_migrate.nss` and `pwdb_mod_load.nss` | 3 successful, 0 skipped, 0 errors |
| Shell syntax for productive runner/restart, build/staging, database apply and panel restart scripts | Passed |
| `module.ifo.json` parse and PWDB event values | Passed |
| PROD `docker-compose.yml` render | Passed |
| PROD `docker-compose.yml` render | Passed |
| Panel Compose render with local and remote example controls | Passed |
| Required plugin, log-mount, NWSync and absent-CNR static assertions | Passed |
| DEV canonical documentation checker | Passed: 81 Markdown files and 23 README indexes |

The PROD documentation checker cannot currently pass because the copied PROD
documentation tree already contains unindexed files and module directories
without README files. Those pre-existing documentation-structure failures are
recorded separately and do not establish a runtime failure in this PWDB slice.

## Source-control state that blocks a Git-only deployment

The PROD working tree contains a mixture of tracked modifications and untracked
port files. At the last inventory:

### Tracked modifications

- `.gitignore`;
- `config/nwserver.env` and `config/nwserver.env`;
- `docker-compose.yml` and `docker-compose.yml`;
- `linux_run_server.sh`;
- `nasher.cfg`;
- `src/module/ifo/module.ifo.json`;
- `src/shared/dlg/borrarpjs.dlg.json`;
- `src/shared/nss/wrap_on_clnt_ent.nss`.

### Critical untracked paths

- `cnr-editor/`;
- `migration/`;
- `config/mysql-init/` and `config/mysql.env.example`;
- `db-apply.sh`, `web-restart.sh`, `run-server.sh`, `server-restart.sh` and
  `linux_build.sh`;
- `src/pwdb/nss/pwdb_mod_act.nss` and `src/pwdb/nss/pwdb_mod_load.nss`;
- the rebuild UTI, dialogue and executable scripts listed under MIG-003;
- the PROD module changelog file.

The sanitized `server-restart.sh` was removed from the old explicit ignore rule,
but it is still untracked until the owner chooses to version it. A pull or clone
cannot deliver any untracked file. Before a Git-based host deployment, this
entire accepted slice must be reviewed and added deliberately; no commit or
staging operation was performed here.

## Local production rehearsal order

This is the intended order, not a record of commands already executed:

1. Create private `config/mysql.env` from its example and replace every
   placeholder.
2. Set the local NWN passwords/settings in `config/nwserver.env`.
3. Create `cnr-editor/.env` from `.env.example`, keeping the local origin and
   writes disabled initially.
4. Build `modules/PB_EE_PROD.mod` with the production Nasher wrapper.
5. Run `db-apply.sh` and review its printed paths before confirming `APPLY`.
6. Start the panel so its API applies Alembic through `0022`.
7. Bootstrap the sole initial production administrator interactively.
8. Start or recreate NWN with `server-restart.sh`.
9. Execute the manual runtime tests below.
10. Only after the rehearsal passes, replace host credentials/origin, transfer
    the exact manifest and repeat the controlled database/startup sequence.

## Required runtime tests

- Confirm the server log reports the PWDB pre-vault connection gate as active.
- Connect with an allowed key/account and confirm the account, character, key
  and IP history are updated.
- Attempt a protected account with a different key and confirm rejection occurs
  before the character list.
- Ban a key in the panel and confirm its next connection is rejected under any
  account without restarting NWN.
- Unban it and confirm the next connection is accepted according to ownership
  policy.
- Exercise legacy import with a matching container CD key, a mismatching key and
  a truly new character without a stored key.
- Promote an authorized historical key to primary, confirm the new key works and
  the former key no longer owns the account, then restore if this is test data.
- Use the rebuild wand as a DM and complete cancel, clean and migrate paths.
- Activate an unrelated module item and confirm delegation to
  `pb_mod_activate` still works.
- Run `server-restart.sh`, watch the live console file and confirm timestamped
  runtime log archival.
- Restart after a deliberately stopped/crashed NWN process and confirm the
  console and runtime logs survive the container lifecycle.
- Confirm the panel works through the SSH tunnel, or through its final HTTPS
  URL with secure cookies, and rejects an unexpected browser origin. From outside
  the host, port 8088 must not answer.

## Preliminary host upload manifest

`host-sync.sh` sends everything listed below except the reviewed source; see
`documentation/repository/host-sync.md`.

### Build input or reviewed source

- `nasher.cfg`;
- `linux_build.sh`;
- `src/pwdb/nss/`;
- the integration and rebuild resources listed in MIG-002 and MIG-003;
- `src/shared/nss/nw_c2_default9.nss`;
- `src/shared/nss/wrap_on_ply_lvl.nss`;
- `src/shared/utc/pb_crienccaravan.utc.json`;
- `src/module/ifo/module.ifo.json`.

### Host runtime

- the built `modules/Puerta de Baldur 5E.mod`;
- `docker-compose.yml`;
- `run-server.sh`;
- `server-restart.sh`;
- `config/nwserver.env` with host values;
- private `config/mysql.env` with host values;
- `config/mysql-init/`;
- existing PROD module/vault/override/TLK/HAK content already owned by the host.

### Database and panel

- `migration/`;
- `db-apply.sh`;
- `cnr-editor/`;
- `web-restart.sh`;
- `cnr-editor/.env` created from `cnr-editor/host.env.example`;
- not `cnr-editor/frontend/node_modules/` or `dist/`: the images build them.

### Local rehearsal only

- `docker-compose.yml`;
- `config/nwserver.env`;
- `linux_run_server.sh`.

The private env values, database volume, server vault and log history must not
be committed as deployment artifacts. They are provisioned or preserved on the
host according to their own backup policy.

## MIG-009 — Environment level locks and static caravaners

Date: 2026-09-09

Status: Implemented in source; packaging and in-game validation pending.

Requested outcome: preserve the DEV behavior that keeps caravaner NPCs static,
make the DEV-only level-lock bypass available without weakening PROD, and
verify whether the PROD module event assignments still lagged behind DEV.

Decision and scope:

- `nw_c2_default9` skips `WalkWayPoints()` only when the creature has the local
  integer `NO_WAYPOINT_WALK`; all other users of the standard OnSpawn retain
  their existing behavior;
- the `pb_crienccaravan` blueprint now carries `NO_WAYPOINT_WALK=1` in both
  repositories. The script guard already existed in DEV, but the authoritative
  DEV blueprint did not contain the variable, so the earlier change was
  incomplete in source;
- PROD now applies the same OnSpawn guard;
- PROD `wrap_on_ply_lvl` skips its milestone checks only when the module
  explicitly declares `OMIT_LEVEL_LOCKS=1`;
- DEV keeps `OMIT_LEVEL_LOCKS=1` in `module.ifo`; PROD deliberately omits the
  variable, whose missing value is `0`, so the production-safe default is to
  enforce the campaign unlocks;
- the caster-level include and end-of-level recalculation present in DEV were
  not copied. They remain deferred under NEXT-012;
- all module event assignments match between DEV and PROD except
  `Mod_OnModLoad`: DEV calls `wrap_on_mod_load`, while PROD intentionally calls
  `pwdb_mod_load`, which initializes PWDB and delegates to that legacy script.
  The PWDB client-enter and item-activation assignments were already present in
  PROD, and `Mod_OnPlrLvlUp` already pointed to `wrap_on_ply_lvl`.

Files added or changed:

- DEV `src/shared/utc/pb_crienccaravan.utc.json`;
- PROD `src/shared/utc/pb_crienccaravan.utc.json`;
- PROD `src/shared/nss/nw_c2_default9.nss`;
- PROD `src/shared/nss/wrap_on_ply_lvl.nss`;
- the DEV and PROD September module changelogs;
- DEV `nw_c2_default9.nss` received only the required modification attribution;
  its runtime guard was already present.

Database/configuration impact: none. No SQL migration, environment variable or
credential change is required. The two module-local variables are stored in
GFF resources and travel inside the built module.

Verification completed:

- both caravaner blueprints parse as JSON and contain exactly the expected
  integer variable;
- the complete module-event maps were compared field by field;
- DEV focused compilation:
  `./linux_build.sh --check nw_c2_default9.nss` — one successful, zero
  skipped, zero errors;
- PROD focused compilation:
  `./linux_build.sh --check nw_c2_default9.nss wrap_on_ply_lvl.nss` — two
  successful, zero skipped, zero errors.

Runtime evidence: none. No module was packaged and no server or container was
started.

Deployment impact: rebuild `PB_EE_PROD.mod`; no separate host configuration or
database deployment is needed for this slice. Validate one newly created or
regenerated caravaner, one blocked milestone level without its campaign unlock,
and one allowed milestone level with the unlock. DEV must also confirm that its
module flag bypasses the milestone checks.

Remaining work: packaging and the listed in-game tests. Existing placed
creatures, if any are embedded as customized instances instead of recreated
from `pb_crienccaravan`, must be regenerated or given the same local variable
in the Toolset.

## MIG-010 — Pre-vault DM CD-key whitelist

Date: 2026-09-09

Status: Implemented in DEV and mirrored to the PROD source tree; database and
runtime deployment pending.

Requested outcome: make possession of the DM password insufficient on its own,
manage an explicit public CD-key whitelist from the panel, restrict that panel
workspace to administrators and technical staff, and reject an unauthorized DM
before avatar selection.

Decision and scope:

- `pwdb_ev_connect` keeps using `NWNX_ON_CLIENT_CONNECT_BEFORE`, the event that
  fires before `SendServerToPlayerCharList`;
- the existing global CD-key ban is evaluated first and always overrides the DM
  whitelist;
- a DM connection is allowed only when its normalized public key exists in
  `pwdb_dm_cd_key_whitelist`; an absent key, empty whitelist, or SQL failure is
  denied before the avatar list;
- player-client account ownership behavior is unchanged;
- the panel exposes **DM Administration** only to exact `admin` and `technical`
  roles, and the API independently enforces the same rule;
- whitelist additions and removals require CSRF protection and write immutable
  rows to `pwdb_dm_cd_key_whitelist_revision` for the administrator audit;
- a currently banned key cannot be added. A key whitelisted before a later ban
  remains visible as globally banned, but cannot connect.

Files added or changed:

- `src/pwdb/nss/pwdb_c_config.nss`;
- `src/pwdb/nss/pwdb_i_access.nss`;
- panel models, schemas, dependencies, router registration and audit merger;
- `cnr-editor/backend/app/routers/dm_access.py`;
- `cnr-editor/backend/migrations/versions/0020_dm_cd_key_whitelist.py`;
- `cnr-editor/backend/tests/test_dm_access.py`;
- `cnr-editor/frontend/src/DmAccess.tsx`, `App.tsx` and `types.ts`;
- canonical database, control-panel and module changelog documentation.

Database/configuration impact: Alembic migration `0020` adds the current
whitelist and its revision history. No new environment variable or credential
is introduced. The DM password remains in the existing private NWN environment
file.

Verification completed:

- focused DEV compilation of `pwdb_ev_connect.nss` and
  `wrap_on_mod_load.nss`: two successful, zero skipped, zero errors;
- focused PROD compilation of `pwdb_ev_connect.nss` and `pwdb_mod_load.nss`:
  two successful, zero skipped, zero errors;
- frontend ESLint: passed in both DEV and PROD;
- frontend TypeScript/Vite production build: passed in both DEV and PROD; Vite
  emitted only its existing large-chunk advisory;
- Python syntax parsing: passed for all eight changed/new backend Python files.
- DEV canonical documentation checker: passed with 82 Markdown files and 23
  README indexes. PROD does not contain `scripts/check_documentation.py`, so the
  repository-local checker is unavailable there; the four mirrored canonical
  documents were byte-compared with DEV, while the environment-specific
  changelog was checked separately.

Backend Pytest and Ruff could not run in the current host interpreter because
those packages are not installed. The new tests remain pending execution in the
panel development environment or image.

Runtime evidence: none. No migration was applied, no module was packaged and no
server, database, or panel container was started.

Deployment impact and safe order:

1. Back up MySQL.
2. Deploy/start the updated panel so Alembic reaches `0020`.
3. Add at least one known operator CD key in **DM Administration**.
4. Build and deploy the updated production module.
5. Restart the NWN module once.

Reversing steps 3 and 4 creates an intentional operator lockout because an empty
whitelist rejects every DM. Later additions and removals are hot for the next
connection and do not require an NWN restart.

Remaining work: execute backend Pytest/Ruff, apply `0020` in rehearsal, populate
the initial key before activating the module gate, and perform the authorized,
unauthorized, globally banned, role-boundary and audit acceptance cases.

## MIG-011 — Durable character deletion tombstones

Date: 2026-09-09

Status: Implemented in DEV and mirrored to the PROD source tree; all runtime
deployment remains pending.

Requested outcome: delete the BIC through the existing NPC without losing the
database record, reject any later BIC carrying that deleted UUID, permit the
same name to register as an independent new character, and retain a separate
deliberate hard purge for all character-owned data.

Decision and scope:

- `deleted` is an immutable database tombstone and never an implicit database
  purge;
- the old UUID always remains denied and the rebuild migration refuses deleted
  source rows;
- a new UUID may use the same name in the same or another account; it receives
  a new `character_id` and independent character-owned rows;
- name equality never restores, merges, or links a tombstone;
- hard purge is a distinct exact-administrator action requiring `ELIMINAR` and
  an unchanged timestamp;
- account-level CD-key and IP histories survive purge because they are shared
  security evidence;
- normal deletion and rebuild BIC confirmation now use different dialogues.

Files added or changed: migration `0021_character_tombstones`, PWDB
database/user includes, `borrarpjs.nss`, `borrarpjs.dlg`,
`rebuild_confirm.dlg`, `rebuild_prompt.nss`, panel models/schemas/API/UI/tests,
and canonical database, control-panel, changelog, and migration documentation.

Database/configuration impact: migration `0021` adds only the deletion
timestamp. It introduces no environment variable or credential. The safe
deployment order is database migration, panel, compiled module, then one NWN
restart.

Verification completed:

- focused DEV and PROD compilation of `borrarpjs.nss`, `rebuild_prompt.nss`,
  and `wrap_on_clnt_ent.nss`: three successful, zero skipped, zero errors in
  each repository;
- frontend ESLint and TypeScript/Vite production builds: passed in DEV and
  PROD; Vite emitted only its existing large-chunk advisory;
- Python syntax parsing: passed for all application/test files and migration
  `0021_character_tombstones` in both repositories;
- both dialogue JSON resources parsed in DEV and PROD;
- all shared implementation and canonical database/control-panel documents
  compare byte for byte between DEV and PROD; each environment has its own
  matching module changelog entry;
- DEV canonical documentation checker: passed with 82 Markdown files and 23
  README indexes. PROD has no repository-local documentation checker.

Backend imports, Pytest, and Ruff could not run because the host interpreter
does not have the panel's Python dependencies installed, including SQLAlchemy,
Pytest, and Ruff. The new request-contract test and Python lint remain pending
execution in the panel development environment or image.

Runtime evidence: none. No migration was applied, no module was packaged, and
no server, database, or panel container was started.

Remaining work: apply migration `0021` in rehearsal, then run the NPC deletion,
same-name/new-UUID registration, old-UUID rejection, deleted-row rebuild
refusal, and hard-purge acceptance cases.

## MIG-012 — 2026-09-10 PWDB transfer baseline

Date: 2026-09-10

Status: Current PWDB working-tree implementation synchronized to PROD; build,
database application and runtime deployment pending.

Requested outcome: establish an exact continuation point after the owner copied
the panel, migrations and documentation from DEV, then transfer every remaining
PWDB-owned source resource without pulling CNR gameplay or unrelated DEV module
work into PROD.

Source references at the time of comparison:

- DEV branch `feature/oficios`, HEAD
  `64c980b27cb127ac1a61a3044b765b488ecc16d5`;
- PROD branch `feature/db`, HEAD
  `9afc6ac75bb03419a0757e06100d600c9622dfac`.

These commit IDs identify the repository bases, not the complete transfer
source: the accepted PWDB changes were still present as uncommitted DEV
working-tree changes. The content comparisons below are therefore the actual
baseline for this transfer.

Owner-copied boundaries, verified byte for byte before this ledger entry was
written:

| Boundary | Comparison exclusions | Aggregate SHA-256 |
|----------|-----------------------|------------------|
| `migration/` | Python `__pycache__` | `5967ec53141de7ad88004e2d2a51b2f1700b1923b5b3644143167ec1049c343b` |
| `documentation/` | None; hash captured before this entry changed the ledger | `41214a59ece8cf7fcf361a5921f05533f208f0e0e14476f0074e28b308ddd5fe` |
| `cnr-editor/` | `.env`, `node_modules`, `dist` and `__pycache__` | `9c96c4e0309153533cc6c5539d45a3abec8201e09a8c4d54cdd05f80bde2d332` |

The copied panel boundary includes Alembic migrations `0019`, `0020` and
`0021`, the DM CD-key administration workspace, and the character-deletion
tombstone API and interface.

Remaining PWDB source comparison and transfer:

- all six shared `src/pwdb/nss/` resources in DEV already compared byte for
  byte with PROD; their aggregate SHA-256, excluding the intentional PROD-only
  load wrapper, was
  `637ce69e229ccf82273d46a3c8633fbf5610aab82208ee01a34cdf863b9499e8`;
- PROD retains `pwdb_mod_load.nss`, which initializes PWDB before delegating to
  its production `wrap_on_mod_load`;
- the deletion dialogue and script, rebuild confirmation and prompt, rebuild
  tool resources, and activation wrapper already matched the DEV source;
- PROD deliberately retains its PWDB-only `rebuild_migrate` and client-enter
  merge instead of importing the deferred CNR and spell-system calls from DEV;
- the production module event map remains `pwdb_mod_load`,
  `wrap_on_clnt_ent`, `pwdb_mod_act`, and `wrap_on_ply_lvl` for the four relevant
  events;
- the one missing PWDB-owned resource difference was repaired by adding only
  the `dmfi_rebuild` entry to the existing PROD custom item palette. The PROD
  palette was not replaced with DEV's broader palette.

Database/configuration impact: no new schema or environment value was added by
this synchronization. Migrations `0020` and `0021` still have to be applied in
the documented safe order before the corresponding compiled module is started.

Verification completed: recursive comparisons established the copied-tree and
PWDB-source equality recorded above. The PROD palette JSON parses, contains one
`dmfi_rebuild` entry, and resolves that entry to the existing
`src/shared/uti/dmfi_rebuild.uti.json` blueprint.

Runtime evidence: none. No module was compiled or packaged, no migration was
applied, and no container or server was started.

Deployment impact: build and deploy a new `PB_EE_PROD.mod`; deploy the copied
panel and migration trees; apply `0020` and populate the first authorized DM
key before activating the DM gate, then apply `0021` and deploy the module.

Excluded explicitly: `src/cnr/`, CNR module hooks and resources, production
maps, HAK/TLK changes, and DEV spell/effect work remain outside this transfer.

## MIG-013 — Level-unlock delivery acknowledgement

Date: 2026-09-12

Status: Implemented in DEV and mirrored to the PROD source tree; database and
runtime deployment pending.

Migration `0022_level_unlock_applied` adds nullable `applied_at` to
`pwdb_character_level_unlock`. The original row and `granted_at` remain the
administrative authorization; the new timestamp records only a module-confirmed
campaign value. The API preserves `level_unlocks` as the backward-compatible
editable grant list and adds `applied_level_unlocks` as read-only delivery
state. The account interface labels selected grants as pending or applied and
states that reconnection performs delivery.

During successful non-DM character synchronization, existing `DESBLOQUEO`
values are imported or acknowledged as applied. Newly authorized values are
written and immediately read back. Only values observed in the resulting
campaign mask receive `applied_at`; a campaign write or SQL acknowledgement
failure remains pending and retries on the next successful connection. This
does not introduce polling or a web-to-game hot-update channel.

Transferred source boundary:

- `src/pwdb/nss/pwdb_i_db.nss`;
- `src/pwdb/nss/pwdb_i_user.nss`;
- panel model, schema, identity response, account interface and shared types;
- migration `0022` and its focused backend contract test;
- database, panel, changelog and this deployment documentation.

Static verification completed in DEV and PROD: the focused
`wrap_on_clnt_ent.nss` consumer compilation passed; frontend lint and TypeScript
checks passed; changed Python files parsed successfully; documentation indexes
passed the DEV repository checker; and the transferred shared files compared
byte for byte. Backend Pytest could not run because the host Python environment
does not provide Pytest. No module was packaged, no migration was applied, and
no container or server was started.

Deployment order: deploy the panel and migration, apply `0022`, package and
deploy the module, then run the pending/applied and legacy-import acceptance
cases from the monthly module changelog.

## MIG-014 — Rebuild-only character renaming and recurring snapshots

Date: 2026-09-12

Status: Implemented in DEV and mirrored to the PROD source tree; runtime
deployment pending.

Normal identity resolution stores `pwdb_character.char_name` only when it
inserts a new UUID. Subsequent ordinary logins update the login timestamp and
engine-owned profile/class snapshots but cannot rename that persistent record.
This prevents a disguise or other runtime presentation change from overwriting
the registered identity name.

The controlled rebuild migration remains the only rename path. It reads the old
`character_id` from the restored variable container, requires that row to be
active and owned by the presented CD key, deletes the replacement's provisional
tree through the preceding clean step, then binds the live UUID and current
name to the old identity. Name equality is neither required nor accepted as
authorization. The same operation refreshes class slots, levels, race, subrace,
gender, portrait, deity and base ability scores from the replacement BIC while
retaining character-owned domain history.

Static verification completed in DEV and PROD: focused compilation passed for
`wrap_on_clnt_ent.nss`, `rebuild_migrate.nss`, and `borrarpjs.nss`; frontend
lint and TypeScript checks passed; changed Python files parsed successfully;
DEV documentation checks passed; and shared changed files compared byte for
byte. Runtime evidence remains absent: no module was packaged, no migration was
applied, and no server or panel was started.

Remaining work: package both modules and test ordinary login with a changed
runtime-presented name, same-name recreation after NPC deletion, old-UUID
rejection, deleted-row rebuild refusal, and a full rebuild using a different
name.

## MIG-015 — CNR structural port without gameplay activation

Date: 2026-09-12

Status: Implemented in the PROD source tree and statically verified; nothing
packaged, applied, placed or deployed.

The panel and its migration history cannot stand on a PWDB-only database.
`migrations/versions/0001_editor_identity.py` runs `ALTER TABLE cnr_recipe`
unconditionally, and `app/models.py` maps `cnr_profession`, `cnr_station`,
`cnr_category`, `cnr_material`, `cnr_recipe`, `cnr_recipe_component` and
`cnr_tradeskill`. Decoupling them is a separate design change, so the accepted
decision is to carry the CNR schema, catalogue and engine into PROD while
leaving the gameplay switched off.

### Source and build

`src/cnr/` is present and byte-identical to DEV: 170 `nss`, 4 `nui`, 506 `uti`,
62 `utp` and 5 `dlg`. It is untracked. `linux_build.sh` adds
`src/cnr/nss` and `src/cnr/nui` to `SRC_NSS`, and `nasher.cfg` gains
`"cnr*.${shared-files}" = "src/cnr/$ext"` ahead of the shared rule so that a
future unpack keeps new CNR-prefixed resources in the self-contained tree.
Resources already tracked under `src/` keep their existing paths, per the
Nasher rule contract.

### Bridges into the retained legacy module

No legacy system was removed, replaced or reverted. Five existing scripts gained
a call:

| File | Bridge |
|------|--------|
| `wrap_on_mod_load.nss` | `ExecuteScript("cnr_module_oml")` after the existing load work |
| `wrap_on_clnt_ent.nss` | `CnrSkill_Load(oPC)` once PWDB has resolved `character_id` |
| `pb_chat.nss` | `CnrCraft_CaptureTypedId` plus `NWNX_Chat_SkipMessage` while a station is active |
| `rebuild_migrate.nss` | reloads the tradeskill cache after a rebuild migration and warns the DM on failure |
| `dote_romarm4.nss` | the repair threshold reads `CnrSkill_GetLevel * 5` instead of the persistent `NIVELHERRERIA` |

`guia_pb.dlg.json` links the CNR manual, which PROD lacked.
`mti_libreria.nss` gains the two tradeskill helpers (`GetSkillName` and the
XP-to-level calculation) that `cnr_i_skill` requires; the file is Windows-1252
and was reapplied through a reversible Latin-1 conversion after a
`WINDOWS-1252` conversion truncated it at byte 7640. `inc_effect_ids.nss` is
new and untracked. `pb_potion_inc.nss` now includes `lib_race` itself in both
repositories: it called `PB_Race_GetIsUndead()` and compiled in DEV only
because another consumer included that library first.

### Palette

CNR blueprints ship from `src/cnr/uti` and `src/cnr/utp`, but the custom palette
is a single module-wide index and remains an integration-owned resource under
`src/shared/itp/`. The two PROD palettes received an additive merge from DEV,
restricted to entries whose blueprint exists under `src/cnr/`: 256 entries into
`itempalcus.itp.json` (custom node `6687/6688`, 433 to 689 leaves) and 62 into
`placeablepalcus.itp.json` (same node, 81 to 143 leaves). The diff is 2816 and
682 inserted lines with zero deletions; no existing entry was removed, reordered
or renamed. `x0_it_mmedmisc04`, a stock resref DEV lists as the jeweller tool
kit, was skipped: it has no blueprint under `src/cnr/uti` and no reference in
the PROD CNR sources or migrations.

### Duplicate blueprints

Copying `src/cnr/` into PROD produced 187 `.uti` resources present under both
`src/cnr/uti/` and `src/shared/uti/`. DEV does not have them because the shared
copy is removed whenever CNR takes ownership of a resource. A module cannot ship
two resources with one resref, and the compiler cannot see the conflict: Nasher
resolves it at pack time through `onMultipleSources`, whose default is `choose`,
so with `linux_build.sh` running `--yes` the winner would be decided by
source order rather than by a decision.

All 187 shared copies were removed with `git rm`, so every duplicated resref
now ships from the CNR tree, which is the same resolution DEV reached: none of
the nine survives under `src/shared/uti/` there either. 178 pairs were
byte-identical, so the packed module receives the same bytes as before. There
were no duplicated `nss`, `utp` or `dlg` resources: `src/shared/nss/` in PROD
holds no `cnr*` script.

Nine pairs diverged and the CNR copy was chosen deliberately:

| Blueprint | What the CNR copy changes |
|-----------|---------------------------|
| `aguja_hierro` | Tag `aguja_hierro` becomes `aguja_cost`, which is what `cnrtailorstable`, `cnrsewingtable` and `02_seed.sql` require |
| `bru_aza`, `bru_obs`, `polvo_aza`, `polvo_obs` | Name colour code only |
| `carplenyo_olmo`, `carptablon_olmo` | Name and description: "del crepusculo" becomes "de Lenocaso" |
| `carptablon_cipre` | Name: "Tablones de cipres" becomes "Tablones de cedro"; its description already said cedar |
| `virutasresplande` | Plain name becomes a coloured name |

Base item, cost, stack size, charges, plot flag and property lists were already
identical in all nine.

Three CNR tool instances inside the store of `src/module/git/_basefaccione001.git.json`
still carried the legacy tag and name, and a store instance keeps its own copy
of those fields rather than reading the blueprint. They were aligned with DEV,
field by field, leaving the store slot positions untouched: `aguja_hierro`
becomes tag `aguja_cost` and "Aguja de Costura", `aguja_grande` becomes tag
`aguja_cost` and "Aguja Grande de Costura", and `x0_it_mmedmisc04` becomes "Kit
de herramientas de Orfebre".

The retained legacy leatherworking script `cierra_marroqui.nss` rejects any
needle whose tag it does not know, and retagging the basic needles to
`aguja_cost` makes a newly bought one unusable there. That tag was briefly added
to its accepted list and then removed on 2026-09-13: the owner's decision is
that the legacy leatherworker is deprecated and will not be kept working against
CNR items. The script is untouched again, `aguja_acero`, `aguja_aceroscuro` and
`aguja_mithril` remain legacy blueprints under `src/shared/uti/`, and a needle
already in a player's inventory keeps whatever tag it was created with. DEV does
not have this script at all; CNR replaced it.

`src/shared/uti/x0_it_mmedmisc04.uti.json` was missing from PROD entirely. It
carries tag `tall_kittall`, the jeweller tool kit the CNR catalogue reads, and
its absence was why the generated catalogue named that tool "Kit de herramientas
del tallador". The blueprint was copied from DEV and its palette entry added, so
the earlier decision to skip that one entry is superseded.

### Blueprints outside every palette

63 CNR jewellery blueprints (`amu_*`, `anillo_*`, the `*_aro` and `*_cadena`
pairs, and `brazalcuero`) appear in no palette, in DEV either. This is a
pre-existing shared gap, not a port regression, and it blocks nothing: it only
means a builder cannot import those blueprints from the toolset. It is fixed in
DEV first.

### Other resource dependencies

The 52 `placeables.2da` rows used by the CNR placeables all exist in PROD and
are identical to DEV, and the 84 `baseitems.2da` rows used by the CNR items all
exist (row 53 differs only in trailing whitespace). No CNR blueprint uses a
custom TLK entry: the highest string reference is 111445. The other seven
palettes hold no CNR entry in either repository.

### Areas

The PROD map keeps 108 legacy station instances across 22 areas and no modern
CNR station. They are deliberately not converted: some placements are decoration
or a fireplace, and others select a different trade through their tag. Each one
is a separate decision for a later slice.

### Verification completed

Focused NWScript compilation of the CNR slice in PROD: 157 successful, 22
skipped, 0 errors. `pb_mod_activate.nss` in DEV: 1 successful. `bash -n
linux_build.sh` passed. `migration/{01_schema,02_seed,03_catalogue}.sql` are
identical to DEV, and `diff -qr src/cnr` against DEV is empty. Focused compilation of `cierra_marroqui.nss` after the needle-tag change: 1
successful, 0 errors. `migration/build_catalogue.py --check` passes in PROD and its output is
byte-identical to the DEV run: 559 recipes intact, 71 materials, 39 categories,
1287 components, 647 properties, 0 external references. It failed twice on the
way there, first on the 76 `cnr_base_*` blueprints absent from the palette and
then on a stale `03_catalogue.sql`, whose single differing row was the jeweller
tool name described above.

Remaining work: package the module, apply the database baseline, decide the
legacy station placements one by one, and version the untracked slice. `04_drop_legacy.sql` drops `recipe_metadata`, `material_properties` and
`cnr_craft_selection`; that is harmless on the empty baseline but is a deletion
to decide before it ever runs against a populated production database.

## MIG-016 — Trade merchants and their stores

Date: 2026-09-12

Status: Implemented in the PROD source tree and statically verified; nothing
packaged, applied or deployed.

The profession masters in PROD still run the legacy conversations: they teach a
trade, buy nuggets, ingots and hides, sell moulds and tools, and open a store as
one option among many. CNR owns all of that now, so DEV cut the trade out of
every conversation that carried it.

That cut has two shapes, and an earlier draft of this entry wrongly described
all 26 files as having the first one. **Eighteen are profession merchants and
are now one entry and two replies**, "Abrir tienda" and "Salir", with the store
tag passed as the conversation action parameter `tienda`: `curtidor`,
`jj_toigan`, `oficios_artarcan`, `oficios_carp`, `oficios_orf`,
`oficios_peletero`, `ormc_tienda`, `quim_curtidor`, `sapo_artes_arca`,
`sapo_cmcueros`, `sute_her_c_base`, `sute_met_c_base`, `tyr_druidaherbo`,
`uri_her_c_base`, `uri_horgen`, `uri_korgan`, `uri_oficios_carp` and
`uri_oficios_orf`. **The other eight are not merchants of a trade and keep their
own conversation**, having lost only the branches that taught or traded:
`cam_rio_cazado01` (3 entries / 3 replies), `cromwell` (24/43), `flechero`
(4/5), `gof_inuslarga` (5/5), `ko_nash_hansen` (2/2), `mainah_mda` (2/2),
`oro_im` (2/2) and `pb_x_coramrueda` (4/6). What holds for all 26 is narrower
and is what was actually verified: none of them references a trade-teaching
script any more, and the only trade scripts left anywhere in them are store
openers.

The 26 conversations DEV trimmed were copied verbatim, and every one is now
byte-identical to its DEV counterpart:

`cam_rio_cazado01`, `cromwell`, `curtidor`, `flechero`, `gof_inuslarga`,
`jj_toigan`, `ko_nash_hansen`, `mainah_mda`, `oficios_artarcan`, `oficios_carp`,
`oficios_orf`, `oficios_peletero`, `ormc_tienda`, `oro_im`, `pb_x_coramrueda`,
`quim_curtidor`, `sapo_artes_arca`, `sapo_cmcueros`, `sute_her_c_base`,
`sute_met_c_base`, `tyr_druidaherbo`, `uri_her_c_base`, `uri_horgen`,
`uri_korgan`, `uri_oficios_carp`, `uri_oficios_orf`.

The order armourers were cut to the same shape, beyond what DEV did. DEV left
`ormc_tienda`, `uri_horgen` and `uri_korgan` with their dragon scale armour,
their weapon repair and their day/night greetings once the legacy smithing
branches were gone; the accepted decision for PROD is that a profession
merchant does nothing but open its store, so each of the three is now one
greeting and the two replies, opening the same store it opened before through
`abretiendas`, `ko_equipo_basi_3` and `ko_equipo_basi_2` respectively. What
they lose is the dragon scale armour conversation (`elg_escamas3` to
`elg_escamas6`), both weapon repair paths (`dote_romarm3`, `dote_romarm4`) and
the conditional night and faction greetings. PROD and DEV therefore differ on
these three files until the same cut is made in DEV.

Those conversations reference 51 scripts. Fifty already existed in PROD;
`ofi_abre_tienda.nss` did not and was copied from DEV. It is the single opener
for every master: it reads the `tienda` action parameter, resolves the store by
tag and calls `gplotAppraiseOpenStore`, so a new profession needs a dialogue and
a placed store rather than another script. Focused compilation: 1 successful,
0 errors.

No conversation in PROD teaches a legacy trade any more, and none buys or sells
nuggets, ingots, hides, moulds or tools: the only scripts left on any of these
27 files are store openers.

Six of the thirty stores in `src/module/git/_basefaccione001.git.json` carried a
legacy stock list and were replaced with the DEV inventory, item for item. The
other 24 were already identical and were not touched, and nothing outside
`StoreList` was modified.

| Store | Items before | Items after |
|-------|--------------|-------------|
| `tienda_herreria` | 48 | 14 |
| `tienda_orfebreria` | 11 | 7 |
| `tienda_peleteria` | 20 | 16 |
| `ko_floristeria` | 20 | 19 |
| `tienda_herbologia` | 8 | 7 |
| `tienda_artarcana` | 5 | 4 |

Store items are stored inline in the area file, so the shelves now hold what DEV
sells; a copy already in a player's inventory is unaffected. 518 of the resrefs
sold across the area have no blueprint under `src/`, which is the same shape as
DEV's 520: those items come from the game data and the haks, not from module
sources.

`area001` was left alone. DEV places a `tiendaenano` store with 443 items and one
creature there and PROD has neither, but that is a merchant, not a profession
master, and it is outside this slice.

Remaining work: none for this entry beyond the packaging and runtime tests owed
by MIG-015.

## MIG-017 — Timelock port and the potion library's effect calls

Date: 2026-09-12

Status: Implemented in the PROD source tree and statically verified; nothing
packaged or deployed. Deliberately scoped to two files.

### inc_timelock

`src/shared/nss/inc_timelock.nss` was replaced with the DEV version and is now
byte-identical to it. The 26 public functions are unchanged, so no caller had to
be touched; `SetTimelock` gains an optional trailing `bMuted` that nothing in
PROD passes yet. What the DEV version fixes, as its own comments record:

- the current time was a global initialised once when the including script
  started, so every question was answered against a frozen clock. Invisible
  inside one script, wrong across a `DelayCommand`, which is how the status
  messages run. It now reads the clock through `_TimelockNow()`;
- a permanent lock zeroed that shared clock instead of a local base, after which
  every later question in the same script compared against zero and answered
  that everything was locked;
- `SetTimelock` muted every lock the moment it created it, so the "available
  again" notice could never fire.

Thirteen PROD scripts include it: focused compilation returns 10 successful,
3 skipped (the includes among them), 0 errors.

### pb_potion_inc adapted to the effect helpers PROD still runs

The copied `src/cnr/nss/pb_potion_inc.nss` was written against DEV's
`inc_effects` layer, which PROD does not have: its `gsSPApplyEffect` takes a
fifth `sTag` argument and its `gsSPRemoveEffect` takes an `FX_SUBTYPE_*` policy.
PROD keeps both helpers inside the monolithic `inc_spells`, where apply has four
parameters and the fifth parameter of remove is `bForceRemove`. The file
therefore could not compile here, and nothing had noticed: an include has no
`main()`, so the focused check only parses it — it was one of the 22 skipped.

The accepted decision is to adapt the file rather than port the spell stack. Two
mechanical changes, 33 call sites:

- the 15 apply calls now tag the link themselves,
  `gsSPApplyEffect(oPC, TagEffect(eLink, FX_ID_X), SPELL_INVALID, fDuration)`.
  `TagEffect` is what DEV's layer calls internally, and PROD's
  `gsSPRemoveEffect` already filters on `GetEffectTag`, so the identity survives;
- the 18 `FX_SUBTYPE_SAFE` arguments became `FALSE`. PROD's `bForceRemove` at
  FALSE skips `SUBTYPE_SUPERNATURAL` and `SUBTYPE_UNYIELDING`, which is exactly
  what SAFE means. No call used UNYIELDING or ALL, so nothing else maps.

A header note in the file records both changes and that they are reverted when
`inc_effects` is ported. `PROD` and `DEV` copies of this one file now differ on
purpose; every other file under `src/cnr/` remains identical.

Verified by compiling a throwaway script that includes the library, outside the
repository, against the real PROD include roots: 1 successful, 0 errors. That is
the only way to compile an include semantically rather than parse it.

### Still not wired

`pb_mod_activate.nss` line 118 continues to call `usarPocionHerboristeria` from
`src/shared/nss/sute_libreria.nss`, the legacy library, which also gives it
`FuncionCrearObjetoYTag` (10 uses) and `bonoRealCaracteristicaPJ` (2). Both
libraries define `usarPocionHerboristeria`, so the switch requires retiring that
one function from `sute_libreria`, and that was deliberately left for later. The
potion library is therefore correct and compilable in PROD but still inert.

Remaining work: port `inc_effects` and revert the two adaptations, then move the
activation entry point.

## MIG-018 — The skinning knife CNR asks for

Date: 2026-09-13

Status: Implemented in both repositories; no runtime validation.

`cnr_skin_onused.nss` refuses to skin unless the player holds an item tagged
`cnrSkinningKnife` in either hand, and no blueprint anywhere carried that tag,
in either repository. Hide gathering could therefore never have worked. The
legacy `desollador` blueprint under `src/shared/uti/` has the tag `desollador`
and no script reads it.

`src/cnr/uti/cnr_desollador.uti.json` is modelled on that legacy knife, keeps
its dagger base item and its single property, and carries the tag CNR reads. It
is in the custom item palette and the leatherworking store sells it for 20 gold,
unlimited. Nothing else was changed: no recipe produces it yet and no node is
placed, because hide gathering and node normalisation are the next slice.

The `aguja_cost` compatibility line added to `cierra_marroqui.nss` on 2026-09-12
was removed the following day: the legacy leatherworker is deprecated and is not
being kept alive against CNR items.

## CNR port roadmap

The PWDB slice (MIG-001 to MIG-014) and the CNR slice (MIG-015 to MIG-017) are
implemented in the PROD source tree and statically verified. Nothing has been
packaged, applied to a database, or deployed. This is the order the remaining
work is meant to run in, and what blocks each phase.

| Phase | Work | Blocked by |
|-------|------|-----------|
| A. Version the slice | Review and commit the accepted PROD slice, changelog entries included, then run the independent audit gate on that candidate commit | nothing |
| B. Build | Produce `PB_EE_PROD.mod` and record its checksum; confirm no `unknown/` directory appears | A |
| C. Local rehearsal | Apply the database baseline on an empty database, run the Alembic chain, start the stack, create the first administrator, and run the tests each changelog entry names | B, plus the `04_drop_legacy.sql` decision |
| D. Host | DNS, HTTPS reverse proxy, final origin and cookie policy, host credentials, upload and rollback | C |
| E. Stations | Decide the 108 legacy station instances across 22 areas one at a time, and place the modern CNR stations | C, and only worth doing once crafting is testable |
| F. Effects layer | Port `inc_effects`, revert the two `pb_potion_inc` adaptations, and move the potion entry point off `sute_libreria` | nothing technically; deliberately deferred |
| G. Legacy retirement | Retire `sute_libreria`'s potion function, the `tall_tall_*` jewelcrafting scripts, the deprecated `cierra_marroqui` leatherworker, and whatever else CNR has replaced | E and F |
| H. Reconciliation | Bring DEV level with the decisions PROD took, and fix the PROD documentation structure | nothing; independent of deployment |

Phases A to D are the production migration proper. E to H are the CNR
transition, and none of them is a prerequisite for putting PWDB in production.

## Debt carried forward

Recorded here so a later session does not have to re-derive it.

**Source control.** The accepted slice is not versioned: `src/cnr/` (747
resources), `src/shared/nss/inc_effect_ids.nss`, `src/shared/nss/ofi_abre_tienda.nss`
and `src/shared/uti/x0_it_mmedmisc04.uti.json` are untracked, 187 `src/shared/uti`
deletions are staged, and `cnr-editor/`, `migration/` helpers and the deployment
scripts listed under MIG-002 remain untracked. A pull or clone delivers none of
it.

**Changelog commit ids.** Every entry written for this work carries
`**Commits.** \`<pending>\``. The audit gate reads one commit, so each entry has
to travel in the commit that makes its change, and the id is filled in
afterwards in the single direct child.

**Deliberate DEV/PROD divergences.** Two, both recorded in their MIG entry:
`src/cnr/nss/pb_potion_inc.nss` carries the effect-call adaptation (MIG-017),
and `ormc_tienda`, `uri_horgen` and `uri_korgan` are cut to store-only in PROD
while DEV still has their dragon scale armour and weapon repair (MIG-016). Both
are decisions, not drift, and both need mirroring or reverting eventually.

A third: production no longer names anything `-dev`. `linux_build-dev.sh` and
`linux_run_server-dev.sh` are `linux_build.sh` and `linux_run_server.sh`,
`docker-compose-dev.yml` and `config/nwserver-dev.env` are gone, and every
document in this repository names the new files. Development keeps the old
names, so the command lines quoted in this ledger differ between the two copies
of it from 2026-09-13 onwards. Anything run in production before that date used
the old name.

**DEV working tree.** `src/cnr/nss/pb_potion_inc.nss` in DEV holds an
uncommitted one-line `#include "lib_race"` fix.

**Shared gaps.** 63 CNR jewellery blueprints (`amu_*`, `anillo_*`, `*_aro`,
`*_cadena`, `brazalcuero`) are in no palette in either repository. PROD has no
`scripts/check_documentation.py`, so its documentation structure is unchecked.

**Transitional code that has to come out.** `sute_libreria.nss` still owns the live `usarPocionHerboristeria`; PROD keeps the
`tall_tall_*` jewelcrafting scripts DEV deleted; and the module runs two effect
systems side by side, `PJ_Efecto*`/`ApplyTaggedEffectToObject` and `gsSP*`.

**Why the spell stack was not ported.** DEV's `inc_spells` facade and its five
files do not define 16 functions PROD still calls: `ApplyTaggedEffectToObject`,
`CreateNonStackingPersistentAoE`, the six `*AoE*` helpers, `PJ_EfectoBuscarTag`,
`PJ_EfectoQuitar`, `PJ_EfectoQuitarTag`, `ReadySingleMemorizedSpell`,
`gsC2AdjustSpellEffectiveness` and `IntDivisionRounding`, plus three constants.
Swapping the stack means porting or rewriting their callers, which is NEXT-012,
not an import.

## Open work

| ID | Status | Work |
|----|--------|------|
| NEXT-001 | Pending | Review and deliberately version the complete accepted PROD slice, especially currently untracked paths |
| NEXT-002 | Pending | Build `PB_EE_PROD.mod` and record the artifact/checksum |
| NEXT-003 | Pending | Perform the local production rehearsal and record every runtime result |
| NEXT-004 | Pending | Establish host DNS, HTTPS reverse proxy, final origin and secure-cookie policy |
| NEXT-005 | Pending | Replace all host credentials and preserve the MySQL/MFA secret backup |
| NEXT-006 | Pending | Apply the empty production database baseline and Alembic chain |
| NEXT-007 | Pending | Create the initial production administrator |
| NEXT-008 | Pending | Execute the host upload and rollback plan |
| NEXT-009 | Pending | Correct the PROD repository instruction/documentation structure independently of runtime deployment |
| NEXT-010 | Pending | Continue the disguise/community-name security redesign after PWDB containment is proven |
| NEXT-017 | Pending | Decide and convert the 108 legacy station instances across 22 areas, then place the modern CNR stations |
| NEXT-018 | Partly done | `sute_libreria`'s potion function is gone. Still to retire: `tall_tall_*`, the deprecated `cierra_marroqui`, `desollador`, `kitdesollador`, the `NIVELDESOLLADOR` persistence and the two unreachable Festyx skinning scripts |
| NEXT-019 | Partly done | The three armourer dialogues were restored from DEV on 2026-09-14 and the two repositories match again. The `pb_potion_inc` effect adaptation is still a deliberate divergence |
| NEXT-020 | Pending | Replace every `**Commits.** \`<pending>\`` in the changelog entries with the candidate commit id |
| NEXT-011 | Partly done | CNR engine, resources, palette entries and bridges ported by MIG-015; area/station placement and legacy retirement still deferred |
| NEXT-015 | Pending | Add the 63 CNR jewellery blueprints to the item palette, in DEV first |
| NEXT-016 | Partly done | The potion entry point moved off `sute_libreria` on 2026-09-14 and CNR serves the potions. Porting `inc_effects` and reverting the two `pb_potion_inc` adaptations remain deferred |
| NEXT-012 | Deferred | Port arcane-fire, caster-level and other spell/effect reworks |

## Follow-up entry template

Append future accepted work here instead of rewriting prior evidence:

```text
## MIG-XXX — Short title

Date:
Status:
Requested outcome:
Decision and scope:
Files added or changed:
Database/configuration impact:
Verification completed:
Runtime evidence:
Deployment impact:
Remaining work:
```
