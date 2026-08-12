#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"

for mcp_name in nwn-official-mcp nwnx-mcp
do
    mcp_dir="$repo_root/mcp/$mcp_name"
    if [[ ! -f "$mcp_dir/package-lock.json" ]]; then
        echo "MCP submodule is missing or incomplete: $mcp_dir" >&2
        echo "Run: git submodule update --init --recursive" >&2
        exit 1
    fi
    echo "Installing locked dependencies for $mcp_name"
    (
        cd "$mcp_dir"
        npm ci
    )
done

bash "$script_dir/verify_mcp_ecosystem.sh"

echo "MCP provisioning complete. Restart MCP clients to reload registrations."
