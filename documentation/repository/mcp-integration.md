# MCP Integration

## Scope

This repository exposes two read-only MCP servers to Codex, Claude Code, and
OpenCode:

| Server | Implementation | Authoritative source |
|--------|----------------|----------------------|
| `nwn-official` | `mcp/nwn-official-mcp/` | The vendored `documentation/nwscript/reference/nwscript.nss` |
| `nwnx` | `mcp/nwnx-mcp/` | The internal `nwnxee/` submodule: the `nwnx_*.nss` headers **and** the plugin documentation |

There is no Underworld ruleset MCP in PDB. Do not add Underworld-specific rules,
corpora, launchers, or client registrations.

The two native API implementations and the internal NWNX source are pinned Git
submodules:

- `mcp/nwn-official-mcp/` tracks its published `main` maintenance channel.
- `mcp/nwnx-mcp/` tracks its published `main` maintenance channel.
- `nwnxee/` tracks the published `master` channel of
  `git@github.com:Dhraax/unified.git`.

The branch declarations do not replace Git pins. A normal checkout uses the
exact commits recorded by this consumer repository.

## Root-relative path contract

All consumer-owned paths are resolved from the PDB repository root. The
launchers determine that root from their own location; they do not depend on
the caller's current working directory.

```text
scripts/run_nwn_official_mcp.sh
  -> mcp/nwn-official-mcp/dist/index.js
  -> mcp/source-lock.json

scripts/run_nwnx_mcp.sh
  -> mcp/nwnx-mcp/dist/main.js
  -> mcp/source-lock.json
  -> nwnxee/Plugins/

```

`scripts/run_nwnx_mcp.sh` always sets `NWNX_ROOT` to the internal
`<repository-root>/nwnxee` submodule. It must not discover or fall back to a
sibling workspace, user directory, or another external checkout. A missing or
uninitialized `nwnxee/Plugins/` tree is a setup failure, not a reason to search
outside this repository.

### The NWNX documentation is indexed too

`https://nwnxee.github.io/unified/` is not a separate source to consult. That
site is **Doxygen run over `*.nss` and `*.md` in the `nwnxee` repository**
(`nwnxee/.github/workflows/docs.yml`, `nwnxee/docgen/CMakeLists.txt`), published
to its `gh-pages` branch. Everything it shows is already in the submodule.

The MCP therefore indexes both halves:

| Half | Files | Digest | Tools |
|------|-------|--------|-------|
| Headers | `Plugins/*/NWScript/nwnx_*.nss` (60) | `headerSha256` | `search_nwnx_api`, `get_nwnx_function`, `get_nwnx_constant`, `list_nwnx_symbols` |
| Documents | Root, `Core/`, one level under `Plugins/` (52) | `docSha256` | `search_nwnx_docs`, `list_nwnx_docs`, `get_nwnx_doc` |

Use the API tools for a signature and the document tools for behaviour,
configuration and caveats — environment variables, costs, and what a plugin
refuses to do live in the README, never in the header.

`NWNXLib/External/` and `Plugins/Redis/cpp_redis/` are excluded: that
documentation belongs to funchook, capstone, json, tracy and cpp_redis.

**Coverage is not identical to the published site**, and should not be assumed
to be. Doxygen also renders `Compatibility/*.nss` and `Core/NWScript/*.nss`,
which the MCP does not index; conversely the MCP indexes the `nwnx_*_t.nss` test
headers, which Doxygen excludes. Anything outside the overlap is read from the
`nwnxee/` submodule directly.

Headings repeat heavily in this corpus — `CHANGELOG.md` has thirty-four `Added`
sections — so every section carries a unique anchor and `get_nwnx_doc` returns
the anchor list with every reply. A plugin name is accepted as shorthand and
resolves to that plugin's README; anything else ambiguous is refused with the
candidates listed. No document carries a link to the published site, because
Doxygen's markdown page names are not stable enough to derive one.

The two digests are deliberately separate. Editing a README must not read as an
API change, and an API change must not be masked by a doc edit.

`scripts/run_nwn_official_mcp.sh` exports `NWN_NWSCRIPT_PATH` to
`documentation/nwscript/reference/nwscript.nss`, the vendored byte-for-byte copy
of the game's `ovr/nwscript.nss`. The game installation is **not** the runtime
authority: a checkout answers from bytes it carries, so the result is the same on
every machine, the `sha256` in the lock is checkable, and the reference moves at
one deliberate moment rather than on every game patch.

The game installation is still the *origin*. `scripts/refresh_nwscript_reference.sh`
is the only thing that copies from it, on a ninety-day interval, and it validates
the candidate before letting it become the reference. See
[`../nwscript/reference/README.md`](../nwscript/reference/README.md).

If the vendored file is missing the launcher says so and falls back to
discovering the installed game from `NWN_NWSCRIPT_PATH`, `NWN_ROOT`, or the
supported Steam locations, so a fresh clone is not bricked — but that is a
degraded state to repair with a refresh, not a supported configuration.

## Checkout and build

Initialize the exact consumer pins from the repository root:

```bash
git submodule sync -- \
  mcp/nwn-official-mcp mcp/nwnx-mcp nwnxee
git submodule update --init --recursive -- \
  mcp/nwn-official-mcp mcp/nwnx-mcp nwnxee
```

Node.js 20 or later is required. Install and verify each MCP implementation:

