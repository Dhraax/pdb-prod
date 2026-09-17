#!/usr/bin/env bash
set -euo pipefail

# Start, stop or restart the NWN server of this stack.
#
# The control panel is a separate Compose project and is never touched. MySQL
# is started when the server needs it and never stopped here, because the panel
# depends on it too.

usage() {
    echo "Usage: $0 start|stop|restart|status" >&2
    exit 2
}

[[ $# -eq 1 ]] || usage

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir"

if [[ ! -f docker-compose.yml ]]; then
    echo "ERROR: no docker-compose.yml beside $0" >&2
    exit 1
fi
if ! docker compose version >/dev/null 2>&1; then
    echo "ERROR: Docker Compose v2 (docker compose) is required" >&2
    exit 1
fi

case "$1" in
    start)
        # pb-server waits for a healthy MySQL before it starts.
        docker compose up -d mysql pb-server
        ;;
    stop)
        docker compose stop --timeout 120 pb-server
        ;;
    restart)
        exec "$script_dir/server-restart.sh"
        ;;
    status)
        docker compose ps
        ;;
    *)
        usage
        ;;
esac
