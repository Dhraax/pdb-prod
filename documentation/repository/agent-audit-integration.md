# Agent Audit Integration

PDB consumes the provider-neutral audit engine from the pinned `agents-config`
submodule. The generic state machine and adapter contract are authoritative in:

- `agents-config/documentation/auditing/README.md`;
- `agents-config/documentation/auditing/reviewer-interface.md`;
- `agents-config/documentation/configuration/README.md`.

This document records only PDB-specific integration.

## Local entry point

Use the managed root wrapper:

```bash
scripts/agent_audit.sh prepare <candidate-commit>
scripts/agent_audit.sh review <candidate-commit>
scripts/agent_audit.sh finalize <candidate-commit>
```

The wrapper delegates to the exact engine pinned by the consumer gitlink. Do
not call an adapter or model CLI directly and do not recreate the retired
`codex_audit.sh` or `codex_review.sh` workflows.

## PDB configuration

`.agents/config.json` enables the gate, selects the current reviewer and model,
and caps `.audit/` retention at 48 hours. `.agents/prompts/audit.md` adds PDB
risks without changing the commit boundary, one-call budget, severities, or
structured result.

The prompt contains no secrets. Reviewer artifacts must exclude environment
files, credentials, player data, private server configuration, and runtime
databases.

## Verification handoff

Before the candidate commit, run the smallest deterministic checks required by
the root `AGENTS.md`. For `.nss` changes, the handoff records the mandatory
focused `./linux_build.sh --check <explicit files>` command and observed
result. Full packaging, server startup, and in-game validation remain with the
user unless explicitly delegated.

After the single review, disposition every finding, apply accepted remediation,
repeat affected deterministic checks, and use `finalize`. Finalization is local
and does not invoke another reviewer.

Codex does not invoke Codex to review its own implementation. In that case it
reports that the independent gate was not run and provides the deterministic
evidence it did observe.
