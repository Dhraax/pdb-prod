# AGENTS.md - Puerta de Baldur (PDB PROD)

Read `agents-config/AGENTS.md` in full before inspecting or changing this
repository. Its generic contract is binding. This file owns only PDB-specific
architecture, commands, risks, and verification rules, and overrides generic
defaults only where it says so explicitly.

This file is the single source of truth for repository behavior across AI
coding tools. Read it before inspecting or changing the project.

`CLAUDE.md`, `QWEN.md`, and `OPENCODE.md` are thin pointers to this file. They
must not duplicate project rules, documentation indexes, architecture
decisions, or tool commands. When this contract changes, update `AGENTS.md`
only unless a pointer itself is incorrect.

Do not reintroduce a competing agent-instruction file. The former root
`instructions.md` and `.cursor/rules/nwn-workspace.mdc` were removed because
they duplicated and contradicted this contract; their durable content now lives
here and in `documentation/nwscript/`. If a new tool needs its own entry point,
add a pointer file, not a copy of the rules.

All code, comments, canonical technical documentation, commit messages, and
technical writing must be in English. Player-facing Spanish documents and the
owner-managed publication files explicitly listed in `documentation/README.md`
are the only documentation exception.

## Authorship

**Dhraax is the sole author, owner, and collaborator of this repository.**
Nothing written into it may claim, imply, or record that an agent, a model, or
a company took part in producing it.

This binds every agent, without exception and regardless of what a tool's own
defaults say:

- **No `Co-Authored-By` trailer** naming Claude, Codex, an assistant, a model,
  a vendor, or any address belonging to one.
- **No "generated with", "written by", "assisted by"** or equivalent line, in a
  commit message, a pull request body, a file header, a comment, or generated
  output.
- **No agent name in author or committer fields.** Commits are the user's.
- **No vendor branding** in documentation, script banners, or file metadata.

Commit message style is otherwise free: write whatever explains the change
best. The single hard rule is that the message must never attribute the work to
anything other than the user.

An agent that finds such a trailer in work it is preparing removes it before
committing. An agent that has already committed one says so and offers to strip
it while the branch is still unpushed.

**Conversation with the user is in Spanish by default.** Match the language the
user writes in: if they write in Spanish, answer in Spanish; if they switch to
English, follow. This applies to chat responses, summaries, findings, and
questions — not to file contents, which stay English regardless.

Use concise, technically precise normal prose. Remove filler and unnecessary
repetition, but preserve complete grammar and clarity. Code and documentation
use normal professional language.

---

## Project Scope

This repository contains the **production** module for **Puerta de Baldur
(PDB)**, built for Neverwinter Nights: Enhanced Edition. This is the module
players connect to, so a mistake here is visible to them and a destructive one
costs character data. The current module is a large legacy NWScript and Aurora
Toolset asset codebase. Project systems use
NWScript, NWNX:EE, and the general Neverwinter Nights: Enhanced Edition
environment provided by the Aurora engine. Nasher unpacks and packages the
module, while Docker Compose stages the NWN:EE/NWNX:EE server runtime.

Per `nasher.cfg`, the package is named `PROD PDB EE`, the only target is
`default` (described as `PROD version`), and the packaged artifact is
**`Puerta de Baldur 5E.mod`**, the same module name the online host runs (`NWN_MODULE=Puerta de Baldur 5E`).
It replaced `PB_EE_PROD.mod` on 2026-09-17. Do not refer to this repository's module as `PB_EE_PGCC`;
that name belongs to the development repository, `pdb-dev`, which is the source
of most of what arrives here. `PB_EE` alone is a stale legacy name and belongs
to neither.

**Work usually flows development to production, slice by slice.** When a change
exists in both repositories, the development one is normally the original and
this one is the copy; say which repository a fact comes from rather than
assuming the two agree. They have drifted before.

The architecture and automation stack will be improved incrementally. Do not
assume frameworks, services, conventions, migrations, or directory layouts that
are not already present or explicitly accepted by the user. Preserve the working
legacy system while introducing each new layer in small, documented, reversible
slices.

---

## Where To Look

Use this lookup order. Never guess an undocumented NWScript, NWN:EE, NWNX:EE,
Nasher, resource format, or project behavior.

1. `documentation/` for curated PDB documentation as it is created.
2. For exact native NWScript or NWNX symbols, use the corresponding read-only
   MCP: `nwn-official` or `nwnx`.
