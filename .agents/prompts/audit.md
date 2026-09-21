# PDB Audit Focus

Apply the project-specific contracts in the root `AGENTS.md`. Pay particular
attention to NWScript callers and includes, module event bindings, resrefs and
tags, persistence keys and schemas, source-versus-generated paths, focused
compilation evidence, and the safety boundaries around packaging, deployment,
server operations, and sensitive configuration.

Do not widen the immutable candidate-commit boundary or report unrelated legacy
defects. PDB-specific evidence narrows review priorities; it does not change the
provider-neutral severity, output, or one-review contract.

## Read every changed line, not the handoff's summary of it

The handoff states what the author believes was done. Several PDB audits have
turned on the gap between that belief and the diff: a survey described as
case-by-case that had skipped twelve cases, a grep result reported as zero that
returned one per file, a four-step source trace whose fourth step was assumed
rather than read, and a first parent named as a commit that was the candidate's
child. Treat every claim in the handoff as a claim to check, including the
arithmetic.

For each changed hunk, ask:

- **Does the replacement do what the original did**, for every branch, including
  the ones the author did not mention? A conversion that preserves the common
  path and drops a guarded one is the failure mode here.
- **Is anything now unreachable, unassigned, or written and never read?** This
  module has a history of both: a counter written on every effect application
  and read nowhere, an `eLink` applied without being assigned, an `nDamage * 2;`
  that computes and discards, and a tag overwritten by a later `TagEffect` on the
  link that contained it.
- **Does a 2da edit survive the call site?** `EffectAreaOfEffect` takes script
  names, and an explicit `""` overrides the row rather than deferring to it.
  A row change is inert wherever a caller passes the empty string.
- **Does a change of identity change who is affected?** Widening a match from
  one spell row to a whole area type, or from one caster to any caster, is a
  ruleset change wearing a bug fix's clothes. Say so when it happens.
- **What has to be true at runtime that nobody measured?** Name it. "Compiles"
  and "the checker passes" are not evidence about behaviour, and this project
  has shipped both while the behaviour was wrong.

## Two conventions of this repository, so the attempt is not spent on them

**A changelog entry whose `**Commits.**` line reads `<pending>` is correct, not
incomplete.** A commit cannot name itself. This repository fills that placeholder
in the single direct remediation child, which is the only shape
`scripts/agent_audit.sh finalize` accepts, and `AGENTS.md` and
`documentation/repository/audit-log.md` both say so. Do not raise it as a
finding. An entry that is *missing* - a player-visible change with no changelog
entry at all, or one whose text contradicts the change - is a real finding and
this does not excuse it.

**The worktree carries the owner's uncommitted work**, typically under
`documentation/oficios/`, `haks-2da/`, `migration/` and `src/cnr/`. It is
deliberately outside every candidate. Do not report it.

Report the exact file and line for every finding, and quote the code rather than
paraphrasing it.
