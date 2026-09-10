# Character Rebuild Workflow

This document is the canonical implementation and production-port contract for
rebuilding a player character while preserving its existing persistent
identity and domain data. It covers the DM object, module wiring, database
migration, operating sequence, failure handling, verification, and rollback.

The core invariant is:

> The replacement BIC receives the old `character_id`; the provisional
> replacement `character_id` and its complete child tree are deleted.

The old row is not re-parented and the old domain tree is not copied. Migration
changes the engine UUID associated with the existing old row, preserving every
system already keyed by that `character_id`.

## Runtime resource wiring

The rebuild tool is not placed in an area GIT. The existing `dmfi_exploder`
item remains the DM tool generator. When a DM activates it, the established
module activation script runs first and the wrapper then creates one rebuild
wand if the DM does not already possess one.

The complete resource chain is:

```text
module.ifo: Mod_OnActvtItem = pwdb_mod_act
|
+-- activated item tag dmfi_rebuild
|   `-- target player -> rebuild_tool dialogue
|       +-- Request BIC deletion -> rebuild_prompt
|       |   `-- player dialogue borrarpjs
|       |       +-- confirm -> rebuild_bic
|       |       `-- exit/abort -> rebuild_cancel
|       +-- Clean character -> rebuild_clean -> PWDB cleanup API
|       `-- Migrate character -> rebuild_migrate -> PWDB migration API
|
`-- every other item -> pb_mod_activate
    `-- dmfi_exploder additionally grants dmfi_rebuild after legacy handling
```

This delegation is synchronous and preserves the established activation path
for every unrelated item. Production must merge this behavior with the script
currently assigned to `Mod_OnActvtItem`; it must not assume that production
also uses `pb_mod_activate`.

## DM object specification

| Field | Required value |
|-------|----------------|
| Source | `src/shared/uti/dmfi_rebuild.uti.json` |
| Name | `Varita de rehechos` |
| Template resref | `dmfi_rebuild` |
| Tag | `dmfi_rebuild` |
| Base item | Torch, GFF base item value `15` (`baseitems.2da` row `15`) |
| Activation property | Cast Spell, property `15`, subtype `ACTIVATE_ITEM_L` (`513`) |
| Plot / cursed / identified | Enabled |
| Palette | Custom palette id `53` |
| Creation point | `CreateItemOnObject("dmfi_rebuild", oDM)` after a DM activates `dmfi_exploder` |
| Activation handler | Module event `pwdb_mod_act` branches on item tag `dmfi_rebuild` |
| Valid target | A non-DM player character |
| Dialogue | `rebuild_tool` starts on the DM and stores the player as `REBUILD_TARGET` |

The template resref, tag, Unique Power property, module event assignment, and
wrapper branch are all required. Copying only the UTI creates an inert object.
Copying only the scripts leaves no object that can invoke them. No area
placement or palette edit is required by the DEV implementation.
PROD nevertheless carries one explicit `dmfi_rebuild` custom-palette entry so
builders and DMs can also select the existing blueprint directly; this is a
convenience entry and does not replace the `dmfi_exploder` grant path.

## Resource manifest

Transfer or merge every resource in this table as one bounded production
slice. NWN resources share a flat runtime namespace even though the source tree
organizes them by subsystem.

| Resource | Production action | Contract |
|----------|-------------------|----------|
| `src/module/ifo/module.ifo.json` | Merge only `Mod_OnActvtItem` | Assign the production activation wrapper; never overwrite the complete production IFO |
| `src/shared/uti/dmfi_rebuild.uti.json` | Copy | Rebuild wand blueprint described above |
| `src/pwdb/nss/pwdb_mod_act.nss` | Adapt and copy | Route the rebuild wand, delegate the production activation handler, and grant the wand after `dmfi_exploder` |
| `src/shared/dlg/rebuild_tool.dlg.json` | Copy | DM menu and confirmation branches |
| `src/shared/dlg/borrarpjs.dlg.json` | Merge | Preserve its text and graph while binding confirm to `rebuild_bic` and exit/abort to `rebuild_cancel` |
| `src/shared/nss/rebuild_prompt.nss` | Copy | Transfer DM authorization to the selected player and open `borrarpjs` |
| `src/shared/nss/rebuild_cancel.nss` | Copy | Clear pending deletion authorization |
| `src/shared/nss/rebuild_bic.nss` | Copy | Delete only the current BIC after player confirmation |
| `src/shared/nss/rebuild_clean.nss` | Copy | Delete the provisional database tree, then destroy its container |
| `src/shared/nss/rebuild_migrate.nss` | Copy | Bind the replacement UUID to the old `character_id` and reload runtime state |
| `src/pwdb/nss/pwdb_c_config.nss` | Merge | Define the rebuild safety marker |
| `src/pwdb/nss/pwdb_i_db.nss` | Merge | Ownership-scoped cleanup and UUID migration SQL |
| `src/pwdb/nss/pwdb_i_user.nss` | Merge | Public cleanup/migration API and persistence guard |
| `cnr-editor/backend/migrations/versions/0010_character_rebuild_cleanup.py` | Apply before later migrations | Preserve the rebuild migration boundary without privileged database objects |
| `cnr-editor/backend/migrations/versions/0015_character_rebuild_counters.py` | Apply after `0014_integral_permissions` | Add two available uses and the completed-use counter to every character |

