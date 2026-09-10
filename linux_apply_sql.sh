#!/bin/bash
# -----------------------------------------------------------------------------
#  Aplica un fichero .sql contra la base de datos del stack de desarrollo.
#
#  Uso:
#    ./linux_apply_sql.sh migration/01_schema.sql
#    ./linux_apply_sql.sh migration/*.sql
#
#  Lee las credenciales de config/mysql.env. El stack debe estar levantado.
# -----------------------------------------------------------------------------
set -eu

RAIZ="$(cd "$(dirname "$0")" && pwd)"
ENV="$RAIZ/server/config/mysql.env"
[ -f "$ENV" ] || ENV="$RAIZ/config/mysql.env"
[ -f "$ENV" ] || { echo "ERROR: no encuentro mysql.env"; exit 1; }
[ $# -gt 0 ] || { echo "Uso: $0 <fichero.sql> [...]"; exit 1; }

USER=$(grep '^MYSQL_USER='     "$ENV" | cut -d= -f2)
PASS=$(grep '^MYSQL_PASSWORD=' "$ENV" | cut -d= -f2)
DB=$(grep   '^MYSQL_DATABASE=' "$ENV" | cut -d= -f2)

cd "$RAIZ/server"
docker compose ps mysql --status running >/dev/null 2>&1 || {
    echo "ERROR: el contenedor mysql no esta corriendo."; exit 1; }

for f in "$@"; do
    ruta="$f"; [ -f "$ruta" ] || ruta="$RAIZ/$f"
    [ -f "$ruta" ] || { echo "  no existe: $f"; exit 1; }
    printf "  aplicando %-34s " "$(basename "$ruta")"
    if docker compose exec -T mysql mysql --default-character-set=utf8mb4 \
         -u"$USER" -p"$PASS" "$DB" < "$ruta" 2>/tmp/sqlerr; then
        echo "OK"
    else
        echo "FALLO"; grep -v "Using a password" /tmp/sqlerr | head -5; exit 1
    fi
done

echo
docker compose exec -T mysql mysql --default-character-set=utf8mb4 \
  -u"$USER" -p"$PASS" "$DB" -e "SHOW TABLES;" 2>/dev/null | grep -v Tables_in
