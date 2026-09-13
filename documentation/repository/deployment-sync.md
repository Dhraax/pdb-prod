# Development Deployment Sync

`rsync.sh` deploys the staged development runtime to the remote host at
`nwserver@192.168.1.142:/home/nwserver/`. It is a transport step only: it does
not build the module, start Docker, restart either stack, or migrate the panel
database.

## Deployment sources

The remote NWN stack is synchronized from `server/`, not directly from the
repository's root `config/`, `modules/`, or `tlk/` directories. Run
`linux_run_server.sh` after a build when the staging contents need to be
refreshed. This keeps the remote server aligned with the exact local runtime
that was staged and reviewed.

The complete staged `server/` tree is mirrored into
`/home/nwserver/dev-server/`. Removed deployment files are deleted from the
remote copy after a successful transfer. The sync also installs:

- the Linux Neverwinter utility directory used by the remote workflow;
- `server-restart.sh`, `web-restart.sh`, `db-restore.sh`, `db-apply.sh`, and
  `nwsync.sh` in `/home/nwserver/`;
- the repository's `migration/` directory, mirrored into
  `/home/nwserver/dev-server/migration/`, which is where `db-apply.sh` looks
  for it.

Persistent runtime state is deliberately not synchronized. This includes
databases, server vault characters, saves, logs, NWSync state, and the
cryptographic secret. Those paths are protected from both transfer and remote
deletion because they belong to the remote host.

After synchronization, run `/home/nwserver/server-restart.sh` on the remote
host to recreate the NWN development stack. The helper deliberately applies
the remote-only server passwords and Master List publication setting to every
staged `config/nwserver*.env`, then removes the existing cryptographic secret
so the remote runtime generates its own. The staged Compose file decides which
environment file the server actually consumes.

## Control Panel deployment

The panel source is synchronized to the legacy compatibility path
`/home/nwserver/cnr-editor/`. The
deployment-only `cnr-editor/remote.env` file is installed as `.env` and carries
only non-secret Compose controls:

- the remote panel port and frontend origin;
- the remote Compose network name;
- the relative path to `/home/nwserver/dev-server/config/mysql.env`;
- the write gate and session cookie settings.

The database credentials remain in `server/config/mysql.env`; the sync sends
that staged file to `dev-server/config/` and the panel references it from
there. Do not add database credentials to `remote.env` or commit secret files.

The remote recipe feature is read-only by default because
`CNR_EDITOR_WRITES_ENABLED=false` is part of the deployment configuration.
Enable catalogue writes only after the generic in-game consumer has passed its
runtime validation.

Run `/home/nwserver/web-restart.sh` on the remote host to rebuild and recreate
only the panel API and web containers. The NWN server stack must already be
running because the panel joins its MySQL network.

## Taking database changes to the remote host

`db-restore.sh` only loads a full dump into an **empty** database; it aborts as
soon as it finds a single table. That is the host-migration tool and it is no
help when the remote database is already carrying characters.

`db-apply.sh` is the one for a live database. It runs in either place and
finds its own way around: the stack is `dev-server/` on the remote host and
`server/` on the workstation, and the migrations come from whichever copy sits
beside the stack, falling back to the repository's own `migration/`. It prints
both paths before asking for confirmation, so a run against the wrong database
is visible before it happens.

On the remote host, after `rsync.sh`:

```
./rsync.sh                  # from the workstation
ssh nwserver@192.168.1.142
./db-apply.sh               # answer APPLY
./server-restart.sh
```

On the workstation, against the local stack, just `./db-apply.sh`.

**Restart the server after applying the catalogue.** Step 3 drops and recreates
the catalogue tables, and `recipe_id` is assigned by the generator in iteration
order, so rebuilding the catalogue renumbers rows: "Zafiro tallado" was 951 on
2026-08-17 and is 246 now. A player who chose a recipe before the apply keeps
its old id in memory, and the craft attempt then answers *"Esa receta ya no
esta disponible. Vuelve a elegirla."* Picking the recipe again clears it, and a
restart clears it for everyone. Reported from the test server on 2026-08-19 and
confirmed to survive nothing but the restart. The engine logs which of the two
causes it was; see `crafting-system.md` section 6.

It applies the migrations in the only order that works — identity, then the
player state that points at it, then the catalogue, then the legacy drop:

| Order | File | What it is |
|---|---|---|
| 1 | `pwdb/01_identity_schema.sql` | accounts and characters, `IF NOT EXISTS` |
| 2 | `cnr/00_player_state_schema.sql` | `cnr_tradeskill`, `cnr_character_setting`, `IF NOT EXISTS` |
| 3 | `01_schema.sql` | drops and recreates the twelve catalogue tables |
| 4 | `02_seed.sql` | professions, stations, tools, materials |
| 5 | `03_catalogue.sql` | the recipes |
| 6 | `05_arcane.sql` | arcane groups, properties and steps |
| 7 | `04_drop_legacy.sql` | removes three obsolete tables |

**Why this does not cost anyone their progress.** The catalogue is disposable
by design: every `DROP` and `DELETE` in the migrations names a catalogue table.
The tables that hold what players own are created with `IF NOT EXISTS` and
appear in no `DROP` and no `DELETE`, and `cnr_tradeskill` has a foreign key to
`pwdb_character` only, never to the catalogue, so rebuilding the catalogue does
not reach it.

The script does not take that on trust. It counts characters, tradeskill rows
and character settings before and after, and **fails if any of the three went
down**. It also takes a `mysqldump` into
`<stack>/db-backups/pre-apply-<timestamp>.sql.gz` before touching anything,
and every failure path names that file. If a migration fails halfway, the
database is left half-applied on purpose: restore the dump rather than starting
the server on it.

`--yes` skips the confirmation, for when it runs from another script.

## Safety checks

Before transferring anything, `rsync.sh` verifies that the staged module,
Compose file, settings, panel configuration, tools, and remote helpers exist.
If staging is stale, refresh it with `linux_run_server.sh` before syncing.
The server mirror uses delayed deletion so obsolete deployment files are
removed only after transfer, while the excluded persistent paths remain
untouched.

When `db-backup.sh` has staged a complete package under
`server/db-transfer/`, the sync sends that package separately to the matching
remote path. An ordinary deployment without a package leaves any remote
transfer archive untouched. The authoritative capture and restore procedure is
[`documentation/database/host-migration.md`](../database/host-migration.md).
