#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
editor_dir="$script_dir/cnr-editor"

if [[ ! -f "$editor_dir/compose.yml" || ! -f "$editor_dir/.env" ]]; then
    echo "ERROR: the staged CNR editor or its remote configuration is missing." >&2
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

cd "$editor_dir"

echo "Restarting the CNR catalogue editor."
"${compose[@]}" --env-file .env -f compose.yml down --remove-orphans
"${compose[@]}" --env-file .env -f compose.yml up -d --build --force-recreate
