#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
mcp_dir="$repo_root/mcp/nwnx-mcp"
entry_point="$mcp_dir/dist/main.js"
required_version="$(tr -d '[:space:]' < "$mcp_dir/.nvmrc")"

node_major=0
if command -v node >/dev/null 2>&1; then
    node_major="$(node -p 'Number(process.versions.node.split(".")[0])')"
fi

if (( node_major < 20 )); then
    nvm_script="${NVM_DIR:-$HOME/.nvm}/nvm.sh"
    if [[ ! -s "$nvm_script" ]]; then
        echo "Node.js 20+ not found and nvm is unavailable." >&2
        exit 1
    fi
    # shellcheck source=/dev/null
    source "$nvm_script"
    nvm use "$required_version" >/dev/null
fi

if [[ ! -f "$entry_point" ]]; then
    echo "MCP build missing: $entry_point" >&2
    echo "Run: cd mcp/nwnx-mcp && npm ci && npm run build" >&2
    exit 1
fi

source_lock="$repo_root/mcp/source-lock.json"
if [[ "${MCP_SKIP_SOURCE_LOCK:-0}" != "1" ]]; then
    if [[ ! -f "$source_lock" ]]; then
        echo "MCP source lock missing: $source_lock" >&2
        exit 1
    fi
    export NWNX_EXPECTED_REVISION="${NWNX_EXPECTED_REVISION:-$(
        node -e 'process.stdout.write(JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).nwnx.revision)' "$source_lock"
    )}"
    export NWNX_EXPECTED_HEADER_SHA256="${NWNX_EXPECTED_HEADER_SHA256:-$(
        node -e 'process.stdout.write(JSON.parse(require("fs").readFileSync(process.argv[1], "utf8")).nwnx.headerSha256)' "$source_lock"
    )}"
fi

export NWNX_ROOT="${NWNX_ROOT:-$repo_root/nwnxee}"
cd "$repo_root"
exec node "$entry_point"
