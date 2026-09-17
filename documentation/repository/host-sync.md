# Production host sync

`host-sync.sh` sends what this repository owns to the online host's server
directory, `/home/baldurs/nwneeserver` by default. That directory is the host's
equivalent of `server/`: it already holds the haks, TLK, server vault, NWN
database, NWSync state and logs, and the script is built so it cannot touch
them. It is a transport step only: it starts, stops, restarts and migrates
nothing.

```bash
./host-sync.sh --dry-run baldurs@<host>   # list what would change
./host-sync.sh baldurs@<host>             # asks for SYNC before sending
```

`PDB_REMOTE_DIR` changes the server directory and `PDB_SSH` the SSH command, for
example `PDB_SSH="ssh -p 2222 -i ~/.ssh/pdb"`. All transfers share one SSH
connection, so a password is asked once.

## What travels

| Local source | On the host | Mode | Removed files |
|--------------|-------------|------|---------------|
| `docker-compose.yml` | `docker-compose.yml` | 644 | - |
| `run-server.sh`, `server.sh`, `server-restart.sh`, `web-restart.sh`, `db-apply.sh`, `db-reset-players.sh`, `nwsync.sh` | same names | 755 | - |
| `config/nwserver.env`, or `config/host/nwserver.env` when present | `config/nwserver.env` | 600 | - |
| `config/mysql.env`, or `config/host/mysql.env` when present | `config/mysql.env` | 600 | - |
| `config/mysql-init/` | `config/mysql-init/` | 755 | deleted on the host |
| `migration/` | `migration/` | 644 | deleted on the host |
| `cnr-editor/`, without `node_modules/`, `dist/`, caches or `*.env` | `cnr-editor/` | 644 | deleted on the host, except its `.env` |
| `config/host/cnr-editor.env`, or `cnr-editor/host.env.example` when absent | `cnr-editor/.env` | 644 | - |
| `modules/Puerta de Baldur 5E.mod` | `modules/` | 644 | - |

Only the three trees the repository owns entirely - `config/mysql-init/`,
`migration/` and `cnr-editor/` - mirror deletions. Nothing is synchronized at
the top of the server directory as a tree, so `hak/`, `tlk/`, `servervault/`,
`database/`, `logs/`, `override/`, `development/`, `portraits/`, `saves/`,
`nwsync/`, `nwnx/`, `bin/`, `data/`, `temp/`, `cryptographic_secret`,
`settings.tml`, `nwn.ini`, `nwnplayer.ini`, `db-backups/`, other modules, the
host's own `nwn_nwsync_*` tools and any older Compose file are never listed,
overwritten or deleted. Of the module content, only
`modules/Puerta de Baldur 5E.mod` travels.

`nwn_nwsync_write` is deliberately not sent: the host keeps its own NWSync tools
in the server directory, and `nwsync.sh` calls the binary beside it. The host's
existing `run-server.sh` **is** replaced, because the new Compose file starts
the server through it.
Grafana and InfluxDB files do not travel: they belong to the `metrics` profile,
which the host does not run.

The module is written to a temporary file and renamed into place, so a running
server keeps the file it loaded.

## The environment files

The host runs with the same `config/nwserver.env` and `config/mysql.env` as the
local stack: one copy, edited in one place, and the local rehearsal exercises
exactly the values the host receives. Both are ignored by Git.

| File | Created from | Must hold |
|------|--------------|-----------|
| `config/nwserver.env` | `config/nwserver.env.example` | The server's player, DM and admin passwords; `NWN_MODULE=Puerta de Baldur 5E`; `NWNX_SQL_SKIP=n` |
| `config/mysql.env` | `config/mysql.env.example` | `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD` and `CNR_EDITOR_MFA_ENCRYPTION_KEY` |

The ignored `config/host/` holds optional overrides. A `config/host/nwserver.env`
or `config/host/mysql.env` there is sent instead of its counterpart, and a
`config/host/cnr-editor.env` instead of `cnr-editor/host.env.example`. Moving the
main files into `config/host/` instead of copying them leaves the local stack
without its environment: `linux_run_server.sh` fails with `env file ... not
found`.

MySQL applies `MYSQL_*` only when it initialises an empty volume. Changing them
in `config/mysql.env` afterwards does not change the users inside an existing
database, local or remote; that needs an explicit MySQL operation. The MFA key cannot be
regenerated either without locking out every account that enrolled.

## What the script refuses

Values are read as Compose reads an env file: the last assignment wins, an
`export ` prefix and blanks around `=` are ignored, and an unquoted value ends
before ` #`. A checked value written in quotes or containing `$` is refused
rather than interpreted, so what the script vouches for is exactly what Compose
passes on.

Before connecting:

- a missing file or directory among the sources;
- a checked value in quotes or containing `$`;
- a `cambia-*` placeholder from an `.example` in any password, credential or MFA
  key;
