#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_ROOT"

for required_path in \
    docker-compose.yml \
    run-server.sh \
    config/nwserver.env \
    config/mysql.env \
    "modules/Puerta de Baldur 5E.mod"
do
    if [ ! -e "$required_path" ]; then
        echo "ERROR: required production file is missing: $required_path" >&2
        exit 1
    fi
done

if [ ! -x run-server.sh ]; then
    echo "ERROR: run-server.sh is not executable." >&2
    exit 1
fi

mkdir -p logs

echo "[*] Validating production Compose configuration"
docker compose -f docker-compose.yml config --quiet

echo "[*] Ensuring persistent dependencies are running"
docker compose -f docker-compose.yml up -d mysql influxdb grafana

echo "[*] Stopping the NWN server gracefully"
docker compose -f docker-compose.yml stop --timeout 120 pb-server

echo "[*] Recreating the NWN server"
docker compose -f docker-compose.yml up -d --force-recreate pb-server

echo "[*] NWN server restarted; MySQL and the control-panel network were preserved"
docker compose -f docker-compose.yml ps
