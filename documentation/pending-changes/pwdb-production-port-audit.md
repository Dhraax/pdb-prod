# PWDB Production Port Survey

Implementation status and all follow-up work are tracked in the
[PWDB production migration ledger](pwdb-production-migration-ledger.md).

## Status and purpose

This is the active, decision-gated survey for porting the current PWDB identity
and administration system from `pdb-dev` into `pdb-prod`. It records observed
repository evidence, discrepancies, decisions still owed, and the eventual
production deployment manifest.

The initial comparison was read-only. On 2026-09-08 the owner approved the first
PWDB-only implementation slice. PROD source and runtime templates are now being
updated without running a build, migration, service operation or deployment.

Survey date: 2026-09-08.

## Repositories and authority

| Role | Path | Authority in this survey |
|------|------|--------------------------|
| DEV implementation | `/mnt/e/projects/nwn/nwn-assets/pdb/pdb-dev` | Current PWDB behavior and intended architecture, including relevant uncommitted worktree changes |
| PROD target | `/mnt/e/projects/nwn/nwn-assets/pdb/pdb-prod` | Production module resources and production-specific integration points |
| Legacy production runtime | `pdb-dev/docker-compose-pdb.yml` | Existing production NWN:EE/NWNX:EE runtime values that must be preserved or explicitly retired |

The intended result is PWDB functional parity, not whole-module file parity.
Production-owned areas, maps, and palette differences are outside the copy
boundary unless a specific PWDB resource requires an integration merge.

Environment files and Compose configuration are sensitive. This document will
record variable names, ownership, required/optional status, and value sources,
but never credential values.

## Survey sequence

| Phase | Status | Output |
|-------|--------|--------|
| Repository baselines and dirty-state boundary | Complete | Exact comparison inputs and exclusions |
| PWDB module resource manifest | In progress | Same, different, missing, PROD-only, and merge-required resources |
| Module event and legacy integration review | In progress | Exact IFO fields, wrappers, delegates, containers, dialogues, and item dependencies |
| Database and panel review | In progress | Migration chain, models, API, permissions, frontend, bootstrap, and initial administrator requirements |
| Compose and environment comparison | In progress | Redacted service/variable/volume/plugin matrix |
| DEV runtime gaps inherited from legacy PROD | In progress | Values that need an explicit decision for DEV and PROD |
| First PWDB-only implementation slice | In progress | PROD hooks, rebuild activation, build identity, MySQL/NWNX_SQL and persistent log runner |
| Production upload and execution manifest | In progress | Exact files, secret inputs, migration order, startup order, validation, and rollback |

## Confirmed initial findings

### F-001: the production instruction contract is a DEV copy

`pdb-prod/AGENTS.md` identifies the repository as `PDB DEV`, names the DEV
artifact `PB_EE_PGCC.mod`, and describes DEV build and server scripts. It also
requires `agents-config/AGENTS.md`, but `pdb-prod/agents-config/AGENTS.md` is
absent.

This is a repository-governance discrepancy, not yet evidence of a PWDB runtime
failure. It must not be corrected as part of the survey without a separate
decision because production artifact names and workflows need to be established
from `pdb-prod/nasher.cfg` and its actual scripts first.

### F-002: the legacy production Compose exists only in the DEV survey root

The supplied legacy file is `pdb-dev/docker-compose-pdb.yml`. No
`docker-compose-pdb.yml` currently exists at the `pdb-prod` root. PROD does
contain `docker-compose.yml`, `docker-compose-dev.yml`,
`config/docker-compose-template.yml`, `cnr-editor/compose.yml`, and a staged
`server/docker-compose.yml`.

The legacy file will be treated as configuration evidence, not copied blindly.
Its services, image tags, variables, volumes, networks, restart policy, and
NWNX options must be compared field by field with the maintained templates.

### F-003: the DEV reference includes an uncommitted access-security slice