The scripts also depend on the existing `CONTENEDOR_VARIABLES` contract and
its `PWDB_CHARACTER_ID` local integer. In DEV, the container resref is
`dmfi_pc_emote`, declared by `mti_libreria.nss`. Production must confirm the
same container semantics before porting; changing only its display name is not
relevant, but changing its resref, persistent variable helper, or local key is.

`rebuild_bic.nss` and the PWDB public include depend on the NWNX:EE
Administration plugin through `nwnx_admin`. The target runtime must provide
that plugin and header.

## Database contract

`pwdb_character.character_id` is the persistent identity. The replacement
engine UUID is written to `pwdb_character.character_uuid`; it is not stored as
a second character row after the workflow completes.

The same root row owns `rebuilds_available` and `rebuilds_completed`. Migration
`0015_character_rebuild_counters` initializes every existing and future
character with two available uses and zero completed uses. The deletion request
reads the available count before authorizing any BIC operation. Only a new UUID
migration consumes a use: the UUID binding, available decrement, and completed
increment share one guarded `UPDATE`. A retry after that statement sees the
replacement UUID already bound and skips consumption, so a later snapshot
retry cannot charge the character twice.

The cleanup operation uses a single-table delete constrained by all three live
identity values:

- the provisional `character_id` cached in the new container;
- the replacement BIC UUID returned by the engine;
- the account selected by the presented public CD key.