3. `nasher.cfg`, deployment configuration, and root workflow scripts.
4. The implementation under `src/`.
5. Project 2DA data under `haks-2da/` when the behavior is data-driven.
6. Locally bundled tool documentation, especially
   `tools/{win,linux}/nasher/README.md`.
7. **When the MCP's extracted view is not enough, read the vendored source
   itself** — `documentation/nwscript/reference/nwscript.nss` for natives, the
   `nwnxee/` submodule for NWNX. Neighbouring comments, the constant block a
   symbol belongs to, and the `#define` above it are all there and none of them
   survive extraction. **Do not go to the NWN Lexicon**: see below.
8. The relevant tool's upstream documentation, for anything that is neither
   NWScript nor NWNX.
9. **When nothing written establishes a behavior, write a probe.** A short
   script compiled or run against this build is stronger evidence than any wiki,
   and it is how `\r` was found not to be an escape and how the effect owner
   question is being settled. Record the result with provenance.
10. Never guess.

Use the MCPs before opening large generated files, dependency source, the NWN
Lexicon, or NWNX unified documentation for an exact symbol lookup. The MCPs are
read-only and source-generated; do not duplicate their signatures manually.
When source or an external reference is required to establish non-obvious
behavior, record the durable result with provenance in the matching canonical
project document in the same verified change.

`documentation/` is the canonical home for architecture, deployment, workflows,
decisions, and system notes. `documentation/README.md` is its only canonical
root index. Canonical documents must be separated by project module under
`documentation/<module>/`; the owner-managed root exceptions and their exact
roles are listed in that README. Each module directory must contain a
`README.md` that defines its scope and indexes its documents. Add a new module
directory only when the existing boundaries do not fit. Do not create competing
documentation catalogs in tool-specific instruction files.

When the user requests a forum post, read and follow
`documentation/forum-post-format.md`. It defines the forum BBCode wrapper and
supported tags. Other owner-managed root documents are working material and are
not evidence of current runtime behavior unless the user explicitly places one
in scope.

Current documentation modules:

| Module | Scope |
|--------|-------|
| `documentation/nwscript/` | NWScript style guide, script template, language/engine notes, and the vendored `reference/nwscript.nss` |
| `documentation/database/` | Persistence: MySQL identity model (`pwdb_*`), the data model, migration plan and integration runbook |
| `documentation/oficios/` | CNR crafting/tradeskill system: schema, recipe data, design tables |
| `documentation/control-panel/` | Reusable administrative panel: product identity, compatibility boundary, user management and feature authorization |
| `documentation/rules/` | Ruleset mechanics: bonus stacking and what is known to be wrong with it |
| `documentation/pending-changes/` | Active proposals and partially implemented work with unresolved decisions or validation |
| `documentation/repository/` | Repository operations, deployment synchronization, remote policy, MCP integration and audit workflow |
| `documentation/changelog/` | What changed and what has to be tested for it, by month, split between `oficios/` and `modulo/` |

When an answer requires reading external documentation or reverse-engineering
behavior not already described locally, record the durable result in the
matching canonical document in the same change. Document behavior, constraints,
failure modes, corrected assumptions, source version and provenance; do not
merely copy API signatures. Reusable engine-wide findings belong in
`documentation/nwscript/engine-behavior.md`; a PDB rule or workaround belongs in
the module that owns it.

Use this routing table before deciding that an MCP must be changed:

| Finding | Required destination |
|---------|----------------------|
| A native declaration, constant, default or engine comment is missing or parsed incorrectly | Fix and publish `nwn-official-mcp` in its provider repository, then advance the reviewed gitlink in PDB |
| The native is already present and correctly parsed | No MCP change; use the existing symbol |
| Reusable engine behavior is established by a probe, release note or source reading but is not stated by `nwscript.nss` | `documentation/nwscript/engine-behavior.md`, with build and provenance; promote it to an MCP corpus only through a separate accepted provider design |
| A 2DA column or row controls the behavior | The owning PDB system document, plus `engine-behavior.md` when the rule is engine-wide; cite the tracked project 2DA and identify any external baseline |
| An NWNX signature or indexed plugin document is missing or parsed incorrectly | Fix and publish `nwnx-mcp` in its provider repository, then advance the reviewed gitlink |
| The behavior is a PDB rule, balance decision or workaround | The owning module under `documentation/`; never the generic native API MCP |

The two MCPs are source-generated API references, not general notebooks. Do not
edit either implementation inside a PDB change. A new curated behavior corpus is
an explicit provider architecture change, not an incidental documentation edit.

External references:

| Subject | Reference |
|---------|-----------|
| Native NWScript declarations and engine comments | `nwn-official` MCP, then `documentation/nwscript/reference/nwscript.nss` |
| Reusable native engine behavior absent from that contract | `documentation/nwscript/engine-behavior.md`, backed by a probe, release note or pinned source |
| Project 2DA values | `haks-2da/`; compare with an identified external baseline when stock behavior matters |
| NWNX:EE plugin signatures | `nwnx` MCP: `search_nwnx_api`, `get_nwnx_function` |
| NWNX:EE plugin behavior, configuration and caveats | `nwnx` MCP: `search_nwnx_docs`, `get_nwnx_doc` |
| Bundled Nasher version | `tools/win/nasher/README.md` or `tools/linux/nasher/README.md` |

**`documentation/nwscript/reference/nwscript.nss` is read-only. Never edit it.**

It is a verbatim copy of the game's `ovr/nwscript.nss`, its sha256 is locked in
`mcp/source-lock.json`, and `scripts/refresh_nwscript_reference.sh` replaces it
wholesale every ninety days. Anything written into it is silently destroyed at
the next refresh, and until then the checksum no longer matches the game, so the
MCP is serving a file the compiler does not use.

Do not add to it, do not correct it, do not annotate it. If something about a
native symbol needs recording, it goes in `documentation/`. If the file itself
is wrong, that is Beamdog's to fix and ours to work around, in our own code.

The same applies to the `nwnxee/` submodule: it is upstream source, pinned, and
never edited here.

**The NWN Lexicon is not part of the lookup order.** `nwnlexicon.com` sits
behind a Cloudflare managed challenge (`cf-mitigated: challenge`) that requires
a real browser: `/index.php/*`, `?action=raw`, `Special:Export` and `api.php`
all return 403 to every agent tool, and there is no upstream repository — the
wiki is the origin, and the only offline edition is an HTTrack scrape from
2022-07-13. It is a fine reference for a human with a browser and it is not one
an agent can reach or verify. If a Lexicon page matters, the user pastes it.

`https://nwnxee.github.io/unified/` is not in the order either, for the opposite
reason: it is Doxygen run over the `.nss` and `.md` files of the `nwnxee`
submodule and published to `gh-pages`, so its content is in the repository. The
MCP indexes the plugin API headers and the first-party documentation, which is
what a caller wants; **coverage is not identical to the site**. Doxygen also
renders `Compatibility/` and `Core/NWScript/`, which the MCP does not index, and
the MCP indexes plugin test headers that Doxygen excludes. For anything outside
that overlap, read the `nwnxee/` submodule directly. `search_nwnx_docs` and `get_nwnx_doc` reach the plugin READMEs — where
the environment variables, the costs and the refusals are written down — without
leaving the repository.

Nothing is lost by this. `nwscript.nss` is Beamdog's own file, shipped with the
game and updated every patch, and it carries the signature, the parameters, the
constants and the engine's own comment. The Lexicon adds community-written
remarks, much of it about 1.69. Where the engine comment is silent about
behavior, the answer is a probe against this build, not a wiki.

Keep native NWN:EE and NWNX APIs clearly distinguished. When a reference affects
a design or implementation, cite it in the resulting module documentation.

Ignored local reference trees such as `Content/` or `cow-scripts/` may be used
when the owner has supplied them, but they are supplementary and
non-reproducible from a clean checkout. Never use one as the sole evidence for a
canonical claim. Record what was read, its version or origin, and a tracked or
upstream source that another checkout can obtain.

---

## Repository Map

