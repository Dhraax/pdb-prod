#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#  Daily backup of the running server: the MySQL database and the servervault,
#  in one compressed archive, followed by retention.
#
#  Meant for cron on the server host, at 06:00 server time:
#
#    0 6 * * * /home/baldurs/nwneeserver/server-backup.sh >> /home/baldurs/pdb-backups/cron.log 2>&1
#
#  Settings, all optional, from the environment:
#    STACK_DIR    Server stack directory: docker-compose.yml, servervault/.
#                 Default: the directory this script is in.
#    BACKUP_DIR   Where archives go. Default: $HOME/pdb-backups. Keep it out
#                 of the stack directory, so no deployment sync can delete it.
#    KEEP_MONTHS  Monthly archives kept; 0 keeps them all. Default: 0.
#
#  Retention, applied only after today's archive was written and verified:
#    - the last 7 days: every archive;
#    - 8 to 35 days old: the newest archive of each ISO week;
#    - older: the newest archive of each month.
#
#  Usage:
#    ./server-backup.sh               back up, then apply retention
#    ./server-backup.sh --prune-only  apply retention only (nothing is dumped)
#
#  Read-only against the database (mysqldump --single-transaction). The
#  archive is written under a temporary name and renamed once verified, so a
#  failed run never replaces nor prunes anything.
# -----------------------------------------------------------------------------
set -euo pipefail
umask 077
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:${PATH:-}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STACK_DIR="${STACK_DIR:-$script_dir}"
BACKUP_DIR="${BACKUP_DIR:-$HOME/pdb-backups}"
KEEP_MONTHS="${KEEP_MONTHS:-0}"
PREFIX="pdb-backup-"
SUFFIX=".tar.gz"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

fail() {
    log "ERROR: $*" >&2
    exit 1
}

prune() {
    local now_epoch name stamp day epoch age week month
    local -A newest_week=() newest_month=()
    local -a keep=() files=() months=()
    now_epoch="$(date +%s)"

    # Newest first, so the first file seen for a week or month is its newest.
    mapfile -t files < <(find "$BACKUP_DIR" -maxdepth 1 -type f \
        -name "${PREFIX}????-??-??_????${SUFFIX}" -printf '%f\n' | sort -r)

    for name in "${files[@]}"; do
        stamp="${name#"$PREFIX"}"
        stamp="${stamp%"$SUFFIX"}"
        day="${stamp%_*}"
        epoch="$(date -d "$day" +%s 2>/dev/null)" || continue
        age=$(( (now_epoch - epoch) / 86400 ))
        week="$(date -d "$day" +%G-%V)"
        month="${day:0:7}"

        if (( age <= 7 )); then
            keep+=("$name")
        elif (( age <= 35 )); then
            if [[ -z "${newest_week[$week]:-}" ]]; then
                newest_week[$week]="$name"
                keep+=("$name")
            fi
        elif [[ -z "${newest_month[$month]:-}" ]]; then
            newest_month[$month]="$name"
            months+=("$month")
            if (( KEEP_MONTHS == 0 || ${#months[@]} <= KEEP_MONTHS )); then
                keep+=("$name")
            fi
        fi
    done

    for name in "${files[@]}"; do
        if [[ " ${keep[*]} " != *" $name "* ]]; then
            rm -f -- "$BACKUP_DIR/$name" "$BACKUP_DIR/$name.sha256"
            log "Pruned $name"
        fi
    done
    log "Retention kept ${#keep[@]} archive(s) in $BACKUP_DIR"
}

[[ "$KEEP_MONTHS" =~ ^[0-9]+$ ]] || fail "KEEP_MONTHS must be a whole number"
mkdir -p "$BACKUP_DIR"
chmod 0700 "$BACKUP_DIR"

# One run at a time: a slow dump must not meet the next cron start.
exec 9>"$BACKUP_DIR/.server-backup.lock"
flock -n 9 || fail "another backup is still running"

if [[ "${1:-}" == "--prune-only" ]]; then
    prune
    exit 0
fi

[[ -f "$STACK_DIR/docker-compose.yml" ]] || fail "no docker-compose.yml in $STACK_DIR"
[[ -d "$STACK_DIR/servervault" ]] || fail "no servervault in $STACK_DIR"
for tool in docker gzip tar sha256sum flock; do
    command -v "$tool" >/dev/null 2>&1 || fail "$tool is required"
done
if docker compose version >/dev/null 2>&1; then
    compose=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
    compose=(docker-compose)
else
    fail "Docker Compose is not available"
fi

cd "$STACK_DIR"
[[ -n "$("${compose[@]}" ps -q --status running mysql)" ]] \
    || fail "the MySQL service of $STACK_DIR is not running"

name="${PREFIX}$(date +%Y-%m-%d_%H%M)${SUFFIX}"
work="$(mktemp -d "$BACKUP_DIR/.work.XXXXXX")"
partial="$BACKUP_DIR/.${name}.partial"
cleanup() {
    rm -rf -- "$work" "$partial"
}
trap cleanup EXIT

log "Dumping the database"
"${compose[@]}" exec -T mysql sh -c \
    'exec mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
        --single-transaction --routines --triggers --events --hex-blob \
        --set-gtid-purged=OFF --no-tablespaces "$MYSQL_DATABASE"' \
    2>"$work/mysqldump.err" | gzip -c > "$work/database.sql.gz"
if [[ -s "$work/mysqldump.err" ]] && grep -qv "Using a password" "$work/mysqldump.err"; then
    grep -v "Using a password" "$work/mysqldump.err" >&2
    fail "mysqldump reported errors"
fi
gzip -t "$work/database.sql.gz"
zcat "$work/database.sql.gz" | tail -n 1 | grep -q "Dump completed" \
    || fail "the database dump is incomplete"

log "Archiving the database and the servervault"
# Characters saved while the archive is written may change under tar; that is
# a warning (exit 1), not a failure. Anything above 1 is.
set +e
tar -czf "$partial" -C "$work" database.sql.gz -C "$STACK_DIR" servervault \
    --warning=no-file-changed
status=$?
set -e
(( status <= 1 )) || fail "tar failed with status $status"
tar -tzf "$partial" >/dev/null || fail "the archive does not read back"

mv -f -- "$partial" "$BACKUP_DIR/$name"
(cd "$BACKUP_DIR" && sha256sum "$name" > "$name.sha256")
log "Wrote $BACKUP_DIR/$name ($(du -h "$BACKUP_DIR/$name" | cut -f1))"

prune