The current DEV worktree contains PWDB access-history and pre-character-list
security changes outside `HEAD`, including migration `0019`, new NWScript access
resources, PWDB include changes, backend identity API changes, tests, and
frontend account-management changes.

The survey therefore compares PROD with the current DEV worktree. Using only a
commit-to-commit comparison would omit part of the system the owner intends to
promote.

### F-004: the six dedicated PWDB sources match

Both repositories currently contain the same six files under `src/pwdb/nss/`,
and recursive content comparison reports no difference:

- `pwdb_c_config.nss`;
- `pwdb_ev_connect.nss`;
- `pwdb_i_access.nss`;
- `pwdb_i_db.nss`;
- `pwdb_i_user.nss`;
- `pwdb_mod_act.nss`.

This confirms that the dedicated source directory was copied. It does not prove
that the module events invoke those resources or that all their includes exist.

### F-005: the Alembic migration files through 0019 match

Both repositories contain migrations `0001_editor_identity.py` through
`0019_account_access_security.py`. Recursive content comparison, excluding
Python cache directories, reports no difference in the migration directory.

Application and runtime configuration still need to prove that PROD actually
runs this chain against the intended persistent MySQL database. File presence
alone is not an applied-migration result.

### F-006: PROD does not initialize PWDB or subscribe the pre-vault gate

Both module IFOs invoke `wrap_on_mod_load`, but the PROD copy of that script is
the legacy version. It neither includes `pwdb_i_user` nor calls
`PWDB_EnsureIdentitySchema()`.

That function performs two required operations in DEV: it subscribes
`pwdb_ev_connect` to `NWNX_ON_CLIENT_CONNECT_BEFORE`, then ensures the identity
schema. Without the PROD merge, the new global CD-key ban and account ownership
check do not execute before the server-vault character list. This is a critical
activation blocker even though `pwdb_ev_connect.nss` is present.

Only the PWDB include and initialization call are candidates for the later PROD
merge. DEV's unrelated `cnr_module_oml` call must not be copied as part of this
slice.

### F-007: the rebuild wand resources exist but its activation wrapper is not wired

The rebuild UTI, both dialogues, and all named `rebuild_*` scripts compare equal
between DEV and PROD. `pwdb_mod_act.nss` also exists and delegates unrelated
activations to PROD's current `pb_mod_activate` handler.

However, PROD's `module.ifo` still assigns `Mod_OnActvtItem` directly to
`pb_mod_activate`; DEV assigns it to `pwdb_mod_act`. Therefore the copied wand
cannot open its workflow through the module event, and activating
`dmfi_exploder` does not grant it. The eventual change is a one-field IFO merge,
not replacement of the complete production IFO.

### F-008: copied integration scripts currently depend on absent CNR sources

PROD has no `src/cnr/nss/cnr_i_skill.nss`. Nevertheless, the copied
`wrap_on_clnt_ent.nss` includes `cnr_i_skill` and calls `CnrSkill_Load`, while
`rebuild_migrate.nss` also calls `CnrSkill_Load` after a successful identity
migration.

This makes the current PROD source set incomplete for focused compilation. CNR
must not be pulled into the urgent security port accidentally. A decision is
required between:

1. deliberately porting the required CNR persistence layer as a separate
   accepted dependency; or
2. adapting the two PROD integration scripts so the PWDB-only deployment does
   not reference unavailable CNR resources.

The second option keeps the urgent identity slice bounded, but its exact effect
on the rebuild workflow must be reviewed before implementation.

### F-009: the PROD Nasher configuration still identifies and emits DEV

`pdb-prod/nasher.cfg` currently matches DEV. It names the package `PGCC PDB EE`,
describes the target as `DEV version`, and emits `PB_EE_PGCC.mod`.

That conflicts with the repository's production artifact `PB_EE_PROD.mod` and
with the stated DEV/PROD boundary. The correct production module resref must be
confirmed from the legacy Compose and production scripts before changing the
Nasher target; the copied configuration is not ready for a production build.