| Path | Purpose |
|------|---------|
| `nasher.cfg` | Nasher package definition and source routing; authoritative build configuration |
| `src/` | Authoritative editable module source |
| `src/shared/` | Bulk of the module's resources, routed by type: scripts, dialogs, blueprints, factions, journals, and palettes |
| `src/cnr/` | **Everything CNR owns**: `nss/`, `dlg/`, `uti/`, `utp/`. Self-contained on purpose - see the rule below |
| `src/pwdb/` | PWDB identity subsystem (`nss/`), consumed by module hooks and character-owned systems |
| `src/cnr/nui/` | The CNR arcane NUI window scripts. Compiled: `linux_build.sh` includes this directory |
| `src/module/` | Module-specific area and module metadata resources |
| `modules/` | Unpacked and packaged working artifacts, including `Puerta de Baldur 5E/`, `Puerta de Baldur 5E.mod`, and `.rar` archives; not the long-term source of truth |
| `.nasher/` | Nasher cache and package state; generated working data |
| `documentation/` | Canonical project documentation, split by module |
| `agents-config/` | Pinned, technology-agnostic agent contract and workflow engine submodule |
| `.agents/` | PDB-owned parameters and prompts consumed by the pinned agent engine |
| `mcp/` | Pinned MCP implementation submodules plus the reviewed native NWScript/NWNX source lock |
| `nwnxee/` | Pinned internal NWNX:EE source submodule consumed by `mcp/nwnx-mcp`; never replace it with an external checkout |
| `tools/win/` | Bundled Windows Nasher, NWScript compilers, and Neverwinter utilities |
| `tools/linux/` | Bundled Linux Nasher, NWScript compilers, and Neverwinter utilities |
| `config/` | Server environment files and Grafana/InfluxDB provisioning |
| `server/` | Staging/runtime directory populated by launch scripts |
| `docker-compose.yml` | The only Compose file here, and the one the host runs from its server directory: NWN:EE/NWNX:EE and MySQL by default, InfluxDB and Grafana only under the `metrics` profile. There is no `-dev` variant in this repository |
| `haks-2da/` | Project 2DA and HAK-related content |
| `tlk/` | TLK content staged for the server |
| `erf/` | ERF-related content/artifacts |
| `logs/` | Runtime diagnostic output |

The repository root may also hold a top-level `Puerta de Baldur 5E.mod` alongside
`modules/Puerta de Baldur 5E.mod`, and older `PB_EE_PROD.mod` copies from before the rename.
None is source; all are generated artifacts.

### CNR is self-contained: put its resources under `src/cnr/`

Every resource CNR owns lives under `src/cnr/`; remove the old `src/shared/`
copy when moving one. The only integration-owned exceptions are shared palettes
under `src/shared/itp/`, area placements under `src/module/git/`, and 2DA files
under `haks-2da/`.

The blocking invariants are:

- station tag and resref are identical, and the file name is the resref in
  lower case, as unpacking writes it;
- a product repeated per material is represented by a variant group, not by
  duplicated recipes;
- repeated craftable item types use the clean `cnr_b_*` blueprints listed in
  `documentation/oficios/cnr/base-items.md`, never a stock or shared named item;
- every blueprint CNR owns is named `cnr_*` with tag equal to resref, except the
  `sute_her_*` potions and the shared station-tool tags; the scheme and its
  exceptions live in
  `documentation/oficios/cnr/naming.md`, enforced by `build_catalogue.py --check`;
- any player-visible catalogue change updates the affected guide under
  `documentation/oficios/cnr/oficios/` in the same change and is checked against
  the generated SQL and its reviewed design source.

The current architecture, exceptions and reasons live in
`documentation/oficios/cnr/README.md`, `crafting-system.md` and
`base-items.md`. Keep mutable counts and implementation history there rather
than duplicating them in this contract. `migration/build_catalogue.py --check`
enforces the catalogue invariants.

### Source routing

`nasher.cfg` includes `src/**/*.{nss,json}` and declares:

```toml
[package.variables]
shared-files = "{dlg,fac,itp,jrl,nss,utc,utd,uti,utm,utp,uts,utt,utw}"

[package.rules]
"pwdb_*.nss" = "src/pwdb/$ext"
# Keep new CNR-prefixed resources in the self-contained CNR source tree
# when unpacking. Existing resources retain their tracked source paths.
"cnr*.${shared-files}" = "src/cnr/$ext"
"*.${shared-files}" = "src/shared/$ext"
"*" = "src/module/$ext"
```

How Nasher applies this, per the bundled Nasher README:

- Rules are consulted **only during `unpack`**, and only for files that are not
  already present in the source tree. A file already tracked under `src/` is
  unpacked back to its existing path, so `src/cnr/` content stays put.
- `pwdb_*.nss` has a specific first rule, so new PWDB scripts unpack to
  `src/pwdb/nss/`.
- **`cnr*` has its own pattern here**, unlike the development repository, so a
  new CNR-prefixed resource of a shared type unpacks into `src/cnr/<extension>/`
  instead of `src/shared/`. Every other new shared-type resource lands in
  `src/shared/<extension>/`. Do not change these rules without asking; the
  routing affects where an unpack scatters hundreds of files.
- Shared resource types are `dlg`, `fac`, `itp`, `jrl`, `nss`, `utc`, `utd`,
  `uti`, `utm`, `utp`, `uts`, `utt`, and `utw`.