```bash
npm --prefix mcp/nwn-official-mcp ci
npm --prefix mcp/nwn-official-mcp run check
npm --prefix mcp/nwn-official-mcp run validate

npm --prefix mcp/nwnx-mcp ci
npm --prefix mcp/nwnx-mcp run check
npm --prefix mcp/nwnx-mcp run validate

```

Acceptance requires zero parser issues and a clean `nwnxee/` worktree.

## Source lock

`mcp/source-lock.json` records the reviewed native and NWNX identities. The
launchers inject its native SHA-256 and NWNX revision/header SHA-256 into the
servers. A different source fails closed until a human reviews the validation
result and updates the lock.

`nwnx.docSha256` is optional by design. A lock written before documents were
indexed carries none; the launcher then exports nothing and the server reports
the document digest without enforcing it, rather than failing every request
closed. Once present it is enforced exactly like `headerSha256`.

For the native half this is now driven by
`scripts/refresh_nwscript_reference.sh`, which is the only supported way to move
`nwnOfficial`. It writes all four fields from a single validator report with
`issueCount == 0`; a hand-edited `sha256` that no report backs is exactly the
unreviewed source the lock is meant to reject.

Never copy a lock from another machine without reproducing both validation
results. For NWNX, the lock must describe the exact internal `nwnxee/` gitlink,
not an external checkout that happens to contain similar files.

## Client registration

- `.mcp.json` starts both launchers through `$CLAUDE_PROJECT_DIR` so the agent
  resolves them from the active project root.
- `.codex/config.toml` uses `cwd = "."` and repository-relative launcher paths.
  Both servers are enabled and required so Codex waits for their handshakes.
- `opencode.json` uses the same repository-relative launchers.

The Codex configuration follows the official
[Codex MCP documentation](https://developers.openai.com/codex/mcp/). Restart a
client after changing its project configuration.

## Health checks

After building both implementations, run from the repository root:

```bash
MCP_HEALTHCHECK=1 bash scripts/run_nwn_official_mcp.sh
MCP_HEALTHCHECK=1 bash scripts/run_nwnx_mcp.sh
```

The NWNX result reports `accepted` only when the revision, `headerSha256` and,
when the lock carries one, `docSha256` all match.

The native result must identify the reviewed **vendored** `nwscript.nss` — the
source id it prints is the `sha256` recorded in both `mcp/source-lock.json` and
`documentation/nwscript/reference/source.json`, and the three must agree. The
NWNX result must identify the revision recorded for the internal `nwnxee/`
submodule and report it as accepted.

To confirm the launcher is reading the vendored copy rather than a game
installation that happens to match:

```bash
MCP_HEALTHCHECK=1 bash -x scripts/run_nwn_official_mcp.sh 2>&1 | grep NWN_NWSCRIPT_PATH
```

### Checking `nwnxee` against upstream

The submodule tracks a personal fork. To see whether it is behind the real
upstream without leaving a remote behind:

```bash
git -C nwnxee remote add upstream https://github.com/nwnxee/unified.git
git -C nwnxee fetch --quiet upstream master
git -C nwnxee rev-list --count HEAD..upstream/master
git -C nwnxee diff --stat HEAD upstream/master -- 'Plugins/*/NWScript/nwnx_*.nss' '*.md'
git -C nwnxee remote remove upstream
```

Checked 2026-08-25: the pin `3d4c4e13c6` **is** upstream `master` HEAD, zero
commits behind.

Advancing it changes `headerSha256`, `docSha256` and every count in the lock, so
it is its own reviewed change and never a side effect of another one.

## Updating dependencies

Routine consumer use never advances a dependency:

```bash
git submodule update --init --recursive -- \
  mcp/nwn-official-mcp mcp/nwnx-mcp nwnxee
```

To adopt a reviewed upstream change, fetch in the selected submodule, check out
the reviewed published commit, run its checks and source validation, update
`mcp/source-lock.json` when its authoritative source identity changed, and then
commit the consumer gitlink. Never modify an MCP implementation inside a PDB
change. Shared MCP improvements belong in their provider repositories and must
be published before this consumer advances its pointer.

An MCP query must never run `pull`, `commit`, or `push`.

### Native behavior notes are not currently an MCP corpus

`nwn-official` indexes the exact declarations and comments in the reviewed
`nwscript.nss`. It does not ingest PDB documentation, probes, release notes or
2DA column semantics. Discovering reusable engine behavior therefore updates
`documentation/nwscript/engine-behavior.md`, not the MCP implementation, unless
the parser omitted or misread material already present in its source.

The provider currently returns NWN Lexicon URLs as supplementary metadata. PDB
agents must not follow them: the site is inaccessible to agent tooling and the
root contract deliberately excludes it. Removing that recommendation from the
provider is owed in the provider repository; it must be published and reviewed
there before this repository advances the submodule pointer.

## Failure modes

- Missing `dist/`: run `npm ci` and `npm run check` in the affected MCP
  submodule.
- Missing `nwnxee/Plugins/`: initialize the internal `nwnxee` submodule.
- Dirty `nwnxee/`: stop and resolve or discard the local source change before
  updating the lock.
- Source-lock mismatch: validate the intended source and review the API delta;
  do not bypass the lock for normal client use.
- MCP startup timeout: run the launcher health check directly, correct the
  underlying failure, and restart the client.
