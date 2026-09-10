# Vendored native NWScript reference

`nwscript.nss` here is a **byte-for-byte copy of the installed game's
`ovr/nwscript.nss`**. It is not edited, ever. The game owns the content; this
repository owns only *when the copy changes*.

## Why it is here

Three reasons, in order of weight:

1. **The `nwn-official` MCP reads this file, not the game installation.**
   `scripts/run_nwn_official_mcp.sh` exports `NWN_NWSCRIPT_PATH` to it. Every
   machine therefore answers from the same bytes, the `sha256` in
   `mcp/source-lock.json` means something, and the reference changes at one
   controlled moment instead of silently on every game patch.
2. **The MCP's extracted view is not the whole file.** It returns a symbol. The
   file has the comment two lines above it, the constant block it belongs to,
   and the `#define` that explains the magic number. When the MCP is not enough,
   `grep` this file — that is the documented next step, and it replaced the NWN
   Lexicon, which no agent tool can reach.
3. **It survives the game not being installed.** A checkout on a machine without
   NWN:EE still has the complete native API.

## The refresh routine

The copy must never be more than **90 days** behind the installed game.

```bash
./scripts/refresh_nwscript_reference.sh            # --check: report, write nothing
./scripts/refresh_nwscript_reference.sh --refresh  # copy when due, then restamp
./scripts/refresh_nwscript_reference.sh --refresh --force
```

`--check` is read-only and pre-authorized: run it whenever the freshness of an
answer matters.

| Exit | Meaning |
|------|---------|
| `0` | Fresh, or refreshed successfully |
| `1` | `--check` only: a refresh is due |
| `2` | `--refresh` only: no source file could be located |
| `3` | `--refresh` only: the candidate failed validation and was discarded |

`--check` never returns `2` or `3`. It reports a missing game file and still
exits on the freshness of the copy alone, because a checkout without NWN:EE
installed is a supported state.

`source.json` is the flag that makes the interval enforceable:

| Field | Meaning |
|-------|---------|
| `sha256`, `bytes` | What was copied |
| `copiedAt` | When, so the age is computable without git |
| `refreshIntervalDays` | 90 |
| `nextRefreshDue` | `copiedAt` + the interval |
| `gameFileModifiedAt` | The mtime of the game file at copy time |

The script also reports **drift** — whether the game's file differs from the
copy *right now* — independently of whether a refresh is due. Drift inside the
window is expected after a patch and is not an error; it is the warning that
the reference does not yet know about whatever that patch added. Natives are
added, effectively never removed, so a stale copy is incomplete rather than
wrong.

**A refresh validates before it replaces anything.** The candidate is copied to
a temporary file and run through the MCP's own validator; only a report with
`issueCount == 0` is allowed to become the reference, and the same report writes
`sha256`, `semanticSha256`, `functionCount` and `constantCount` back into
`mcp/source-lock.json`. A candidate the parser cannot read is discarded with exit
`3` and the existing reference is untouched — the lock exists to fail closed on
an unreviewed source, and accepting a broken one would make its hash the accepted
hash.

If the MCP is not built the script says so, copies without validation, and
updates `sha256` alone.

Commit a refresh **on its own**: it changes what every future answer is grounded
in.

## Encoding

The file is Windows-1252 with CRLF, and `.gitattributes` marks this path `-text`
so git converts neither. That is what keeps the `sha256` stable across
platforms. Do not remove that rule, and do not open the file in an editor that
will normalise it.
