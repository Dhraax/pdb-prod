#!/usr/bin/env bash
# Move the persistent data from the old pdb_dev database to pdb_prod, which is
# what config/mysql.env now names. Nothing is dropped: pdb_dev stays untouched
# as the fallback until you delete it by hand.
#
# The MySQL container has to be running. Credentials come from config/mysql.env,
# and the root password used is the one the container was started with, not
# necessarily the one in that file: an already-initialised volume ignores
# MYSQL_ROOT_PASSWORD, so the script reads it from the container's environment.
set -euo pipefail

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
env_file="$repository_root/config/mysql.env"
container=nwnee_baldur_mysql
source_database=pdb_dev

[[ -f "$env_file" ]] || { echo "missing $env_file" >&2; exit 1; }
docker inspect "$container" >/dev/null 2>&1 || {
    echo "the container $container is not running; start the stack first" >&2
    exit 1
}

target_database=$(sed -n 's/^MYSQL_DATABASE=//p' "$env_file")
target_user=$(sed -n 's/^MYSQL_USER=//p' "$env_file")
target_password=$(sed -n 's/^MYSQL_PASSWORD=//p' "$env_file")
[[ -n "$target_database" && -n "$target_user" && -n "$target_password" ]] \
    || { echo "config/mysql.env is missing database, user or password" >&2; exit 1; }

echo "source: $source_database"
echo "target: $target_database (user $target_user)"
read -r -p "Type PROMOTE to continue: " answer
[[ "$answer" == "PROMOTE" ]] || { echo "aborted"; exit 1; }

# NWNX_SQL still needs mysql_native_password; MySQL 8.4 defaults to sha2.
docker exec -i "$container" sh -lc '
    set -eu
    mysql -u root -p"$MYSQL_ROOT_PASSWORD" <<SQL
CREATE DATABASE IF NOT EXISTS `'"$target_database"'`
    CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS '"'$target_user'"'@'"'%'"'
    IDENTIFIED WITH mysql_native_password BY '"'$target_password'"';
ALTER USER '"'$target_user'"'@'"'%'"'
    IDENTIFIED WITH mysql_native_password BY '"'$target_password'"';
GRANT ALL PRIVILEGES ON `'"$target_database"'`.* TO '"'$target_user'"'@'"'%'"';
FLUSH PRIVILEGES;
SQL'

echo "copying the data"
docker exec -i "$container" sh -lc '
    set -eu
    mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" --single-transaction --routines \
        --events --triggers '"$source_database"' \
    | mysql -u root -p"$MYSQL_ROOT_PASSWORD" '"$target_database"

echo
echo "row counts, source then target:"
docker exec -i "$container" sh -lc '
    for db in '"$source_database $target_database"'; do
        printf "  %-10s " "$db"
        mysql -u root -p"$MYSQL_ROOT_PASSWORD" -N -e \
            "SELECT CONCAT(\"characters=\", (SELECT COUNT(*) FROM pwdb_character),
                    \" tradeskill=\", (SELECT COUNT(*) FROM cnr_tradeskill),
                    \" recipes=\", (SELECT COUNT(*) FROM cnr_recipe));" "$db" 2>/dev/null \
            || echo "(tables missing)"
    done'

echo
echo "done. $source_database is left in place; drop it by hand once you trust the copy."
