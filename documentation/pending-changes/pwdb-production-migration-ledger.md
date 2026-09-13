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

- CNR module scripts and area/station integration;
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
| Database baseline | Manual SQL and Alembic `0001` through `0019` are present | Present; not applied |
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
5. Keep `docker-compose-dev.yml` as the ordinary local development variant,
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

`pdb-prod/linux_build-dev.sh` now compiles against the two script roots that
actually exist in PROD, `src/shared/nss` and `src/pwdb/nss`, and expects
`modules/PB_EE_PROD.mod`.

`pdb-prod/linux_run_server-dev.sh` stages that same artifact together with the
development server env, MySQL env, MySQL initialization helper, Grafana
provisioning and TLK files. It then uses `docker-compose-dev.yml`, which does not
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
| InfluxDB | `influxdb:1.7` |
| Grafana | `grafana/grafana:6.0.1` |

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
| `config/nwserver-dev.env` | Local/test NWN and explicit NWNX_SQL connection settings | Local rehearsal only |
| `config/mysql.env` | MySQL root password, database, application user/password and panel MFA encryption key | Ignored/private; create from `config/mysql.env.example`, preserve across restarts and back it up privately |
| `config/grafana.env` | Grafana administrator password | Replace for the host |
| `config/influxdb.env` | InfluxDB database and users/passwords | Replace for the host |
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
productive Compose, ensures MySQL/InfluxDB/Grafana are running, stops only
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
`0001_editor_identity.py` through `0019_account_access_security.py`.

No migration, dump, restore or database initialization was executed during this
work.

## MIG-008 — Administration panel deployment boundary

Status: application files present; Compose configuration verified; panel not
built or started.

The copied panel includes its backend, frontend, container definitions, tests
and all Alembic revisions through `0019`. The relevant administration behavior
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
`http://localhost:8088` and insecure cookies. For a host deployment, the exact
public HTTPS origin must replace it and `CNR_EDITOR_COOKIE_SECURE` must be true.
`cnr-editor/remote.env` intentionally contains a non-routable placeholder origin
so it fails closed until the real host URL is supplied.

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
| PROD `docker-compose-dev.yml` render | Passed |
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
- `config/nwserver.env` and `config/nwserver-dev.env`;
- `docker-compose.yml` and `docker-compose-dev.yml`;
- `linux_run_server-dev.sh`;
- `nasher.cfg`;
- `src/module/ifo/module.ifo.json`;
- `src/shared/dlg/borrarpjs.dlg.json`;
- `src/shared/nss/wrap_on_clnt_ent.nss`.

### Critical untracked paths

- `cnr-editor/`;
- `migration/`;
- `config/mysql-init/` and `config/mysql.env.example`;
- `db-apply.sh`, `web-restart.sh`, `run-server.sh`, `server-restart.sh` and
  `linux_build-dev.sh`;
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
6. Start the panel so its API applies Alembic through `0019`.
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
- Confirm the panel works through its final HTTPS URL with secure cookies and
  rejects an unexpected browser origin.

## Preliminary host upload manifest

### Build input or reviewed source

- `nasher.cfg`;
- `linux_build-dev.sh`;
- `src/pwdb/nss/`;
- the integration and rebuild resources listed in MIG-002 and MIG-003;
- `src/shared/nss/nw_c2_default9.nss`;
- `src/shared/nss/wrap_on_ply_lvl.nss`;
- `src/shared/utc/pb_crienccaravan.utc.json`;
- `src/module/ifo/module.ifo.json`.

### Host runtime

- the built `modules/PB_EE_PROD.mod`;
- `docker-compose.yml`;
- `run-server.sh`;
- `server-restart.sh`;
- `config/nwserver.env` with host values;
- private `config/mysql.env` with host values;
- `config/mysql-init/`;
- `config/grafana.env`, `config/influxdb.env` and Grafana provisioning;
- existing PROD module/vault/override/TLK/HAK content already owned by the host.

### Database and panel

- `migration/`;
- `db-apply.sh`;
- `cnr-editor/`;
- `web-restart.sh`;
- a host-specific `cnr-editor/.env` with the exact HTTPS origin.

### Local rehearsal only

- `docker-compose-dev.yml`;
- `config/nwserver-dev.env`;
- `linux_run_server-dev.sh`.

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
  `./linux_build-dev.sh --check nw_c2_default9.nss` — one successful, zero
  skipped, zero errors;
- PROD focused compilation:
  `./linux_build-dev.sh --check nw_c2_default9.nss wrap_on_ply_lvl.nss` — two
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
| NEXT-011 | Deferred | Port CNR gameplay integration |
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
