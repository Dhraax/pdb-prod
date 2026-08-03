#!/bin/bash

echo "WARNING: 'Y' will delete all unsaved changes! Commit or stash them before continuing."

rm -f server/config/nwserver-dev.env
rm -f server/modules/PB_EE_PROD.mod


mkdir server/config
mkdir server/modules

cp modules/PB_EE_PROD.mod server/modules/PB_EE_PROD.mod
cp config/nwserver-dev.env server/config/nwserver-dev.env
cp config/grafana.env server/config/grafana.env
cp config/influxdb.env server/config/influxdb.env
cp -rf config/grafana-provisioning server/config/grafana-provisioning
cp docker-compose-dev.yml server/docker-compose.yml
rsync -av --inplace tlk/* server/tlk/

cd server
docker-compose down --remove-orphans
docker-compose up --no-recreate -d
