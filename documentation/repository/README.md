# Repository Operations

Scope: local Git safety policy, remote ownership, synchronization, bounded
external code review, developer-tool integration, and other repository
workflows that do not belong to module runtime, database, or NWScript
documentation.

## Documents

| Document | Contents |
|----------|----------|
| [`remote-policy.md`](remote-policy.md) | Mandatory push destination, read-only PDB upstream, verification, synchronization, and deliberate owner override |
| [`host-sync.md`](host-sync.md) | Sending the production periphery to the online host with `host-sync.sh`: what travels, what is never touched, the private `config/host/` files and the order of work on the host |
| [`deployment-sync.md`](deployment-sync.md) | Staged runtime and CNR editor deployment contract for `rsync.sh` |
| [`agent-audit-integration.md`](agent-audit-integration.md) | PDB parameters and wrapper for the provider-neutral, single-review audit engine |
| [`mcp-integration.md`](mcp-integration.md) | Native API MCP submodules, authoritative source ownership, root-relative launchers, source locking, client registration, and update workflow |
| [`audit-log.md`](audit-log.md) | Every external audit on record: what it covered, what it found, what became of each finding, and the rules that keep the record from evaporating |
| [`performance-measurement.md`](performance-measurement.md) | Reading NWNX profiler metrics out of InfluxDB: the bounded-window rule, which switch measures what, and query recipes for per-script cost and server health |
