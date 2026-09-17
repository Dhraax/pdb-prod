#!/usr/bin/env bash
set -euo pipefail
umask 077

# Empty the player data out of a live database, keeping the CNR catalogue and
# the control panel's system users.
#
# Meant for the end of a test phase. What testers created goes: accounts,
# characters, CD-key, name and IP history, CD-key resets and bans, CNR progress
# and settings, level unlocks, character profiles and classes, and the identity
# audit. What stays: the CNR catalogue and its revision history, the panel users
# with their permissions, MFA and audit, the DM CD-key whitelist, the class
# definitions and the Alembic version.
#
# Every table in the database must appear in exactly one of the two lists
# below. An unlisted table stops the script before anything happens: a new
# table is either player data that would silently survive a reset or system
# data that must not be touched, and that decision belongs in this file.
#
# The NWN server must be stopped, because a running module holds character ids
# this removes. A full dump is taken first. servervault/ and the NWN database/
# directory are files, not MySQL, and are not touched.

fail() {
    echo "ERROR: $*" >&2
    exit 1
}

if [[ $# -ne 0 ]]; then
    echo "Usage: $0" >&2
    exit 2
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Beside the Compose file on the host; the staged server/ on the workstation.
if [[ -f "$script_dir/docker-compose.yml" ]]; then
    server_dir="$script_dir"
elif [[ -f "$script_dir/server/docker-compose.yml" ]]; then
    server_dir="$script_dir/server"
else
    fail "no docker-compose.yml beside this script or under server/"
fi
backup_dir="$server_dir/db-backups"

# Deleted children first, so no foreign key is ever violated.
wipe_tables=(
    cnr_tradeskill
    cnr_character_setting
    pwdb_character_level_unlock
    pwdb_character_profile
    pwdb_character_class
    pwdb_character
    pwdb_account_cd_key_history
    pwdb_account_cdkey_reset
    pwdb_account_ip_history
    pwdb_account_management
    pwdb_account_name_history
    pwdb_account
    pwdb_cd_key_ban
    pwdb_identity_revision
)

keep_tables=(
    alembic_version
    cnr_profession
    cnr_station
    cnr_station_tool
    cnr_category
    cnr_material
    cnr_recipe
    cnr_recipe_component
    cnr_recipe_property
    cnr_variant
    cnr_arcane_group
    cnr_arcane_group_base
    cnr_arcane_property
    cnr_arcane_step
    cnr_catalogue_revision
    cnr_editor_user
    cnr_editor_user_revision
    cnr_editor_profession_permission
    cnr_editor_system_permission
    cnr_editor_totp_credential
    cnr_editor_mfa_recovery_code
    cnr_editor_session
    cnr_editor_mfa_challenge
    cnr_editor_login_throttle
    pwdb_class_definition
    pwdb_dm_cd_key_whitelist
    pwdb_dm_cd_key_whitelist_revision
)

# Kept, but written by the panel while it is in use, so not compared afterwards.
volatile_tables=(
    cnr_editor_session
    cnr_editor_mfa_challenge
    cnr_editor_login_throttle
)

in_list() {
    local needle="$1" item
    shift
    for item in "$@"; do
        [[ "$item" == "$needle" ]] && return 0
    done
    return 1
}

docker compose version >/dev/null 2>&1 \
    || fail "Docker Compose v2 (docker compose) is required"
command -v gzip >/dev/null 2>&1 || fail "gzip is required"

cd "$server_dir"

[[ -n "$(docker compose ps -q --status running mysql </dev/null)" ]] \
    || fail "MySQL is not running; start it with: docker compose up -d mysql"
[[ -z "$(docker compose ps -q --status running pb-server </dev/null)" ]] \
    || fail "the NWN server is running; stop it first with: docker compose stop pb-server"

error_file="$(mktemp)"
trap 'rm -f "$error_file"' EXIT

# SQL arrives on stdin. Credentials stay inside the container's environment.
mysql_run() {
    docker compose exec -T mysql sh -c \
        'MYSQL_PWD="$MYSQL_PASSWORD" exec mysql --default-character-set=utf8mb4 -N -B -u"$MYSQL_USER" "$MYSQL_DATABASE"' \
        2>"$error_file" | tr -d '\r'
}

show_mysql_error() {
    grep -v "Using a password" "$error_file" | head -5 >&2 || true
}

mapfile -t db_tables < <(
    echo "SELECT table_name FROM information_schema.tables WHERE table_schema = DATABASE() AND table_type = 'BASE TABLE' ORDER BY table_name;" \
        | mysql_run
)
if [[ ${#db_tables[@]} -eq 0 ]]; then
    show_mysql_error
    fail "could not list the tables of the database"
fi

unknown=()
for table in "${db_tables[@]}"; do
    in_list "$table" "${wipe_tables[@]}" || in_list "$table" "${keep_tables[@]}" || unknown+=("$table")
done
if [[ ${#unknown[@]} -gt 0 ]]; then
    echo "ERROR: these tables are in neither list of $0:" >&2
    printf '  %s\n' "${unknown[@]}" >&2
    echo "Decide whether each one is player data or system data and add it." >&2
    exit 1
fi

in_list cnr_recipe "${db_tables[@]}" || fail "no cnr_recipe table: this is not the PDB database"

present_wipe=()
for table in "${wipe_tables[@]}"; do
    in_list "$table" "${db_tables[@]}" && present_wipe+=("$table")
done
present_keep=()
for table in "${keep_tables[@]}"; do
    in_list "$table" "${db_tables[@]}" && present_keep+=("$table")
done

# Exact counts, one query. Table names come from the lists above, never input.
count_tables() {
    local sql="" table
    for table in "$@"; do
        sql+="${sql:+ UNION ALL }SELECT '$table', COUNT(*) FROM \`$table\`"
    done
    echo "$sql;" | mysql_run
}

declare -A before=()
while read -r table rows; do
    [[ -n "$table" ]] && before["$table"]="$rows"
done < <(count_tables "${present_wipe[@]}" "${present_keep[@]}")

for table in "${present_wipe[@]}" "${present_keep[@]}"; do
    if [[ ! "${before[$table]:-}" =~ ^[0-9]+$ ]]; then
        show_mysql_error
        fail "could not count $table"
    fi
done

echo "Stack: $server_dir"
echo
echo "Deleted (player data):"
for table in "${present_wipe[@]}"; do
    printf '  %-36s %s\n' "$table" "${before[$table]}"
done
echo
echo "Kept:"
printf '  %-36s %s\n' "recipes" "${before[cnr_recipe]}"
printf '  %-36s %s\n' "control panel users" "${before[cnr_editor_user]:-0}"
printf '  %-36s %s\n' "DM CD-key whitelist" "${before[pwdb_dm_cd_key_whitelist]:-0}"
echo "  and the rest of the catalogue, panel permissions, MFA and audit"
echo
echo "servervault/ and the NWN database/ directory are not touched."
echo

read -r -p "Type RESET to delete the player data: " confirmation
[[ "$confirmation" == "RESET" ]] || { echo "Nothing was deleted."; exit 1; }

mkdir -p "$backup_dir"
chmod 0700 "$backup_dir"
safety_file="$backup_dir/pre-reset-$(date +%Y%m%d-%H%M%S).sql.gz"

echo "Taking a safety dump first: $safety_file"
docker compose exec -T mysql sh -c \
    'MYSQL_PWD="$MYSQL_PASSWORD" exec mysqldump -u"$MYSQL_USER" \
        --single-transaction --routines --triggers --events --hex-blob \
        --set-gtid-purged=OFF --no-tablespaces "$MYSQL_DATABASE"' \
    </dev/null 2>"$error_file" | gzip -c > "$safety_file"
if ! gzip -t "$safety_file" || ! zgrep -q "CREATE TABLE \`cnr_recipe\`" "$safety_file"; then
    show_mysql_error
    fail "the safety dump is incomplete; nothing was deleted"
fi
chmod 0600 "$safety_file"

# One transaction: either every player row goes or none does.
delete_sql="START TRANSACTION;"
for table in "${present_wipe[@]}"; do
    delete_sql+=$'\n'"DELETE FROM \`$table\`;"
done
delete_sql+=$'\n'"COMMIT;"

if ! echo "$delete_sql" | mysql_run >/dev/null; then
    show_mysql_error
    fail "the delete failed and was rolled back; the database is unchanged"
fi

# New accounts and characters start again from 1.
mapfile -t auto_tables < <(
    echo "SELECT table_name FROM information_schema.columns WHERE table_schema = DATABASE() AND extra LIKE '%auto_increment%';" \
        | mysql_run
)
alter_sql=""
for table in "${present_wipe[@]}"; do
    in_list "$table" "${auto_tables[@]}" && alter_sql+="ALTER TABLE \`$table\` AUTO_INCREMENT = 1;"$'\n'
done
if [[ -n "$alter_sql" ]] && ! echo "$alter_sql" | mysql_run >/dev/null; then
    show_mysql_error
    echo "WARNING: the player rows are gone, but the id counters were not reset." >&2
fi

declare -A after=()
while read -r table rows; do
    [[ -n "$table" ]] && after["$table"]="$rows"
done < <(count_tables "${present_wipe[@]}" "${present_keep[@]}")

problems=()
for table in "${present_wipe[@]}"; do
    [[ "${after[$table]:-}" == "0" ]] || problems+=("$table still has ${after[$table]:-?} rows")
done
for table in "${present_keep[@]}"; do
    in_list "$table" "${volatile_tables[@]}" && continue
    [[ "${after[$table]:-}" == "${before[$table]}" ]] \
        || problems+=("$table changed from ${before[$table]} to ${after[$table]:-?} rows")
done

if [[ ${#problems[@]} -gt 0 ]]; then
    echo "ERROR: the reset did not end as expected:" >&2
    printf '  %s\n' "${problems[@]}" >&2
    echo "Restore from $safety_file before starting the server." >&2
    exit 1
fi

echo
echo "Player data deleted. Catalogue and panel users unchanged."
echo "Safety dump: $safety_file"
echo "Start the server again with: docker compose up -d pb-server"
