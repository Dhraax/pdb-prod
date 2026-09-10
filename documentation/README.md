# PDB Documentation

Canonical documentation for the Puerta de Baldur (PDB) **development** module,
`PB_EE_PGCC.mod`. Repository behavior rules live in `AGENTS.md` at the
repository root; this tree holds architecture, systems, workflows, and decisions.

This file is the only canonical index in the documentation root. Canonical
technical documents belong to a module directory, and each module directory
owns a `README.md` that defines its scope and indexes its documents.

The owner also keeps working and publication files in this directory. They are
deliberately outside the canonical index:

- `forum-post-format.md` is the mandatory formatting reference whenever a forum
  post is requested;
- `artifice.md`, `forum-post-hechizos.md`, `forum-post-oficios.md`, and
  `pruebas-hechizos.md` are owner-managed working material, not sources of
  technical truth;
- `Oficios Basicos - Etapa 1 - 2026 - Testers.xlsx` is an owner-managed design
  and testing workbook, not a player or runtime reference.

Do not move, rewrite, index, or infer current behavior from those owner-managed
files unless the user explicitly asks. A forum-ready document may be produced
from canonical information, but its BBCode copy does not become another
authority.

## Modules

| Module | Scope |
|--------|-------|
| [`nwscript/`](nwscript/README.md) | NWScript style guide, base script template, and language/engine notes |
| [`database/`](database/README.md) | Persistent storage: current backend ownership, PWDB identity, completed DEV migration record, and production transfer runbooks |
| [`control-panel/`](control-panel/README.md) | Reusable administrative panel: product identity, compatibility boundary, user management, and feature authorization |
| [`oficios/`](oficios/README.md) | CNR crafting and tradeskill system: [current implementation and promotion status](oficios/cnr/README.md), recipe catalogue, profession datasets, and historical migration records |
| [`rules/`](rules/README.md) | Ruleset mechanics where the server departs from stock NWN:EE or the answer is spread across too many scripts: bonus stacking, and what is known to be wrong with it |
| [`pending-changes/`](pending-changes/README.md) | Active proposals and partially implemented work whose remaining decisions or validation are not yet closed |
| [`changelog/`](changelog/README.md) | What changed and what has to be tested for it, by month, split between the trade systems and the rest of the module |
| [`repository/`](repository/README.md) | Repository operations: Git safety, synchronization, bounded external review, and developer-tool integration |

## Conventions

- Technical documents are written in English and stored as UTF-8 Markdown.
  Player-facing and owner-managed publication material may remain Spanish.
- Record durable findings here in the same change that produced them. Document
  behavior, constraints, failure modes, and corrected assumptions rather than
  copying API signatures.
- Use the `nwn-official` MCP and its vendored `nwscript.nss` for native API
  declarations and engine comments. Use the `nwnx` MCP and pinned `nwnxee/`
  source for NWNX. Record behavior not established by either in the owning
  canonical document with exact provenance; use
  [`nwscript/engine-behavior.md`](nwscript/engine-behavior.md) for reusable
  engine-wide findings.
- Do not create competing catalogs inside tool-specific instruction files.
- Add a new module directory only when the existing boundaries do not fit; when
  you do, add its `README.md` and list it in the table above in the same change.

## Adding a module

1. Create `documentation/<module>/`.
2. Add `documentation/<module>/README.md` stating the module's scope and
   indexing its documents.
3. Add the row to the Modules table above.

## Document lifecycle

Every indexed document has one role:

- **Current** describes behavior that is true now.
- **Proposal** describes behavior not yet implemented.
- **Active work** may contain completed slices only while the same change set
  still has open decisions or validation.
- **Historical** preserves a completed migration or investigation and must say
  which current document supersedes it.
- **Player-facing** explains behavior to players and must follow the current
  technical authority rather than becoming a second one.

Do not preserve an obsolete claim in a current document and append a correction
hundreds of lines later. Rewrite the authoritative statement. Keep the old
reasoning in Git history or in an explicitly historical record.
