#!/bin/bash

echo "WARNING: 'Y' will delete all unsaved changes! Commit or stash them before continuing."

# Aviso si el .mod es mas viejo que algun .nss de src/: se desplegaria una
# build desfasada. Paso por el que ya se perdio una manana.
MOD="modules/PB_EE_PROD.mod"
if [ -f "$MOD" ]; then
  NUEVOS=$(find src -name "*.nss" -newer "$MOD" 2>/dev/null | wc -l)
  if [ "$NUEVOS" -gt 0 ]; then
    echo
    echo "  AVISO: $NUEVOS fichero(s) .nss en src/ son mas nuevos que $MOD."
    echo "  Vas a desplegar una build desfasada. Ejecuta antes:  ./linux_build.sh"
    echo
    read -r -p "  Continuar de todos modos? [s/N] " R
    [ "$R" = "s" ] || [ "$R" = "S" ] || exit 1
  fi
else
  echo "ERROR: no existe $MOD. Ejecuta primero ./linux_build.sh"
  exit 1
fi

rm -f server/config/nwserver.env
rm -f server/config/mysql.env
rm -f server/modules/PB_EE_PROD.mod


mkdir -p server/config
mkdir -p server/modules

cp modules/PB_EE_PROD.mod server/modules/PB_EE_PROD.mod
cp config/nwserver.env server/config/nwserver.env
cp config/grafana.env server/config/grafana.env
cp config/influxdb.env server/config/influxdb.env
cp config/mysql.env server/config/mysql.env
rsync -a --delete config/mysql-init/ server/config/mysql-init/
rsync -a --delete config/grafana-provisioning/ server/config/grafana-provisioning/
# El compose de produccion arranca con entrypoint /nwn/home/run-server.sh,
# y /nwn/home es este directorio server/. Sin esta copia el contenedor no
# encuentra su entrypoint y muere al crearse.
cp -p run-server.sh server/run-server.sh
chmod +x server/run-server.sh
cp docker-compose.yml server/docker-compose.yml
rsync -av --delete tlk/ server/tlk/

cd server
docker compose down --remove-orphans
docker compose up --no-recreate -d