### F-010: the control-panel application and migration files match

The maintained files under `cnr-editor/` compare equal between DEV and PROD
after excluding private environment files and generated caches/build output.
This includes backend application code, frontend source, tests, container build
files, the panel Compose file, and all Alembic migrations through `0019`.

This is a positive file-transfer result. It does not yet establish a viable
production topology, HTTPS boundary, applied database state, or initial user.

### F-011: the maintained production Compose neither provides MySQL nor enables NWNX_SQL

The current `docker-compose.yml` is identical in DEV and PROD and defines only
the NWN server, InfluxDB, and Grafana. It has no MySQL service or persistent
MySQL volume. The MySQL service exists only in `docker-compose-dev.yml`.

The production Compose loads `config/nwserver.env`. That environment currently
sets `NWNX_SQL_SKIP=y` and does not provide the MySQL connection variables used
by the DEV runtime. Therefore the copied PWDB module cannot access MySQL through
the maintained production path.

The private `config/mysql.env` file exists in both repositories, but its values
were deliberately not read or compared. Production must receive independently
managed credentials; DEV values must not be promoted as production secrets.

### F-012: Alembic is not a standalone empty-database baseline

The panel API runs `alembic upgrade head` automatically before serving. On a
truly empty database, that chain cannot currently start by itself:

- migration `0001_editor_identity` executes `ALTER TABLE cnr_recipe` and creates
  a foreign key to that pre-existing catalogue table;
- migration `0002_identity_management` creates foreign keys to the pre-existing
  `pwdb_account` and `pwdb_character` tables.

Those base tables are owned outside Alembic by `migration/01_schema.sql` and
`migration/pwdb/01_identity_schema.sql`. Both SQL trees are present and match
between DEV and PROD, but MySQL's current initialization directory contains
only the authentication compatibility helper. It does not establish either
base schema.

For a from-zero production deployment, a deliberate baseline order or a new
consolidated migration is required before the panel container can become
healthy. Starting the copied Compose files does not currently satisfy that
requirement.

### F-013: the initial administrator can be bootstrapped without transferring a user row

`control-panel-bootstrap-admin` refuses to run when any panel user already
exists. On an empty, fully migrated database it interactively creates exactly
one administrator, hashes the supplied password, grants the administrator
permission preset, and grants the available profession scopes.

This is safer and simpler than copying a DEV user row and its dependent
permissions, sessions, MFA state, or encryption-key assumptions. Whether the
owner needs to preserve existing MFA enrollment rather than create a fresh
production administrator remains a decision.

### F-014: the PROD client-entry wrapper is not a bounded PWDB merge

`wrap_on_clnt_ent.nss` compares equal between DEV and PROD, but PROD lacks four
project includes referenced by that copied script:

- `cnr_i_skill`;
- `cnr_recipe_utils`;
- `inc_arcanefire`;
- `inc_casterlevel`.

The base-game include `x0_i0_petrify` is also not stored in the project, which
is expected only if the production compiler resolves it from the game install.

The missing four project includes prove that the current PROD wrapper was not
constructed as a minimal identity hook merge. The later correction must start
from PROD's intended login behavior and add only PWDB ownership/access calls,
unless the owner explicitly expands the slice to the other subsystems.

### F-015: the legacy variable-container contract is available in PROD

PROD provides the `dmfi_pc_emote` blueprint, and it compares equal with DEV.
Its `mti_libreria.nss` still declares `CONTENEDOR_VARIABLES` with that resref and
provides the integer persistence helpers consumed by PWDB. The library differs
from DEV because DEV also contains unrelated later system work; it must not be
replaced wholesale for the identity port.

This establishes the resource and basic helper boundary needed for legacy
`CDKEY` validation. Runtime testing is still required to prove that every
legacy production BIC actually carries the container and stored value.

