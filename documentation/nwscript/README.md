# NWScript

Scope: how PDB NWScript is written — file headers, prototype/definition layout,
documentation tags, naming, formatting, and the engine constraints that shape
them.

`AGENTS.md` states these standards in summary form and points here for detail.
Where the two overlap they must agree; if they diverge, fix `AGENTS.md` and this
module in the same change.

## Documents

| Document | Contents |
|----------|----------|
| [`style-guide.md`](style-guide.md) | Full style guide: headers, authorship tracking, prototypes and documentation blocks, naming, formatting, include hygiene, engine limits |
| [`script-template.md`](script-template.md) | Copy-paste base templates for a new include and a new event/action script |
| [`engine-behavior.md`](engine-behavior.md) | Reusable engine behavior not fully stated by `nwscript.nss`: evidence requirements, current-build findings and MCP routing |
| [`reference/`](reference/README.md) | The vendored `nwscript.nss` the `nwn-official` MCP reads, its 90-day refresh routine, and why it replaced the NWN Lexicon |

## Applicability

PDB is a legacy codebase. Apply these standards to:

- new scripts and includes, and
- code materially refactored by the task at hand.

Do not churn untouched legacy files solely to modernize their formatting, and do
not mass-rename, mass-translate, or mass-reformat. Existing Spanish
player-facing content stays Spanish unless translation is the task.

## References

- Native NWScript functions, constants, callbacks, and engine behavior: the
  `nwn-official` MCP, then [`reference/nwscript.nss`](reference/README.md)
  directly when the extracted view is not enough.
- NWNX:EE plugin functions, event data, and return values: the `nwnx` MCP, then
  the `nwnxee/` submodule.

The NWN Lexicon is deliberately absent. It is behind a Cloudflare managed
challenge that no agent tool can pass, it has no upstream repository, and
`nwscript.nss` is the file Beamdog actually ships. `AGENTS.md` carries the full
reasoning. Where neither the engine comment nor the headers establish a
behavior, write a probe against this build and record the result.

Keep native NWN:EE and NWNX APIs clearly distinguished in code and in prose.