- Every other module resource lands in `src/module/<extension>/`.
- Aurora/GFF resources are stored as JSON in `src/`; NWScript remains `.nss`.
- Files matching no rule are dropped into an `unknown/` directory in the package
  root. If `unknown/` appears, treat it as a routing failure to sort manually.
- The configured target writes `Puerta de Baldur 5E.mod`; the name contains spaces, so every
  script quotes the path.

Treat `src/` as authoritative after a successful unpack. Do not edit
`Puerta de Baldur 5E.mod`, `modules/Puerta de Baldur 5E.mod`, or the `.nasher/` cache as a
substitute for a source change.

---

## Nasher And Compiler Locations

### Nasher

| Platform | Executable |
|----------|------------|
| Windows | `tools/win/nasher/nasher.exe` |
| Linux | `tools/linux/nasher/nasher` |

### NWScript compiler

| Platform | Compiler |
|----------|----------|
| Linux | `tools/linux/neverwinter/nwn_script_comp` |
| Windows | `tools/win/neverwinter64/nwn_script_comp.exe` |

`nwn_script_comp` (neverwinter.nim) wraps `libnwnscriptcomp.so`, the game's
official compiler library, so it produces exactly what Aurora produces. It is
the default compiler of Nasher >= 1.0; the bundled Nasher is 1.1.1.

The legacy `nwnsc` is **no longer used**. It reported two classes of false
error this project actually hits: `switch(HashString(x))` with string `case`
labels (`inc_sum_golem.nss`), and base-game includes such as `nw_inc_nui`.

Its flags are **not** interchangeable with `nwnsc`. In particular `-s` means
*simulate* here, not *strict*. Relevant options:

| Option | Meaning |
|--------|---------|
| `--dirs D1,D2` | Include directories, comma-separated |
| `-c` | Compile several files or directories |
| `-d DIR` | Output directory |
| `-y` | Continue after a file fails |
| `-s` | **Simulate** — compile, write nothing |
| `-O N` | Optimisation level, default `1` |

The NWN install path comes from `$NWN_ROOT` or autodetection; do not pass it
through flags. Default encoding is already `windows-1252`, which matches the
project's `.nss` files. Parallelism defaults to all CPUs.

Only four directories under `src/` contain `.nss`, and they are exactly the
four `linux_build.sh` passes to the compiler as `SRC_NSS`:

```
src/shared/nss   src/cnr/nss   src/cnr/nui   src/pwdb/nss
```

`src/module/` holds no scripts. Passing a non-existent include directory aborts
`nwn_script_comp` (unlike `nwnsc`, which ignored it).

### Build and deploy

| Script | Purpose |
|--------|---------|
| `linux_build.sh` | Compile `src/` and pack `modules/Puerta de Baldur 5E.mod` |
| `linux_build.sh --check [files]` | Verify compilation only; writes nothing |
| `linux_build.sh --clean` | Clear the cache and rebuild everything |
| `linux_run_server.sh` | Stage into `server/` and start the stack |
| `linux_stop_server.sh` | Stop the stack |

Normal cycle:

```bash
./linux_build.sh
./linux_run_server.sh
```

`src/` is the only source of truth. Never edit `modules/Puerta de Baldur 5E/`: it is an
unpacked working copy, it is not tracked, and editing it there silently
diverges from what Nasher builds.

Nasher compiles incrementally through `.nasher/cache/default/`, but the `.mod`
is repacked in full every time. A recent `.mod` timestamp therefore proves it
was repacked, not that the scripts inside were recompiled. To check what
actually shipped, read the bytecode:

```bash
strings -a <script>.ncs | grep -c "<expected text>"
```

## Current Module And Server Workflows

All commands below can overwrite generated state, replace deployed artifacts,
restart services, or rewrite credentials. Do not run them unless the user
explicitly asks.

**Primary flow (use these):**

| Script | Role |
|--------|------|
| `linux_build.sh` | Compile `src/` and pack `modules/Puerta de Baldur 5E.mod`. `--check` verifies only, `--clean` rebuilds all |
| `linux_run_server.sh` | Stage the `.mod`, env files, `mysql-init`, Grafana provisioning and TLK into `server/`; start Compose. Warns when a `.nss` is newer than the `.mod` |
| `linux_stop_server.sh` | Stop the stack (`--remove-orphans`) |

**Secondary and legacy:**

