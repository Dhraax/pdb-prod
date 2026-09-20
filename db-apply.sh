#!/usr/bin/env bash
set -euo pipefail
umask 077

# Apply the SQL migrations to a live database, in order, without touching
# player progress.
#
# The catalogue tables - professions, stations, materials, recipes and the
# arcane ones - are dropped and rebuilt from the repository, which is what
# makes a change here reach the server at all. The tables that hold what
# players own - pwdb_account, pwdb_character, cnr_tradeskill,
# cnr_character_setting - are created with IF NOT EXISTS and appear in no DROP
# and no DELETE.
#
# They used to be called disposable and they are not any more. Since
# 2026-09-20 the control panel is the live authority over the catalogue: a
# designer edits recipes and arcane properties there and nothing writes them
# back here. So rebuilding those tables rolls the design back to whatever the
# repository last generated and throws away every value tuned since.
#
# Seed a new database with this, or install a schema change with it. Do not run
# it against a live one people have been editing without knowing that is what
# you are doing. The dump it takes first is the way back.
#
# Because "should not" is not "did not", this counts the progress rows before
# and after and fails loudly if the number went down, and it always takes a
# dump first so there is something to go back to.
#
# Runs in both places, because the stack sits in a different directory in each:
# on the remote host it is dev-server/, next to where rsync.sh drops this
# script, and on the workstation it is server/. The migrations come from
# whichever copy is beside the stack, falling back to the repository's own.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ -f "$script_dir/docker-compose.yml" ]]; then
    server_dir="$script_dir"
elif [[ -f "$script_dir/dev-server/docker-compose.yml" ]]; then
    server_dir="$script_dir/dev-server"
elif [[ -f "$script_dir/server/docker-compose.yml" ]]; then
    server_dir="$script_dir/server"
else
    echo "ERROR: no stack found." >&2
    echo "  looked for $script_dir/docker-compose.yml" >&2
    echo "  and       $script_dir/dev-server/docker-compose.yml" >&2
    echo "  and       $script_dir/server/docker-compose.yml" >&2
    exit 1
fi

if [[ -d "$server_dir/migration" ]]; then
    migration_dir="$server_dir/migration"
else
    migration_dir="$script_dir/migration"
fi

# Its own directory, and not db-transfer/: rsync.sh mirrors that one with
# --delete-delay when it carries a package, which would wipe the safety dumps
# sitting on the remote host.
backup_dir="$server_dir/db-backups"
assume_yes=false

# Order matters: identity first, then the player state that points at it, then
# the catalogue that gets rebuilt, and the legacy drop last.
migrations=(
    "pwdb/01_identity_schema.sql"
    "cnr/00_player_state_schema.sql"
    "01_schema.sql"
    "02_seed.sql"
    "03_catalogue.sql"
    "05_arcane.sql"
    "04_drop_legacy.sql"
)

if [[ "${1:-}" == "--yes" ]]; then
    assume_yes=true
    shift
fi