### F-016: PROD has no production build-and-stage workflow yet

The copied Linux build and launch scripts still use `PB_EE_PGCC.mod`,
`nwserver-dev.env`, and `docker-compose-dev.yml`. The current staged PROD
`server/docker-compose.yml` does not contain MySQL either. A separate legacy
`nwsync.sh` references `PB_EE_PROD.mod`, confirming that the production artifact
boundary has not been reconciled across the newer workflow.

No existing script should be used for the final host handoff until module name,
Compose source, environment source, staging directory, network name, and
persistent volumes agree.

### F-017: the legacy NWNX delta contains one live gameplay option and several retired variables

All compared server definitions use `nwnxee/unified:build8193.37`. The pinned
NWNX source identifies itself as `build 8193.37.17 - v89` at commit
`3d4c4e13c6bf01b032ffe90534fc4a19eb036c03`, so it is suitable evidence for the
plugin configuration exposed by that image family.

The legacy production Compose enables
`NWNX_TWEAKS_UNHARDCODE_SPECIAL_ABILITY_TARGET_TYPE=y`. That option is absent
from both maintained server environment files. The pinned Tweaks documentation
states that it permits special abilities to target object types other than
creatures. It was added in the 8193.37 line and is therefore a real candidate
to restore in both DEV and PROD so the maintained configuration does not change
established production gameplay.

The following legacy variables should not be copied merely to obtain textual
parity:

- `NWNX_DATA_SKIP`: the Data plugin was removed in 8193.24;
- `NWNX_TIME_SKIP`: the Time plugin was removed in 8193.24;
- `NWNX_BEHAVIOURTREE_SKIP`: the BehaviourTree plugin was removed earlier;
- `NWNX_JVM_CLASSPATH`: JVM remains skipped, so its classpath has no runtime
  consumer.