| Script | Role | Notes |
|--------|------|-------|
| `linux_nasher_unpack_folder.sh` | Unpack the `.mod` back into `src/` | Windows-1252 GFF decoding, `--removeDeleted`, `--yes`. Destructive to uncommitted source |
| `win_nasher_unpack_folder.bat` | Windows equivalent | Same warnings |
| `win_run_server.bat` | Windows build/deploy/start | Blocked until the Compose file stops bind-mounting `/etc/timezone` |
| `win_stop_server.bat` | Stop the Windows-staged stack | Runs from `server/` |
| `linux_nasher_install.sh` | Legacy install | Uses `--noCompile`: packs **without compiling**. Prefer `linux_build.sh` |
| `win_nasher_install.bat` | Legacy Windows install | Same `--noCompile` caveat |
| `server-restart.sh` | Restart **only the `pb-server` service**, from the repository root | Validates the Compose file, brings `mysql` up if it is not running and leaves it alone if it is, then stops `pb-server` with a 120 second timeout and recreates it. This is the live server: recreating it disconnects whoever is playing. It does **not** restart the database, so it is not the command for a MySQL problem, and it never starts the metrics services. Expects `docker-compose.yml`, `run-server.sh` and `config/*.env` beside it |
| `web-restart.sh` | Rebuild and restart only the CNR editor stack | Expects a staged `cnr-editor/` with its `compose.yml` and `.env` |
| `nwsync.sh` | Publish the packed module to NWSync | Writes `/var/www/html/nwsync` from `server/modules/Puerta de Baldur 5E.mod` beside the script, or `modules/Puerta de Baldur 5E.mod` when the script sits in the server directory itself. Player-visible the moment it runs |
| `linux_apply_sql.sh` | Apply one or more `.sql` files to the running MySQL | Reads credentials from `server/config/mysql.env`, falling back to `config/mysql.env`. Never echo those values |
| `db-backup.sh` | Create a private full-MySQL transfer package under ignored `server/db-transfer/` | Read-only against the running source database; captures live editor changes, identity and CNR progress as well as recipes |
| `db-restore.sh` | Restore the transferred MySQL package on a new host | Destructive by nature but refuses any non-empty target database; validates checksum and recipe presence before handoff |
| `db-apply.sh` | Apply `migration/*.sql` in order to a **live** database | Rebuilds the catalogue tables only. Dumps to `<stack>/db-backups/pre-apply-<timestamp>.sql.gz` first, and aborts if the character, tradeskill or setting counts drop. Finds the stack itself: `dev-server/` on the dev host, `server/` locally, and prints both it and the migration directory before asking to confirm |

The root Compose file currently runs `nwnxee/unified:build8193.37` with
`mysql:8.4`; `influxdb:1.7` and `grafana/grafana:6.0.1` start only with
`docker compose --profile metrics up -d`, because `NWNX_METRICS_INFLUXDB_SKIP=y`
leaves them nothing to record in normal operation. MySQL holds the
persistent identity and CNR tables; see `documentation/database/`. Environment-specific server settings
live in `config/nwserver.env`, with `config/mysql.env`, `config/grafana.env`
and `config/influxdb.env` alongside it. Each has a tracked `.example`; the real
files are ignored and stay out of the repository. Treat environment files as
sensitive: do not print their values in reports or copy secrets into
documentation.

Before changing a workflow script, trace every path from repository root and
verify the configured module name against `nasher.cfg` and the corresponding
environment file.

---

## How To Work

- Read the relevant configuration, script, source, and documentation before
  changing behavior.
- Preserve user changes. Never revert, overwrite, clean, or reformat unrelated
  work.
- Prefer small, reviewable changes over broad rewrites of the legacy module.
- Keep source truth in `src/`; treat packed modules, caches, logs, and reports
  as generated or runtime state.
- Follow existing local patterns unless a deliberate refactor has been agreed.
- Do not mass-format, mass-rename, translate, or normalize legacy scripts.
- Do not introduce a framework, database, service, build system, or deployment
  dependency without an explicit architecture decision from the user.
- Keep ruleset behavior, runtime systems, build tooling, and deployment concerns
  separate. Document ownership and boundaries as the stack grows.
- Prefer event-driven behavior where the engine exposes an appropriate event.
  Avoid global heartbeat work and other unbounded hot paths.
- Never invent project APIs or resource relationships. Search references and
  callers before changing a public include, event script, resref, tag, local
  variable name, database key, or persisted data shape.
- Treat changes to module event scripts, shared includes, persistence, character
  data, areas, and deployment as high-risk because their coupling may not be
  visible from one file.
- Flag architectural risk, hidden coupling, performance traps, data migration
  needs, and missing verification steps.
