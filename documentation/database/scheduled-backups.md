# Scheduled Server Backups

`server-backup.sh` makes the daily backup of the running server: the MySQL
database and the servervault, in one compressed archive, followed by
retention. It is meant for cron on the server host.

## Install

`host-sync.sh` sends `server-backup.sh`, executable, to the server stack
directory on the host (the one holding `docker-compose.yml` and
`servervault/`, `~/nwneeserver` on the production host) with the other helper
scripts. It only sends it: cron is set up once, by hand. Create the backup
directory (cron opens the log file before the script runs, so the directory
must already exist), run it once by hand, and add one line with `crontab -e`
as the user that runs Docker:

```bash
mkdir -p ~/pdb-backups && chmod 700 ~/pdb-backups
~/nwneeserver/server-backup.sh
```

```cron
0 6 * * * /home/baldurs/nwneeserver/server-backup.sh >> /home/baldurs/pdb-backups/cron.log 2>&1
```

Cron uses the host's time zone, so 06:00 is server time.

## What it writes

`$BACKUP_DIR/pdb-backup-YYYY-MM-DD_HHMMSS.tar.gz`, plus a `.sha256` beside it.
An existing archive of the same name is never replaced: the run stops.
The archive holds `database.sql.gz` (`mysqldump --single-transaction` of the
stack's application database, read-only and consistent while players are
online) and `servervault/`. A character saved while tar reads the vault is a
warning, not a failure.

| Setting | Default | Meaning |
|---|---|---|
| `STACK_DIR` | the script's own directory | Stack with `docker-compose.yml` and `servervault/` |
| `BACKUP_DIR` | `$HOME/pdb-backups` | Where archives go. Keep it outside the stack so a deployment sync cannot delete it |
| `KEEP_MONTHS` | `0` | Monthly archives kept; `0` keeps them all |

The archive is written under a temporary name and published only after the
dump ends with MySQL's "Dump completed" line, the archive reads back and its
checksum is written. A failed
run leaves every earlier archive in place and prunes nothing. A lock stops a
second run from starting while one is still going.

## Retention

Applied after each successful backup, or alone with `--prune-only`:

| Age | Kept |
|---|---|
| 0-7 days | every archive |
| 8-35 days | the newest of each ISO week |
| older | the newest of each month |

The newest archive of a month is also kept while it is still in the weekly
range, so a week spanning two months keeps the last of both.

Tested on 2026-09-28 with 121 daily archives: 16 kept - eight days, the newest
of each week back to five weeks plus 2026-08-31, the last of August although
its ISO week ends in September, and the last of each month before that.

## Restore

```bash
tar -xzf pdb-backup-YYYY-MM-DD_HHMMSS.tar.gz
# database.sql.gz into an empty database, as in host-migration.md
# servervault/ over the stack's servervault with the server stopped
```

## Not verified

The full run was not exercised on 2026-09-28 because the local stack was
stopped; the script refused cleanly. Run it once by hand on the host and list
the archive (`tar -tzf`) before relying on cron.
