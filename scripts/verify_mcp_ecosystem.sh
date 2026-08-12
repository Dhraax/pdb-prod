#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
source_lock="$repo_root/mcp/source-lock.json"
check_dir="$(mktemp -d)"

cleanup()
{
    rm -rf "$check_dir"
}
trap cleanup EXIT

read_lock()
{
    node -e 'process.stdout.write(String(process.argv[1].split(".").reduce((value, key) => value[key], JSON.parse(require("fs").readFileSync(process.argv[2], "utf8")))))' "$1" "$source_lock"
}

echo "Building and testing native NWScript MCP"
(
    cd "$repo_root/mcp/nwn-official-mcp"
    npm run check
)

echo "Building and testing NWNX MCP"
(
    cd "$repo_root/mcp/nwnx-mcp"
    npm run check
)

echo "Validating locked authoritative sources"
NWN_NWSCRIPT_EXPECTED_SHA256="$(read_lock nwnOfficial.sha256)" \
    node "$repo_root/mcp/nwn-official-mcp/dist/validate.js" \
    > "$check_dir/native-validation.json"
NWNX_EXPECTED_REVISION="$(read_lock nwnx.revision)" \
NWNX_EXPECTED_HEADER_SHA256="$(read_lock nwnx.headerSha256)" \
    node "$repo_root/mcp/nwnx-mcp/dist/validate.js" \
    > "$check_dir/nwnx-validation.json"
python3 "$script_dir/verify_mcp_lock.py" "$source_lock" \
    "$check_dir/native-validation.json" "$check_dir/nwnx-validation.json"

echo "Cross-checking NWNX extractors"
python3 "$script_dir/gen_api_docs.py" snapshot-nwnx \
    > "$check_dir/generated-nwnx.json"
node "$repo_root/mcp/nwnx-mcp/dist/snapshot.js" \
    > "$check_dir/mcp-nwnx.json"
python3 "$script_dir/compare_nwnx_api.py" \
    "$check_dir/generated-nwnx.json" "$check_dir/mcp-nwnx.json"

echo "Verifying generated dependency documentation"
python3 "$script_dir/gen_api_docs.py" verify

echo "Verifying client provisioning and production launchers"
python3 "$script_dir/verify_mcp_provisioning.py"
MCP_HEALTHCHECK=1 bash "$script_dir/run_nwn_official_mcp.sh"
MCP_HEALTHCHECK=1 bash "$script_dir/run_nwnx_mcp.sh"

echo "MCP ecosystem verification passed"