- Do not keep temporary notes or scratch files in the repository. Promote
  durable findings into `documentation/`.
- **A change a player, a DM or a builder could notice gets a changelog entry in
  the commit that makes it**, in `documentation/changelog/oficios/YYYY-MM.md` or
  `documentation/changelog/modulo/YYYY-MM.md`. In the same commit, not merely on
  the same day: the entry is part of the change, and a slice spread over several
  commits puts it with the one that alters behaviour. Every entry says what changed in
  the terms of whoever will notice it, what has to be tested concretely enough to
  act on without reading the code, what is still owed - a hak repack, a
  migration, a decision - and the commits. Entries are amended when a test
  passes, never deleted. Refactoring nobody can observe is exempt unless it moves
  a file or changes how something is built.

### Command safety

- Read-only inspection is allowed when relevant.
- The focused, non-writing NWScript check required by the Verification section
  is pre-authorized and mandatory after an agent creates or modifies `.nss`
  files. No separate user request is required for that check.
- Except for that focused check, do not run Nasher install/unpack, an NWScript
  compiler, module packaging, Docker Compose start/stop, `server-restart.sh`,
  `web-restart.sh`, `nwsync.sh`, `linux_apply_sql.sh`, `db-backup.sh`,
  `db-restore.sh`, `db-apply.sh`, or in-game validation unless the user
  explicitly requests it. This is the live module: several of those are visible
  to players the moment they run.
- Before any unpack or command with `--removeDeleted`, confirm the exact target
  and warn that uncommitted source changes may be removed.
- Before a destructive command, resolve exact paths and confirm they remain
  inside this repository. Prefer recoverable operations.
- Never expose environment secrets, credentials, tokens, player data, or private
  server configuration in command output or documentation.

---

## NWScript Standards

The repository is a legacy codebase. Apply these standards to new code and to
code materially refactored by the current task; do not churn untouched files
solely to modernize formatting.

Canonical detailed guide: `documentation/nwscript/style-guide.md`.
Canonical base template: `documentation/nwscript/script-template.md`.

The blocking summary is:

- new project scripts use the canonical header and `@author Dhraax`;
- modified project scripts preserve the original author and add
  `modified by: Dhraax` once;
- public include functions have synchronized, documented prototypes before all
  definitions;
- new or materially refactored code follows the naming, type-prefix, brace and
  indentation rules in the style guide;
- search consumers before changing a shared include, public name, resref, tag or
  persisted key;
- resrefs remain within 16 characters and tags within 32.

Do not copy the templates or detailed formatting rules back into this file.

---

## File And Encoding Rules

- Markdown and AI instruction files are UTF-8.
- VS Code config currently treats other project files as Windows-1252. Preserve
  the encoding of NWScript, GFF JSON, TLK, 2DA, config, shell, batch, and YAML
  files unless a separate migration is explicitly approved.
- Module unpack scripts pass `--gffFlags="--nwn-encoding windows-1252"`. Never
  remove or bypass that flag; accented content may be corrupted.
- Some existing documents under `documentation/` were saved from Windows-1252
  sources and contain mojibake in accented text. Do not mass-fix them; correct
  encoding only in a document you are already editing for another reason.
- Search with `rg` first. If GNU `grep` reports a particular NWScript file as
  binary, repeat that search with `grep -a`; Windows-1252 encoding alone is not
  proof that every `.nss` file will be classified as binary.
- Preserve existing line endings unless the task requires a deliberate change.
- Do not add Unicode decoration or typography to game/build files. Prefer
  ASCII-safe punctuation in technical files.
- This repository is commonly used on a case-insensitive Windows filesystem
  while Git is case-sensitive. Check for case-only path collisions.
- Generated `.ncs`, `.mod`, `.erf`, and `.hak` artifacts are not source code.
- `AGENTS.md`, `CLAUDE.md`, `QWEN.md`, `OPENCODE.md`, and `.agents/config.json`
  are tracked by Git for agent configuration. Their changes may be hidden by
  broad ignore rules until explicitly tracked; inspect them directly when
  verifying updates.

---

## Verification

The current module has no documented automated NWScript test harness. Do not
invent one or claim in-game behavior is verified from static inspection.

### Mandatory focused NWScript compilation

Every change that creates or modifies one or more `.nss` files must compile the
affected scripts before handoff. This is a strict completion gate, not an
optional verification step:

1. Identify only the `.nss` files created or modified by the current work
   slice. Do not include unrelated dirty files already present in the worktree.
