# Database

Scope: PDB's persistent storage — current backend ownership, the PWDB identity
model, CNR character state, and the completed DEV SQLite-to-MySQL migration.

## Documents

| Document | Contents |
|----------|----------|
| [`host-migration.md`](host-migration.md) | Canonical full-MySQL host transfer: private dump staging, rsync transport, empty-target restore, service startup and validation |
| [`data-model.md`](data-model.md) | **The model.** Four layers, the DDL, the login sequence, what is cached where, and the failure policy. Prescriptive — read before writing any persistence code |
| [`pwdb-cnr-production-port.md`](pwdb-cnr-production-port.md) | **Start here for DEV to PROD.** Source boundaries, persistent schemas, hooks, build routing, deployment order, verification and rollback |
| [`integration-runbook.md`](integration-runbook.md) | Historical implementation sequence and measured DEV integration results; the current production checklist above is authoritative |
| [`migration-plan.md`](migration-plan.md) | Historical phased implementation record for moving NWNX_SQL from SQLite to MySQL 8.4 and adopting PWDB; use the production port checklist for deployment |
| [`cnr-catalogue-correction-notes.md`](cnr-catalogue-correction-notes.md) | Historical correction baseline for the first seven-station catalogue migration; current counts and ownership live under `documentation/oficios/cnr/` |
| [`cnr-catalogue-editor-plan.md`](cnr-catalogue-editor-plan.md) | Control-panel foundation and CNR catalogue feature: stack, authorization, screens, translated properties, lifecycle, API and delivery phases |
| [`account-character-management.md`](account-character-management.md) | Admin/technical account and character panel, legacy `gs_*` assessment, normalized classes and extension contract for banking and future systems |
| [`account-cd-key-reset.md`](account-cd-key-reset.md) | Panel-authorized CD-key recapture, denied candidate capture, administrative confirmation, legacy-container synchronization, PROD order and acceptance test |
| [`account-access-security.md`](account-access-security.md) | Aggregated CD-key/IP history, administrator search and global bans enforced before the server-vault character list |
| [`character-rebuild-workflow.md`](character-rebuild-workflow.md) | DM rebuild wand, exact module/resource wiring, provisional cleanup, old identity migration, PROD deployment gate, acceptance test and rollback |
| [`pwdb-identity-porting-guide.md`](pwdb-identity-porting-guide.md) | Upstream reference: the Underworld PWDB account/character identity foundation, Docker Compose, DDL and NWScript |

## Current storage boundary

PDB still exposes three storage APIs, but PWDB identity and the database-backed
CNR runtime now use MySQL through NWNX_SQL in DEV:

| Store | API | Current ownership |
|-------|-----|-------------------|
| MySQL 8.4 | `NWNX_SQL_*` | PWDB accounts/characters, CNR tradeskills/settings, and the replaceable CNR catalogue |
| NWN:EE built-in SQLite | `SqlPrepareQuery*` | Engine-internal consumers such as NUI and `inc_array`; not part of the PWDB/CNR migration |
| BioWare campaign DB | `SetCampaign*`, campaign `cnr_misc` | Retained legacy CNR float/string persistence outside the migrated integer tradeskill path |

Anything describing "the database" without saying which of the three is
ambiguous. See [`data-model.md`](data-model.md) for current ownership and
[`../oficios/cnr/schema.md`](../oficios/cnr/schema.md) for the implemented CNR
schema design. The old pre-migration SQLite/UUID contract
is historical only.

## Related

- [`../control-panel/README.md`](../control-panel/README.md) — general panel
  identity, system-user administration, and compatibility boundaries.
- [`pwdb-cnr-production-port.md`](pwdb-cnr-production-port.md) — current DEV to
  PROD transfer checklist and rollback boundary.
- [`../oficios/cnr/open-issues.md`](../oficios/cnr/open-issues.md) — running log
  of CNR findings, technical debt and parked ideas.