Exactly one affected root row is required. InnoDB then removes all
foreign-key-owned children through `ON DELETE CASCADE`. A single-table delete
is intentional because MySQL warns that optimizer ordering in multi-table
deletes can conflict with InnoDB foreign keys. See the
[MySQL 8.4 DELETE statement documentation](https://dev.mysql.com/doc/refman/8.4/en/delete.html).

`pwdb_identity_revision` has a deliberate polymorphic target and therefore no
foreign key to `pwdb_character`. The cleanup implementation explicitly deletes
only revision rows joined to a character matching the cached ID, live UUID, and
presented CD key. It then deletes the same constrained character root. This
keeps the runtime compatible with least-privilege MySQL users when binary
logging is enabled; no trigger, stored routine, `SUPER`, or
`log_bin_trust_function_creators` setting is required. Migration
`0010_character_rebuild_cleanup`, whose predecessor is
`0009_character_level_unlocks`, remains as a no-op compatibility boundary so
the published Alembic chain stays stable.

NWNX:EE's SQL plugin keeps one MySQL connection for its prepared-query target,
but its public NWScript API sends every statement through the prepared API.
MySQL does not permit `START TRANSACTION` as a prepared statement, so the two
deletes cannot be wrapped safely through that interface. Revision cleanup runs
first: if the root delete later fails, the character and container are
preserved, but provisional audit revisions already removed by that attempt are
not restored. This is a deliberate, bounded failure mode that favors character
data over disposable provisional audit history. See the
[MySQL prepared-statement restrictions](https://dev.mysql.com/doc/refman/8.4/en/sql-prepared-statements.html)
and [transaction control documentation](https://dev.mysql.com/doc/refman/8.4/en/innodb-autocommit-commit-rollback.html).

Migration validates that the old `character_id`:

- belongs to the public CD key presented by the replacement player;
- has an active character profile;
- does not conflict with another row already using the replacement UUID.

It then updates the old row's UUID, observed name, and last-login timestamp,
clears its profile snapshot marker, and captures engine-owned profile and class
data from the replacement BIC. The old `character_id` and its domain data do
not change.

Same-CD-key validation cannot distinguish two different old characters owned
by the same game account. The saved old container is therefore an operational
authority: the DM must verify that it came from the exact character being
rebuilt. The database check prevents cross-account migration, not selection of
the wrong character on one account.

## Required operating sequence

1. The DM saves the old character copy, including its original variable
   container and any objects that must be restored manually.
2. The DM activates `dmfi_exploder` if the rebuild wand is not already present.
3. The DM uses `Varita de rehechos` on the old player and selects
   `Solicitar borrado del BIC`. The tool reads the persistent counter and
   refuses the request without touching the BIC when no rebuild is available.
4. The player selects the confirmation option. Selecting Exit or aborting the
   dialogue only clears authorization and changes nothing.
5. Confirmation freezes the player and, after four seconds, deletes only the
   current server-vault BIC with backup preservation disabled. It does not
   modify the old database row.
6. The player creates the replacement BIC and enters the server. Normal login
   creates its provisional character row, child tree, and new variable
   container.
7. The DM uses the rebuild wand on the replacement player and selects
   `Limpiar personaje`. Cleanup requires exactly one current container and a
   database match for its cached id, live UUID, and CD key.
8. Only after MySQL confirms exactly one deleted root does the script destroy
   the new container. Persistence is disabled on the live player for the rest
   of this intermediate state.
9. The DM manually copies the saved old container to the replacement player
   and restores the other saved objects.
10. Without allowing the player to log out, the DM targets the player again and
    selects `Migrar personaje`.
11. The tool reads the old `PWDB_CHARACTER_ID`, validates ownership, assigns
    the replacement UUID to that old row, decrements `rebuilds_available`,
    increments `rebuilds_completed`, refreshes captured metadata and level
    unlocks, reloads CNR state, and reports success or a bounded failure.
12. Only after the success message may the player leave or resume normal play.

Cleanup and migration must occur in the same player session. The local safety
marker exists only on the live player object and intentionally prevents
character-owned systems from recreating the provisional identity between both
steps.

## Failure handling and recovery

| Failure point | Guaranteed behavior | Operator action |
|---------------|---------------------|-----------------|
| Player cancels BIC deletion | Authorization is cleared; BIC and database remain unchanged | Restart only if deletion is still intended |
| No rebuild is available | Authorization and BIC deletion are refused; counters remain unchanged | Resolve the allocation policy outside the wand before starting |
| Unauthorized BIC deletion | Script refuses and logs the attempt | Use the DM wand to start a new authorization |
| Cleanup ownership or SQL failure | Provisional row and new container are preserved | Diagnose the database; retry cleanup only after correcting the cause |
| Cleanup succeeds | Provisional tree and new container are gone; persistent writes are disabled | Copy the correct old container immediately and migrate in the same session |
| Migration ownership/UUID/SQL failure | Restored old container is preserved; safety marker remains | Do not let the player leave; correct the cause and retry `Migrar personaje` |
| Identity migrates but CNR cache reload fails | Identity migration remains committed and the tool emits a warning | Do not repeat cleanup; diagnose CNR and reload its cache separately |
| Player disconnects after cleanup but before migration | The same-session safety guarantee is lost | Stop the procedure and recover from the saved old copy; do not improvise against production data |

The current DB migration is not wrapped in an explicit multi-statement
transaction by NWScript. Its UUID update is verified after execution and a
failed subsequent snapshot refresh reports failure, but the identity update may
already be committed. Retrying `Migrar personaje` with the same correct old
container is the intended recovery because the ownership and UUID checks accept
the already-correct relation. The retry also detects the already-bound UUID and
does not decrement `rebuilds_available` or increment `rebuilds_completed`
again. Never run `Limpiar personaje` again after the old identity has been
migrated.

## Production deployment gate

Perform the port in this order:

1. Back up the production MySQL database and server vault through the
   production backup policy.
2. Confirm production already has the Alembic history through
   `0009_character_level_unlocks` and all character-owned foreign keys use
   `ON DELETE CASCADE`.
3. Merge the complete Alembic chain through
   `0015_character_rebuild_counters`. Migration `0010` advances history without
   creating a privileged object; migration `0015` adds and initializes both
   rebuild counters.
4. Confirm the application database user can delete from
   `pwdb_identity_revision` and `pwdb_character`. Do not grant `SUPER` and do
   not enable `log_bin_trust_function_creators` for this workflow.
5. Inspect production's current `Mod_OnActvtItem` value and its handler. Adapt
   `pwdb_mod_act` to delegate to that handler, then merge only the IFO field.
6. Copy or merge every item in the resource manifest. Do not copy the DEV IFO
   wholesale and do not replace production dialogues without graph review.
7. Run production's focused, non-writing compiler check for every changed
   executable script and representative consumers of changed includes.
8. Validate the changed UTI, DLG, and IFO JSON and confirm every dialogue script
   resref exists.
9. Use production's own packaging and deployment workflow. Do not copy the DEV
   module artifact.
10. Execute the acceptance test below in a controlled environment before using
    the tool on a real production character.

The database migration chain must precede the module deployment. If rollback
is needed, roll back the module first. Migration `0015` owns both counter
columns; migration `0010` owns no schema object.

## Acceptance test

Use a disposable account and character with a database backup. Record ids only
in private operational notes; do not place CD keys or player records in the
repository.

1. Activate an unrelated Unique Power item and confirm its original handler
   still runs through delegation.
2. Activate `dmfi_exploder` as a DM and confirm exactly one
   `Varita de rehechos` is granted, even after repeated activation.
3. Confirm a non-DM cannot use the wand and that DM/invalid targets are refused.
4. Start BIC deletion and select Exit. Confirm the BIC and old character row
   still exist and both rebuild counters are unchanged.
5. Repeat and confirm deletion. Confirm only the BIC is deleted and the old
   character row and domain data remain.
6. Create and enter the replacement character. Record its distinct provisional
   `character_id` and confirm it has exactly one new variable container.
7. Run `Limpiar personaje`. Confirm the provisional root, its foreign-key
   children, and its polymorphic revision targets are absent; confirm the old
   root remains and the new container is gone.
8. Copy the saved old container. Run `Migrar personaje` without disconnecting.
9. Confirm the old `character_id` now carries the replacement engine UUID and
   that its pre-existing domain rows, creation date, unlock grants, and CNR
   state remain associated with that same id. Confirm available uses decreased
   from two to one and completed uses increased from zero to one.
10. Relog the replacement character. Confirm identity resolves normally and no
    duplicate character row is created.
11. Review `[PWDB:REBUILD]` logs for the expected masked operational events and
    verify that no complete CD key was written.
12. On a disposable character with zero available uses, request BIC deletion
    and confirm the wand refuses before opening the player confirmation.

Static compilation and JSON validation cannot prove server-vault deletion,
explicit revision cleanup, container copying, or relog behavior. Those items
require the controlled runtime test above.

## DEV verification record

The implementation slice was checked without writing bytecode or packaging the
module:

```bash
./linux_build-dev.sh --check \
  pwdb_mod_act.nss \
  rebuild_prompt.nss \
  rebuild_cancel.nss \
  rebuild_clean.nss \
  rebuild_migrate.nss \
  rebuild_bic.nss \
  wrap_on_clnt_ent.nss
```

Result: seven successful compilations, zero skipped, zero errors. The changed
UTI, DLG, and IFO JSON parsed successfully; dialogue graph indices and script
resrefs were checked; and the Alembic migration parsed as Python. Alembic and
SQLAlchemy were not installed in the host Python environment, so the migration
was not executed against a live database. No module package, server startup,
deployment, or in-game validation was performed.

A later control-panel startup exposed that MySQL rejects trigger creation with
error 1419 when binary logging is enabled and the application user lacks
`SUPER`. The correction removed the privileged trigger from migration `0010`
and moved ownership-scoped revision deletion into the existing NWScript cleanup
path. The affected consumers were then checked with:

```bash
./linux_build-dev.sh --check rebuild_clean.nss wrap_on_clnt_ent.nss
```

Result: two successful compilations, zero skipped, zero errors. Migration
`0010` also passed Python bytecode compilation and the focused diff passed
whitespace validation. The corrected panel image was not rebuilt or restarted
as part of that correction.

## Rollback

1. Disable access to the rebuild wand or deploy the previous module first.
2. Restore production's previous `Mod_OnActvtItem` assignment or remove only
   the rebuild branch while preserving its existing activation behavior.
3. If an exact migration-history rollback is required, downgrade the chain from
   `0015_character_rebuild_counters` only after the module rollback. Downgrading
   `0015` removes both counters; `0010` owns no database object.
4. Never use a migration downgrade or code rollback to repair a partially
   rebuilt real character. Recover that character from the pre-operation
   database and server-vault backups under a specific incident plan.
