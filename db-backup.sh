#!/usr/bin/env bash
set -euo pipefail
umask 077

# Create the private database transfer package consumed by db-restore.sh.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
server_dir="$script_dir/server"
compose_file="$server_dir/docker-compose.yml"
transfer_dir="$server_dir/db-transfer"
archive_file="$transfer_dir/database.sql.gz"
checksum_file="$archive_file.sha256"

if [[ ! -f "$compose_file" ]]; then
    echo "ERROR: staged server Compose file is missing: $compose_file" >&2
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

cd "$server_dir"

if [[ -z "$("${compose[@]}" ps -q --status running mysql)" ]]; then
    echo "ERROR: the staged MySQL service is not running." >&2
    exit 1
fi

recipe_count="$("${compose[@]}" exec -T mysql sh -lc \
    'exec mysql -N -B -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" \
        -e "SELECT COUNT(*) FROM cnr_recipe;"' \
    2>/dev/null | tr -d '\r')"

if [[ ! "$recipe_count" =~ ^[1-9][0-9]*$ ]]; then
    echo "ERROR: the source database has no readable CNR recipe catalogue." >&2
    exit 1
fi

mkdir -p "$transfer_dir"
chmod 0700 "$transfer_dir"
temporary_archive="$(mktemp "$transfer_dir/.database.sql.gz.XXXXXX")"
temporary_checksum="$(mktemp "$transfer_dir/.database.sql.gz.sha256.XXXXXX")"

cleanup() {
    rm -f -- "$temporary_archive" "$temporary_checksum"
}
trap cleanup EXIT

echo "Creating a consistent logical database backup."
"${compose[@]}" exec -T mysql sh -lc \
    'exec mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
        --single-transaction --routines --triggers --events --hex-blob \
        --set-gtid-purged=OFF --no-tablespaces "$MYSQL_DATABASE"' \
    | gzip -c > "$temporary_archive"

gzip -t "$temporary_archive"
chmod 0600 "$temporary_archive"
mv -f -- "$temporary_archive" "$archive_file"

(
    cd "$transfer_dir"
    sha256sum "$(basename "$archive_file")"
) > "$temporary_checksum"
chmod 0600 "$temporary_checksum"
mv -f -- "$temporary_checksum" "$checksum_file"

trap - EXIT

echo "Database transfer package ready:"
echo "  $archive_file"
echo "  $checksum_file"
echo "  CNR recipes captured: $recipe_count"
echo "Run ./rsync.sh to send it to the remote development host."