2. Run `./linux_build.sh --check <file.nss> [more-file.nss ...]`, passing
   the explicit filename of every changed executable script. Confirm each
   filename resolves uniquely under `src/` before running the command.
3. A changed include has no `main()` and the compiler reports it as skipped.
   For every changed include, identify its affected executable consumers and
   add at least one representative direct consumer plus every executable
   consumer modified in the same slice to the focused command.
4. Never run bare `./linux_build.sh --check` for change-level testing: with
   no filenames it compiles all of `src/`. Never substitute a normal build,
   Nasher install, module package, or `--clean`; those operations remain under
   user control.
5. Any focused compilation error blocks handoff as ready for testing. Fix it
   and repeat the same focused command until it succeeds.
6. If no `.nss` file changed, do not compile anything and state that the check
   was not applicable.

`--check` simulates compilation and writes no `.ncs`, cache, or module
artifact. This is the production copy of that policy; the build wrapper here is
`linux_build.sh`, without the `-dev` suffix the development repository uses.
The invariant is the same in both: compile only the
explicit changed scripts and affected consumers, never the whole module for
change-level testing.

For each change:

1. Inspect the focused diff or exact changed files.
2. Search for callers, event assignments, include consumers, resrefs, tags, and
   persisted keys affected by the change.
3. Perform safe static checks appropriate to the file type.
4. State what was not run, especially compilation, packaging, server startup,
   and in-game validation.
5. Give a concise manual validation plan when runtime behavior changes.

When `AGENTS.md` or any tracked file under `documentation/` changes, run
`python3 scripts/check_documentation.py`. **That script does not exist in this
repository yet**; it is one of the pieces still to be brought over from
development. Until it does, say in the handoff that the structural
documentation check could not be run, rather than claiming it passed.

The user owns full-module compilation, packing, server restart, and in-game
validation unless they explicitly delegate those actions. The mandatory
focused, non-writing compilation above is the only standing exception.

### Independent external audit

The provider-neutral state machine, immutable commit boundary, one-review
budget, finding contract, deterministic finalizer, and 48-hour maximum artifact
retention are binding from `agents-config/AGENTS.md` and
`agents-config/documentation/auditing/README.md`. Do not duplicate that process
here.

PDB enables the audit in `.agents/config.json`, selects Codex today, and adds
project-specific review focus through `.agents/prompts/audit.md`. The only
consumer command is:

```bash
scripts/agent_audit.sh prepare <candidate-commit>
scripts/agent_audit.sh review <candidate-commit>
scripts/agent_audit.sh finalize <candidate-commit>
```

The candidate commit must contain only the accepted implementation slice and
must already have passed every applicable deterministic PDB check defined
above. A changed `.nss` slice includes the mandatory focused, non-writing
compilation evidence in its handoff.

**It must also contain the changelog entry for its own change.** The review
boundary is one commit, so an entry written in a following commit does not exist
as far as the reviewer is concerned and the gate blocks on its absence every
time. This is not a matter of tidiness: two audits on 2026-08-30 were blocked by
exactly this, both while following an instruction to keep code and documentation
in separate commits. Other documentation may still travel separately; the
changelog entry cannot.

The candidate cannot name its own commit id, so the **Commits.** line is written
as `<pending>` in the candidate. After review, replace it with the candidate id
in the single direct child used as the final remediation commit. If no other
remediation is required, that direct child may contain only this update. Do not
amend the reviewed candidate or create a second commit after remediation:
`finalize` accepts only the candidate or one direct child. See
`documentation/repository/audit-log.md`.

Codex must not invoke Codex to audit its own implementation. It performs the
normal deterministic verification and reports that the independent gate was
not run. Another implementing worker uses the configured external reviewer
unless the user explicitly waives the gate.

The former `codex_audit.sh`, `codex_review.sh`, their schema, and their two-pass
workflow are retired. Do not restore or invoke them.

---

## Answer Contract

- Answer with the combined approach of a senior software architect/developer and
  a senior game designer, with strong NWN:EE, NWScript, NWNX:EE, and Aurora
  Toolset judgment.
- Ground answers in this repository's actual files and current runtime.
- Prefer local evidence over generic advice.
- Lead with the outcome, then risks, verification, and next action if needed.
- Cite `nwscript.nss` for native NWScript behavior and the `nwnxee/` submodule
  for plugin behavior. Say when a behavior is established by a probe rather than
  by documentation, and say which probe.
- Do not invent undocumented APIs, successful builds, or runtime results.
- Surface uncertainty and stale tooling explicitly.
