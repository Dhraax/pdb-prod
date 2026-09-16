#!/usr/bin/env bash
set -euo pipefail

repositoryRoot=$(git rev-parse --show-toplevel 2>/dev/null) || {
    echo "agent-audit: run this command from inside a Git repository" >&2
    exit 1
}

auditScript="$repositoryRoot/agents-config/scripts/agent_audit.sh"
[[ -x "$auditScript" ]] || {
    echo "agent-audit: submodule script is missing or not executable: $auditScript" >&2
    exit 1
}

exec "$auditScript" "$@"