- an empty `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER` or
  `MYSQL_PASSWORD`;
- `NWN_MODULE` other than the module it sends, or `NWNX_SQL_SKIP` other than `n`;
- a panel environment that does not read `../config/mysql.env`, does not join
  `server_default`, or publishes the panel on anything but `127.0.0.1`;
- a module older than some `.nss` under `src/`: asked interactively, refused with
  `--yes`.

After connecting: no `rsync` on the host, a server directory that does not
exist, or one with none of `hak/`, `modules/` or `servervault/`, which is taken
as a wrong path.

An empty MFA key only warns: the panel then refuses MFA enrolment.

## Order of work on the host

The script prints this at the end. Everything runs in the server directory.

**First deployment:**

1. `docker stop -t 120 nwnee_baldur && docker rm nwnee_baldur`. The old and new
   Compose files both name the container `nwnee_baldur`, so the new one cannot
   start while the old container exists. The old Compose file is not in the
   server directory, so the container is stopped by name rather than through
   that file.
2. `./db-apply.sh`. It starts MySQL and, on the empty database, creates the
   whole schema and catalogue.
3. `./server.sh start`.
4. `./web-restart.sh`, then create the first administrator with
   `docker compose --env-file cnr-editor/.env -f cnr-editor/compose.yml run --rm api control-panel-bootstrap-admin`.

**Later syncs**, only for what changed:

| Changed | Run |
|---------|-----|
| `migration/` | `./db-apply.sh` |
| The module | `./server.sh restart` |
| `docker-compose.yml` or `config/nwserver.env` | `./server-restart.sh` |
| `cnr-editor/` | `./web-restart.sh` |

NWSync is not part of a module change. It hands clients the haks and the TLK;
the `.mod` stays on the server and players never download it. `./nwsync.sh` is
needed only when a hak or the TLK changes, and this script sends neither.

## Host operations

Both run in the server directory and need Docker Compose v2.

**`./server.sh start|stop|restart|status`** handles only the NWN server.
`start` brings up MySQL and `pb-server`; `stop` stops `pb-server` with a
120-second grace period and leaves MySQL running; `restart` is
`server-restart.sh`; `status` is `docker compose ps`. The control panel is a
separate Compose project and is never started, stopped or rebuilt by it.

**`./db-reset-players.sh`** empties the player data at the end of a test phase
and keeps what the launch needs. It refuses to run while `pb-server` is running
or MySQL is not, lists what it will delete with row counts, asks for `RESET`,
takes a dump to `db-backups/pre-reset-<timestamp>.sql.gz`, deletes in one
transaction, resets the id counters and then checks that the player tables are
empty and every kept table has the rows it had.

| Deleted | Kept |
|---------|------|
| `pwdb_account` and its CD-key, name and IP history, CD-key resets and management rows; `pwdb_character` with its profile, classes and level unlocks; `pwdb_cd_key_ban`; `pwdb_identity_revision`; `cnr_tradeskill`, `cnr_character_setting` | The CNR catalogue (`cnr_profession` to `cnr_arcane_step`) and `cnr_catalogue_revision`; every `cnr_editor_*` table, which is the panel's users, permissions, MFA, sessions and audit; `pwdb_class_definition`; `pwdb_dm_cd_key_whitelist` and its revisions; `alembic_version` |

Any table in neither column stops the script before it deletes anything; a new
table has to be classified in the script first. `servervault/` and the NWN
`database/` directory are files and are not touched: test progress stored in
the characters themselves goes only by restoring a copy of `servervault/` taken
before the test phase.

Verified on 2026-09-17 against a throwaway MySQL 8.4 loaded with a dump of the
local production rehearsal database: 3 accounts, 7 characters and 42 tradeskill
rows went to 0; 559 recipes and 2 panel users stayed, with `CHECKSUM TABLE`
identical for the recipes, components, arcane properties, panel users, panel
permissions and class definitions; the id counter restarted; the dump held the
deleted rows. It refused an unclassified table, a running `pb-server` and any
confirmation other than `RESET`.

## Verification record

Exercised on 2026-09-17 against a local directory standing in for the host, with
an SSH stand-in that runs commands locally:

- `--dry-run` listed every component and left the directory unchanged;
- a real run placed every file with the modes above, removed an obsolete
  `migration/` file, replaced `cnr-editor/.env`, and left a hak, a TLK, a vault
  character, `cryptographic_secret`, `docker-compose-pdb.yml` and another module
  untouched;
- a second run transferred nothing;
- every refusal above, including a host without `rsync`, was triggered and
  stopped the script before any transfer; an empty MFA key only warned;
- with no `config/host/`, the script sent `config/nwserver.env` and
  `config/mysql.env`, and the host's
  `config/mysql.env` matched the local file byte for byte; an override in
  `config/host/` was sent in its place; with neither present it refused.

It has not yet been run against the real host.