The removal history is recorded in the pinned `nwnxee/CHANGELOG.md`. The
8193.37 release family and the special-ability tweak are also documented by the
[official NWNX:EE releases](https://github.com/nwnxee/unified/releases) and
[upstream changelog](https://github.com/nwnxee/unified/blob/master/CHANGELOG.md).

The maintained files already explicitly enable the PWDB-required plugins:
Events, Administration, and SQL headers are available, but production still
disables the SQL plugin as described in F-011. DEV's enabled profiler and
InfluxDB metrics are a temporary measurement configuration; they must not be
promoted to PROD as an accidental PWDB requirement.

### F-018: NWSync has two variable names in the custom runner

The current environment files correctly use `NWN_NWSYNCURL`, matching the
pinned upstream Docker runner. The legacy production Compose used
`NWNX_NWSYNCURL` instead.

The repository's custom `run-server.sh` accepts `NWN_NWSYNCURL` in its argument
array but also appends a second unconditional `-nwsyncurl` argument sourced from
the legacy `NWNX_NWSYNCURL`. Enabling this runner with only the maintained
variable can therefore pass both the intended URL and a later empty value. This
must be corrected before the custom runner becomes the production entrypoint;
the legacy variable should not be restored as a second source of truth.

### F-019: the maintained Compose does not use the custom log-preserving runner

`run-server.sh` compares equal between DEV and PROD and implements timestamped
console capture, recovery of runtime `logs.*`, graceful shutdown archival, and
persistence of crash/configuration files under `/nwn/home`.

The supplied legacy production Compose explicitly sets
`entrypoint: /nwn/home/run-server.sh`, mounts a persistent host directory at
`/nwn/home`, enables `NWN_TAIL_LOGS=y`, grants a two-minute stop period, and
limits Docker's local log rotation. The maintained DEV and PROD Compose files do
not set that entrypoint, set `NWN_TAIL_LOGS=n`, omit the two-minute stop period
and Docker log limits, and instead bind the host `logs` directory directly onto
runtime `logs.0` paths.

Consequently the maintained stack does not currently invoke the repository's
archive logic. Simply adding the entrypoint is also unsafe: its startup recovery
tries to move `/nwn/run/logs.*`, while the maintained Compose makes
`/nwn/run/logs.0` a bind-mount root that cannot be moved normally. The runner
and volume design must be reconciled as one later infrastructure slice rather
than toggling a single line.

### F-020: MySQL 8.4 needs both the server flag and the initialization helper

The DEV MySQL service starts `mysql:8.4` with
`--mysql-native-password=ON`, mounts `config/mysql-init`, and runs
`01-nwnx-compatible-auth.sh` only when the data volume is initialized. That
helper changes the application user to `mysql_native_password`, which the
tested NWNX_SQL client requires.

The helper exists and matches in PROD, but the maintained production Compose
does not define or mount a MySQL service. Adding only the image would therefore
be incomplete. The eventual production service must preserve the command flag,
initialization mount, healthcheck, named data volume, and NWN dependency on a
healthy database. Changing the private environment later does not rerun init
scripts against an existing volume.

### F-021: the panel's production controls exist, but its launch topology is incomplete

The panel Compose intentionally runs separately and joins an external network.
It defaults to `server_default`, expects the database environment at
`../server/config/mysql.env`, and does not create MySQL. PROD contains a
`remote.env` with the full set of non-secret production control keys, including
the network and MySQL environment path, but actual values were not copied into
this survey.

The repository-level `scripts/run_cnr_editor.sh` used in DEV is absent from the
PROD worktree. PROD does contain `web-restart.sh`, but that script assumes a
prepared `cnr-editor/.env` and does not validate the external network or staged
database environment before rebuilding the panel.

A stable production network name and staging layout must be selected before
the panel can reliably reach MySQL. The production panel also needs an HTTPS
reverse-proxy boundary and secure cookies before it is exposed outside a
trusted network; neither is provided by the current panel Compose.

### F-022: most legacy NWN gameplay flags match the maintained PROD environment

After normalizing CRLF/LF differences, the legacy Compose and PROD's current
`config/nwserver.env` agree on the compared difficulty, PvP, vault, ELC, ILR,
level, party, autosave, reload, and publication flags.

Material differences are limited to production identity/credentials and these
operational values:

- maximum clients changed from the legacy value of 140 to 120;
- live log tailing changed from enabled to disabled;
- module and server names differ and must be resolved against the intended
  `PB_EE_PROD` artifact rather than copied from DEV;
- passwords differ, as expected, and remain excluded from this document.

The client limit and live-tail behavior require explicit production decisions;
they should not drift merely because `nwserver.env` was copied or regenerated.

### F-023: presence in the PROD directory does not yet mean the port is versioned

The PROD worktree contains a mixed migration state. The five core PWDB files
other than the activation wrapper are tracked and clean, but the following
required groups are currently untracked:

- `src/pwdb/nss/pwdb_mod_act.nss`;
- the five `rebuild_*` executable scripts;
- `rebuild_tool.dlg.json` and `dmfi_rebuild.uti.json`;
- the complete `cnr-editor/` application and Alembic tree;
- `config/mysql.env.example` and the MySQL 8.4 authentication helper;
- all manual SQL migrations under `migration/` used by the from-zero baseline.

The existing `borrarpjs` dialogue, `wrap_on_clnt_ent.nss`, `nasher.cfg`, and both
root Compose files are tracked but modified. `wrap_on_mod_load.nss` and the
module IFO remain tracked and clean, which is consistent with the two missing
runtime hook changes already identified.

This survey does not stage or commit any of those files. The later accepted
implementation must make the selected PROD slice explicit in Git; otherwise a
Git-based host update can silently omit files that are merely present in the
working directory.

### F-024: the Nasher change must be reduced to a production-aware merge

The tracked PROD baseline already used package name `PROD PDB EE` and emitted
`PB_EE_PROD.mod`. The current worktree replaced those values with DEV's package
name, artifact, and target description. It also copied DEV's NUI exclusion and
CNR routing even though the urgent port neither established that PROD can omit
its NUI resources nor contains `src/cnr/`.

The only PWDB-specific routing change evidenced by this survey is placing
`"pwdb_*.nss" = "src/pwdb/$ext"` before PROD's generic shared rule. The later
implementation should restore PROD's package identity and artifact, preserve
its original inclusion boundary, and add only that specific rule unless another
subsystem is approved separately.

### F-025: the existing deletion dialogue was merged narrowly and correctly

The modified PROD `borrarpjs.dlg.json` preserves its graph and changes only
three script bindings required by the rebuild authorization flow:

- conversation abort now runs `rebuild_cancel`;
- the explicit exit path now runs `rebuild_cancel`;
- confirmation now runs `rebuild_bic` instead of the legacy `borrarpjs` script.

It also compares equal with DEV after those changes. No wholesale dialogue
replacement is required for this resource.

## Preliminary PWDB resource matrix

| Resource or boundary | Observed PROD state | Survey disposition |
|----------------------|---------------------|--------------------|
| `src/pwdb/nss/` | Complete and equal to current DEV | Keep as the subsystem transfer unit |
| Alembic `0001` through `0019` | Complete and equal to current DEV | Keep; establish its external base tables first |
| Panel backend/frontend/tests/container files | Equal to current DEV | Keep; production topology and secrets remain pending |
| `wrap_on_mod_load.nss` | PROD legacy behavior preserved byte-for-byte | `pwdb_mod_load` initializes PWDB, then delegates to this script |
| `wrap_on_clnt_ent.nss` | PWDB identity resolution/synchronization retained; unavailable CNR/effect dependencies removed | Focused compilation passed |
| `module.ifo: Mod_OnClientEntr` | Already points to `wrap_on_clnt_ent` | No IFO field change needed for login |
| `module.ifo: Mod_OnModLoad` | Points to `pwdb_mod_load` | PWDB initializes before the preserved PROD load handler |
| `module.ifo: Mod_OnActvtItem` | Points to `pwdb_mod_act` | Rebuild activation delegates unrelated items to `pb_mod_activate` |
| Rebuild UTI/dialogues/scripts | Present; migration no longer imports CNR | Keep in the PWDB-only slice |
| `dmfi_pc_emote` container | Present and equal to DEV | Keep; do not replace the larger PROD `mti_libreria` wholesale |
| NWNX SQL/Events/Administration headers | Present and equal to DEV | Keep; matching runtime plugins must be enabled |
| CNR module sources | Absent | Do not infer they belong to the urgent PWDB slice |
| Manual SQL base schemas | Present and equal to DEV | Establish an approved empty-database order before panel startup |
| Production Nasher/build/staging | Emits and stages `PB_EE_PROD.mod` | Focused compile works; full pack remains owner-controlled |

## Proposed decision gates

### D-001: keep the first module deployment PWDB-only

Recommended decision: approve a bounded PWDB integration instead of copying the
missing DEV subsystems.

That later implementation would:

1. keep PROD's intended `wrap_on_mod_load` behavior and add only
   `pwdb_i_user` plus `PWDB_EnsureIdentitySchema()`;
2. reconstruct PROD's `wrap_on_clnt_ent` from its production behavior, place
   `PWDB_ResolveCharacterId()` and the denial return before any account-owned
   mutation, and call `PWDB_SyncRegisteredCharacter()` after the new-character
   flow can provide the variable container;
3. retain the legacy container CD-key check as a later defense, while PWDB owns
   the authoritative account/CD-key relationship and pre-vault rejection;
4. remove the unavailable CNR reload from the PROD rebuild migration rather
   than importing CNR only to satisfy one call;
5. wire the already present `pwdb_mod_act` through the single activation IFO
   field.

This proposal preserves production gameplay and keeps CNR, arcane effects, and
caster-level work out of the urgent security deployment.

Alternative: port the complete missing CNR/effect dependency graph now. That
would expand the security deployment into unrelated gameplay and is not
recommended.

Decision: approved by the owner on 2026-09-08 and implemented as the first
production slice. A dedicated `pwdb_mod_load` wrapper was used instead of
rewriting the Windows-1252 production load handler.

### D-002: establish the empty MySQL baseline before Alembic

Recommended decision: for the new empty production volume, apply the existing
manual identity and catalogue base SQL in the documented order before starting
the panel API, then let its entrypoint run Alembic through `0019`. This creates
the catalogue tables required by Alembic without activating any CNR module
script. It also leaves the database ready for the later CNR deployment.

`pdb-prod/db-apply.sh` now recognizes the production repository root as a valid
stack, as well as its two legacy staged locations. No database command has been
run; applying this baseline remains an explicit deployment action.

Alternative: redesign the already published Alembic history into a standalone
PWDB baseline. That is a larger schema migration project and is not recommended
for the urgent deployment.

Decision: the required files and execution path are prepared. Execution remains
pending owner approval and the local production rehearsal.

### D-003: create the sole production administrator instead of copying it

Recommended decision: after the empty database reaches Alembic head, run the
interactive bootstrap once to create the owner's production administrator. Do
not transfer DEV sessions, recovery codes, throttles, password material, or an
MFA seed tied to a different encryption key.

Decision: pending owner approval, especially if existing MFA enrollment must be
preserved.

## Decision log

| Decision | Date | Result |
|----------|------|--------|
| D-001 | 2026-09-08 | Approved: first deployment is PWDB-only; CNR module code, arcane-fire changes and caster-level changes remain out of scope |
| Production runtime | 2026-09-08 | One host-oriented Compose is also used for the final local rehearsal; `docker-compose-dev.yml` keeps the image's normal entrypoint |
| Credentials | 2026-09-08 | NWN credentials remain in `config/nwserver.env`; MySQL and panel encryption credentials remain in ignored `config/mysql.env` |
| Restart boundary | 2026-09-08 | `server-restart.sh` stops and recreates only `pb-server`; MySQL, its volume and the panel's external connection to `server_default` remain active |

## Deterministic verification completed

- focused NWScript simulation: `wrap_on_clnt_ent.nss`,
  `rebuild_migrate.nss` and `pwdb_mod_load.nss` compiled successfully together,
  with zero skipped and zero errors;
- `bash -n` passed for the production runner, restart, build, staging, database
  apply and panel restart scripts that were touched or consumed by the flow;
- both PROD Compose variants and the panel Compose render successfully with
  `docker compose config --quiet`;
- the production module IFO parses as JSON and points to `pwdb_mod_load` and
  `pwdb_mod_act`;
- DEV's documentation graph passes its canonical checker. PROD's copied
  documentation tree still has pre-existing indexing failures outside this
  slice; they are not deployment runtime failures and were not broadened into
  this urgent port.

## Production upload manifest

The exact final manifest remains open until the production rehearsal is
complete. The accepted runtime boundary already consists of:

- `docker-compose.yml`, `run-server.sh` and `server-restart.sh` for the host;
- `docker-compose-dev.yml` and `linux_run_server-dev.sh` for the local rehearsal;
- `config/nwserver.env`, `config/nwserver-dev.env`, the private
  `config/mysql.env`, and `config/mysql-init/`;
- `nasher.cfg`, `linux_build-dev.sh`, the PWDB/rebuild source resources and the
  resulting `modules/PB_EE_PROD.mod` after the owner-authorized build;
- `migration/`, `db-apply.sh`, `cnr-editor/` and its environment file for the
  database baseline, Alembic chain and panel.

No database content, server vault, map, palette, HAK, TLK or unrelated module
resource is implied by this preliminary list. Secret values must be replaced on
the host and must never be copied into this document.
