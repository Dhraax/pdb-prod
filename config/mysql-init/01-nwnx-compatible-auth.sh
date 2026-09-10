#!/bin/sh
# NWNX_SQL requiere mysql_native_password. MySQL 8.4 crea el usuario con
# caching_sha2_password, asi que lo cambiamos durante la inicializacion.
#
# Este script solo se ejecuta cuando /var/lib/mysql esta vacio.
set -eu

if [ -n "${MYSQL_USER:-}" ] && [ -n "${MYSQL_PASSWORD:-}" ]; then
  mysql --protocol=socket -uroot -p"${MYSQL_ROOT_PASSWORD}" <<SQL
ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';
FLUSH PRIVILEGES;
SQL
fi
