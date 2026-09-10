# MySQL Host Migration

This is the canonical procedure for moving the live PDB development database
to a new host. It transfers the complete application database, including
PWDB accounts and characters, CNR progress, the current recipe catalogue,
editor users and recipe revisions. It does not copy MySQL users or credentials;
the destination keeps the credentials configured in its own `mysql.env`.

Do not rebuild a migrated database from `migration/03_catalogue.sql`. That file
is the source-controlled catalogue baseline and may not contain recipe changes
made later through the web editor. A logical dump preserves the actual current
state.

## Artifacts and ownership

| Path | Purpose | Tracked |
|------|---------|---------|
| `db-backup.sh` | Create a consistent logical dump from the local staged MySQL service | Yes |
| `server/db-transfer/database.sql.gz` | Private transfer archive | No |
| `server/db-transfer/database.sql.gz.sha256` | Transfer integrity checksum | No |
| `db-restore.sh` | Restore the archive into an empty remote application database | Yes |

The transfer archive contains private player and administrative data. Keep it
inside the ignored `server/db-transfer/` staging directory, never place it in
`documentation/`, commit it, attach it to an issue, or print its contents.
On Windows/WSL workspaces, the mounted filesystem may not represent requested
Unix modes accurately; protect the workspace with Windows ACLs. The deployment
sync independently forces mode `0700` on the remote transfer directory and
`0600` on its files.

## 1. Prepare the destination

Create the destination's real `config/mysql.env` with its own credentials and
stage the final runtime under `server/`. A fresh destination must use an empty
MySQL named volume. Do not start the NWN module or the web editor against that
database before restoration because either can create tables and the restore
guard will then refuse to continue.

## 2. Capture the source database

With the source development MySQL service running, execute from the repository
root:

```bash
./db-backup.sh
```

The script uses `mysqldump --single-transaction`, compresses the stream,
validates the gzip archive, writes it atomically, and creates a SHA-256
checksum. It refuses to create a transfer package when the source has no
readable CNR recipes.

Creating a new package replaces the previous local transfer archive. It does
not stop or mutate the source database.

## 3. Transfer runtime and database package

Run:

```bash
./rsync.sh
```

When both transfer files exist, `rsync.sh` sends them to
`/home/nwserver/dev-server/db-transfer/` and sends `db-restore.sh` to
`/home/nwserver/`. Normal synchronization without a staged package remains
valid and reports that database transfer was skipped.

The database package is synchronized separately from the main `server/`
mirror. This prevents an ordinary later deployment from deleting the remote
archive merely because no local transfer package is staged.

## 4. Restore on the new host

On the destination host, run:

```bash
cd /home/nwserver
./db-restore.sh
```

The restore helper:

1. validates the checksum and compressed stream;
2. starts only the staged MySQL service and waits for readiness;
3. verifies that the application database contains zero tables;
4. requires the operator to type `RESTORE`;
5. imports the dump using the destination container's own credentials;
6. confirms the restored table and CNR recipe counts.

`./db-restore.sh --yes` skips only the interactive confirmation. It does not
bypass checksum validation or the empty-database guard.

If the target contains any tables, stop and identify why. Do not weaken the
guard or manually merge a full dump into a live database. Recreate the intended
empty destination volume only after confirming its exact Compose project and
backup status.

## 5. Start and verify the services

After a successful restore:

```bash
./server-restart.sh
./web-restart.sh
```

The NWN restart applies the remote-only passwords, enables Master List
publication, and generates the remote cryptographic secret. The web restart
runs Alembic before serving requests, applying only editor schema revisions
that are newer than those contained in the dump.

Verify at minimum:

- MySQL, NWN, editor API and editor web containers are healthy;
- the restored recipe count matches the count printed by `db-backup.sh`;
- an existing editor account can authenticate;
- existing accounts, characters and tradeskill progress are present;
- one recipe can be browsed in game and in the editor;
- the NWN server appears in the Master List.

Do not claim migration success from container startup alone.

## 6. Retention and rollback

Keep the source host and its MySQL volume unchanged until destination
validation is complete. The source remains the rollback boundary.

After validation, remove the private transfer archive from both hosts according
to the operator's backup policy. Keep durable backups outside the repository,
outside the live Compose volume, and in access-controlled storage. A backup is
not considered verified until a restore has succeeded.
