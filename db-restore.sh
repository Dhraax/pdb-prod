#!/usr/bin/env bash
set -euo pipefail

# Restore a db-backup.sh transfer package into an empty remote database.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
server_dir="$script_dir/dev-server"
transfer_dir="$server_dir/db-transfer"
archive_file="$transfer_dir/database.sql.gz"
checksum_file="$archive_file.sha256"
assume_yes=false

if [[ "${1:-}" == "--yes" ]]; then
    assume_yes=true
    shift
fi

if [[ $# -ne 0 ]]; then
    echo "Usage: $0 [--yes]" >&2
    exit 1
fi

if [[ ! -f "$server_dir/docker-compose.yml" ]]; then
    echo "ERROR: staged server Compose file is missing: $server_dir/docker-compose.yml" >&2
    exit 1
fi

if [[ ! -f "$archive_file" || ! -f "$checksum_file" ]]; then
    echo "ERROR: the database transfer package is incomplete in $transfer_dir." >&2
    exit 1
fi

if ! command -v gzip >/dev/null 2>&1 || ! command -v sha256sum >/dev/null 2>&1; then
    echo "ERROR: gzip and sha256sum are required." >&2
    exit 1
fi

if docker compose version >/dev/null 2>&1; then
    compose=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
    compose=(docker-compose)
else
    echo "ERROR: Docker Compose is not available." >&2
    exit 1
fi

cd "$transfer_dir"
sha256sum -c "$(basename "$checksum_file")"
gzip -t "$archive_file"

cd "$server_dir"
"${compose[@]}" up -d mysql

mysql_ready=false
for _ in {1..30}; do
    if "${compose[@]}" exec -T mysql sh -lc \
        'mysqladmin ping -h 127.0.0.1 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" --silent' \
        >/dev/null 2>&1; then
        mysql_ready=true
        break
    fi
    sleep 2
done

if [[ "$mysql_ready" != true ]]; then
    echo "ERROR: MySQL did not become ready within 60 seconds." >&2
    exit 1
fi

table_count="$("${compose[@]}" exec -T mysql sh -lc \
    'exec mysql -N -B -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" \
        -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE();"' \
    2>/dev/null | tr -d '\r')"

if [[ ! "$table_count" =~ ^[0-9]+$ ]]; then
    echo "ERROR: could not determine whether the target database is empty." >&2
    exit 1
fi

if [[ "$table_count" -ne 0 ]]; then
    echo "ERROR: restore refused because the target database contains $table_count table(s)." >&2
    echo "This script only restores into an empty database." >&2
    exit 1
fi

if [[ "$assume_yes" != true ]]; then
    echo "The target database is empty and will be restored from database.sql.gz."
    read -r -p "Type RESTORE to continue: " confirmation
    if [[ "$confirmation" != "RESTORE" ]]; then
        echo "Restore cancelled."
        exit 1
    fi
fi

echo "Restoring the database."
gzip -dc "$archive_file" \
    | "${compose[@]}" exec -T mysql sh -lc \
        'exec mysql --default-character-set=utf8mb4 \
            -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"'

restored_tables="$("${compose[@]}" exec -T mysql sh -lc \
    'exec mysql -N -B -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" \
        -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE();"' \
    2>/dev/null | tr -d '\r')"

restored_recipes="$("${compose[@]}" exec -T mysql sh -lc \
    'exec mysql -N -B -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" \
        -e "SELECT COUNT(*) FROM cnr_recipe;"' \
    2>/dev/null | tr -d '\r')"

if [[ ! "$restored_recipes" =~ ^[1-9][0-9]*$ ]]; then
    echo "ERROR: restore finished, but no readable CNR recipe catalogue was found." >&2
    exit 1
fi

echo "Database restore completed: $restored_tables table(s)."
echo "CNR recipes restored: $restored_recipes."
echo "Next: run ~/server-restart.sh and then ~/web-restart.sh."