if [[ $# -ne 0 ]]; then
    echo "Usage: $0 [--yes]" >&2
    exit 1
fi

if [[ ! -d "$migration_dir" ]]; then
    echo "ERROR: no migrations found in $migration_dir." >&2
    echo "On the remote host, run ./rsync.sh from the workstation first." >&2
    exit 1
fi

missing=false
for name in "${migrations[@]}"; do
    if [[ ! -f "$migration_dir/$name" ]]; then
        echo "ERROR: missing migration: $name" >&2
        missing=true
    fi
done
if [[ "$missing" == true ]]; then
    exit 1
fi

if ! command -v gzip >/dev/null 2>&1; then
    echo "ERROR: gzip is required." >&2
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

# Counts a table, answering 0 when the table does not exist yet: on a database
# that has never seen these migrations that is the honest answer, not an error.
#
# Existence is asked first and in its own query. Folding both into one with
# IF() does not work: MySQL resolves the table named in the branch it is not
# going to take, so a missing table fails the whole statement.
#
# The table names are constants written above, never input.
mysql_scalar() {
    "${compose[@]}" exec -T mysql sh -lc \
        "exec mysql -N -B -u\"\$MYSQL_USER\" -p\"\$MYSQL_PASSWORD\" \"\$MYSQL_DATABASE\" -e \"$1\"" \
        2>/dev/null | tr -d '\r'
}

count_rows() {
    local table="$1"
    local exists
    exists="$(mysql_scalar "SELECT COUNT(*) FROM information_schema.tables \
        WHERE table_schema = DATABASE() AND table_name = '$table';")"

    if [[ "$exists" != "1" ]]; then
        echo 0
        return
    fi

    mysql_scalar "SELECT COUNT(*) FROM $table;"
}

skills_before="$(count_rows cnr_tradeskill)"
settings_before="$(count_rows cnr_character_setting)"
characters_before="$(count_rows pwdb_character)"

for value in "$skills_before" "$settings_before" "$characters_before"; do
    if [[ ! "$value" =~ ^[0-9]+$ ]]; then
        echo "ERROR: could not read the current player progress counts." >&2
        exit 1
    fi
done

echo "Stack:      $server_dir"
echo "Migrations: $migration_dir"
echo
echo "Player progress before applying:"
echo "  characters:        $characters_before"
echo "  tradeskill rows:   $skills_before"
echo "  character settings:$settings_before"
echo
echo "The catalogue tables will be dropped and rebuilt from:"
for name in "${migrations[@]}"; do
    echo "  $name"
done
echo

if [[ "$assume_yes" != true ]]; then
    read -r -p "Type APPLY to continue: " confirmation
    if [[ "$confirmation" != "APPLY" ]]; then
        echo "Nothing was applied."
        exit 1
    fi
fi

mkdir -p "$backup_dir"
chmod 0700 "$backup_dir"
safety_file="$backup_dir/pre-apply-$(date +%Y%m%d-%H%M%S).sql.gz"

echo "Taking a safety dump first: $(basename "$safety_file")"
"${compose[@]}" exec -T mysql sh -lc \
    'exec mysqldump -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" \
        --single-transaction --routines --triggers --events --hex-blob \
        --set-gtid-purged=OFF --no-tablespaces "$MYSQL_DATABASE"' \
    | gzip -c > "$safety_file"
gzip -t "$safety_file"
chmod 0600 "$safety_file"

echo
for name in "${migrations[@]}"; do
    printf "  applying %-34s " "$name"
    if "${compose[@]}" exec -T mysql sh -lc \
        'exec mysql --default-character-set=utf8mb4 \
            -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE"' \
        < "$migration_dir/$name" 2>/tmp/db-apply-error; then
        echo "OK"
    else
        echo "FAILED"
        grep -v "Using a password" /tmp/db-apply-error | head -5 >&2
        echo >&2
        echo "The database is half-applied. Restore from $safety_file" >&2
        echo "before starting the server." >&2
        exit 1
    fi
done

skills_after="$(count_rows cnr_tradeskill)"
settings_after="$(count_rows cnr_character_setting)"
characters_after="$(count_rows pwdb_character)"

if [[ "$skills_after" -lt "$skills_before" \
   || "$settings_after" -lt "$settings_before" \
   || "$characters_after" -lt "$characters_before" ]]; then
    echo "ERROR: player progress shrank during the migration." >&2
    echo "  characters:         $characters_before -> $characters_after" >&2
    echo "  tradeskill rows:    $skills_before -> $skills_after" >&2
    echo "  character settings: $settings_before -> $settings_after" >&2
    echo "Restore from $safety_file." >&2
    exit 1
fi

recipes="$(count_rows cnr_recipe)"
properties="$(count_rows cnr_arcane_property)"
steps="$(count_rows cnr_arcane_step)"

if [[ ! "$recipes" =~ ^[1-9][0-9]*$ ]]; then
    echo "ERROR: the migrations left no readable CNR recipe catalogue." >&2
    echo "Restore from $safety_file." >&2
    exit 1
fi

echo
echo "Catalogue rebuilt:"
echo "  recipes:            $recipes"
echo "  arcane properties:  $properties"
echo "  arcane steps:       $steps"
echo "Player progress kept:"
echo "  characters:         $characters_after"
echo "  tradeskill rows:    $skills_after"
echo "  character settings: $settings_after"
echo
echo "Safety dump: $safety_file"
echo "Next: restart the server so it reads the new catalogue."
