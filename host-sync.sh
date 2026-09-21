#!/usr/bin/env bash
set -euo pipefail

# Send the production periphery to the host's server directory.
#
# That directory is the host's equivalent of server/: it already holds the haks,
# TLK, server vault, NWN database and the rest of the persistent runtime, and
# this script never lists, overwrites or deletes any of it. It sends only what
# this repository owns:
#
#   docker-compose.yml, run-server.sh and the host helper scripts
#   migration/, read by db-apply.sh
#   cnr-editor/ and its cnr-editor/.env
#   modules/Puerta de Baldur 5E.mod
#
# It does NOT send config/. The host's credentials are established there and
# are its own: nwserver.env, mysql.env and mysql-init/ belong to the host and
# this repository's copies are the local stack's. Sending ours would overwrite
# working credentials with the ones that happen to be in this checkout, which
# is how a host ends up locked out of its own database. Change something on the
# host's environment and you edit it on the host.
#
# It starts, stops and migrates nothing.
# See documentation/repository/host-sync.md.

usage() {
    cat >&2 <<'USAGE'
Usage: ./host-sync.sh [--dry-run] [--yes] <user@host>

  --dry-run   List what would change on the host; transfer and create nothing.
  --yes       Do not ask for confirmation.

Environment:
  PDB_REMOTE_DIR  Server directory on the host (default /home/baldurs/nwneeserver)
  PDB_SSH         SSH command and options (default "ssh"), e.g. "ssh -p 2222"
USAGE
    exit 2
}

fail() {
    echo "ERROR: $*" >&2
    exit 1
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
module_name="Puerta de Baldur 5E"
module_file="modules/$module_name.mod"
remote_dir="${PDB_REMOTE_DIR:-/home/baldurs/nwneeserver}"
ssh_base="${PDB_SSH:-ssh}"

dry_run=false
assume_yes=false
target=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--dry-run) dry_run=true ;;
        -y|--yes) assume_yes=true ;;
        -h|--help) usage ;;
        -*) echo "ERROR: unknown option: $1" >&2; usage ;;
        *)
            [[ -z "$target" ]] || usage
            target="$1"
            ;;
    esac
    shift
done

[[ -n "$target" ]] || usage

case "$remote_dir" in
    /*) ;;
    *) fail "PDB_REMOTE_DIR must be an absolute path: $remote_dir" ;;
esac
remote_dir="${remote_dir%/}"
[[ -n "$remote_dir" ]] || fail "PDB_REMOTE_DIR cannot be /"

cd "$repo_root"

# ---------------------------------------------------------------------------
# Local checks. Environment values are compared, never printed.
# ---------------------------------------------------------------------------

# nwn_nwsync_write is not sent: the host keeps its own NWSync tools beside
# nwsync.sh, which calls whatever binary sits in its directory.
stack_scripts=(run-server.sh server.sh server-restart.sh web-restart.sh db-apply.sh db-reset-players.sh nwsync.sh)

for path in docker-compose.yml "${stack_scripts[@]}" "$module_file" cnr-editor/compose.yml; do
    [[ -f "$path" ]] || fail "required file is missing: $path"
done
for path in migration cnr-editor/backend cnr-editor/frontend; do
    [[ -d "$path" ]] || fail "required directory is missing: $path"
done

# The host's own nwserver.env and mysql.env are not sent and not read here, so
# nothing in this script can vouch for them. The module name, NWNX_SQL_SKIP and
# the database credentials the host runs with are the host's to get right.
#
# The panel's .env is still sent, because it is not credentials: it points the
# panel at the host's own config/mysql.env, names the Compose network and binds
# the port to the loopback. config/host/cnr-editor.env overrides it.
host_panel_env="config/host/cnr-editor.env"
[[ -f "$host_panel_env" ]] || host_panel_env="cnr-editor/host.env.example"

# Raw value of a key as Compose's env-file reader finds it: the last assignment
# wins, an "export " prefix and blanks around "=" are ignored, and an unquoted
# value ends before " #". Quotes are kept, so read_plain can refuse them.
env_value() {
    sed -n -E "s/^[[:space:]]*(export[[:space:]]+)?$2[[:space:]]*=//p" "$1" \
        | tail -n 1 \
        | tr -d '\r' \
        | sed -E 's/[[:space:]]+#.*$//; s/^[[:space:]]+//; s/[[:space:]]+$//'
}

# Sets $value to a key the script vouches for. Quoted and interpolated forms are
# refused rather than interpreted, so the value checked is the value Compose
# will pass on. Runs in this shell, not a subshell, so fail stops the script.
read_plain() {
    value="$(env_value "$1" "$2")"
    case "$value" in
        \"*|\'*) fail "$2 in $1 is quoted; write it without quotes so it can be checked as Compose reads it" ;;
        *'$'*) fail "$2 in $1 contains \$, which Compose interpolates; use a value without it" ;;
    esac
}

require_equal() {
    read_plain "$1" "$2"
    [[ "$value" == "$3" ]] || fail "$2 in $1 must be $3${4:+: $4}"
}

require_equal "$host_panel_env" CNR_EDITOR_MYSQL_ENV_FILE ../config/mysql.env
require_equal "$host_panel_env" CNR_EDITOR_NETWORK_NAME server_default
read_plain "$host_panel_env" CNR_EDITOR_PORT
[[ "$value" == 127.0.0.1:* ]] \
    || fail "CNR_EDITOR_PORT in $host_panel_env must be bound to 127.0.0.1; the panel is never published directly"
unset value

stale_count="$(find src -name '*.nss' -newer "$module_file" 2>/dev/null | wc -l)"
if (( stale_count > 0 )); then
    echo "WARNING: $stale_count .nss file(s) in src/ are newer than $module_file." >&2
    if $assume_yes && ! $dry_run; then
        fail "refusing to send a possibly stale module with --yes; run ./linux_build.sh first"
    fi
    if ! $dry_run; then
        read -r -p "Send this module anyway? [y/N] " answer
        [[ "$answer" == "y" || "$answer" == "Y" ]] || exit 1
    fi
fi

# ---------------------------------------------------------------------------
# Remote checks, over one shared SSH connection.
# ---------------------------------------------------------------------------

control_dir="$(mktemp -d /tmp/pdb-host-sync.XXXXXX)"
ssh_cmd="$ssh_base -o ControlMaster=auto -o ControlPath=$control_dir/%C -o ControlPersist=120"

cleanup() {
    $ssh_cmd -O exit "$target" >/dev/null 2>&1 || true
    rm -rf "$control_dir"
}
trap cleanup EXIT

remote() {
    $ssh_cmd "$target" "$@"
}

q_remote_dir="$(printf '%q' "$remote_dir")"
remote_dirs="modules migration cnr-editor"

echo "[*] Checking $target:$remote_dir"
probe="$(remote "command -v rsync >/dev/null 2>&1 || { echo NO_RSYNC; exit 0; }
[ -d $q_remote_dir ] || { echo NO_DIR; exit 0; }
cd $q_remote_dir || exit 1
[ -d hak ] || [ -d modules ] || [ -d servervault ] || { echo NOT_SERVER_DIR; exit 0; }
for d in $remote_dirs; do [ -d \"\$d\" ] || echo \"missing:\$d\"; done")"

case "$probe" in
    *NO_RSYNC*) fail "rsync is not installed on $target" ;;
    *NO_DIR*) fail "$remote_dir does not exist on $target" ;;
    *NOT_SERVER_DIR*) fail "$remote_dir on $target has no hak/, modules/ or servervault/; it is not the server directory" ;;
esac

missing_dirs=()
while IFS= read -r line; do
    [[ "$line" == missing:* ]] && missing_dirs+=("${line#missing:}")
done <<< "$probe"

is_missing() {
    local dir
    for dir in "${missing_dirs[@]}"; do
        [[ "$dir" == "$1" ]] && return 0
    done
    return 1
}

echo
echo "Target: $target:$remote_dir"
echo "Sends:  docker-compose.yml, ${stack_scripts[*]}"
echo "        migration/, cnr-editor/"
echo "        cnr-editor/.env     <- $host_panel_env"
echo "        $module_file"
echo "Keeps:  config/, hak, tlk, servervault, database, logs and everything else"
echo "        already there. The host's credentials are its own."
if (( ${#missing_dirs[@]} > 0 )); then
    echo "New:    ${missing_dirs[*]}"
fi
echo

if $dry_run; then
    echo "Dry run: nothing is transferred or created."
elif ! $assume_yes; then
    read -r -p "Type SYNC to continue: " confirmation
    [[ "$confirmation" == "SYNC" ]] || { echo "Aborted."; exit 1; }
fi

if ! $dry_run && (( ${#missing_dirs[@]} > 0 )); then
    remote "cd $q_remote_dir && mkdir -p ${missing_dirs[*]}"
fi

# ---------------------------------------------------------------------------
# Transfer.
# ---------------------------------------------------------------------------

rsync_base=(rsync -rltp --protect-args --itemize-changes -e "$ssh_cmd")
$dry_run && rsync_base+=(--dry-run)

# sync_component <label> <remote directory that must exist | -> <remote destination> <rsync arguments...>
sync_component() {
    local label="$1" needs="$2" destination="$3"
    shift 3
    echo "[*] $label"
    if $dry_run && [[ "$needs" != "-" ]] && is_missing "$needs"; then
        echo "    $needs/ does not exist on the host yet: all of it would be new"
        return 0
    fi
    "${rsync_base[@]}" "$@" "$target:$remote_dir/$destination"
}

sync_component "Compose file" - "" \
    --chmod=F644 docker-compose.yml

sync_component "Server entrypoint and host scripts" - "" \
    --chmod=F755 "${stack_scripts[@]}"

sync_component "SQL migrations" - "migration/" \
    --delete-delay --chmod=D755,F644 \
    --exclude '__pycache__/' --exclude '*.py[cod]' \
    migration/

sync_component "Control panel source" - "cnr-editor/" \
    --delete-delay --chmod=D755,F644 \
    --exclude '/*.env' \
    --exclude 'node_modules/' --exclude 'dist/' \
    --exclude '__pycache__/' --exclude '*.py[cod]' \
    --exclude '.pytest_cache/' --exclude '.ruff_cache/' --exclude '.venv/' \
    --exclude '*.tsbuildinfo' \
    cnr-editor/

sync_component "Control panel environment" cnr-editor "cnr-editor/.env" \
    --chmod=F644 "$host_panel_env"

sync_component "Module" modules "modules/" \
    --chmod=F644 "$module_file"

echo
if $dry_run; then
    echo "Dry run complete."
    exit 0
fi

cat <<NEXT
Sync complete. Nothing was started, stopped or migrated on the host.
On the host, in $remote_dir:
  first deployment:  docker stop -t 120 nwnee_baldur && docker rm nwnee_baldur
                     ./db-apply.sh
                     ./server.sh start
                     ./web-restart.sh
  later, as needed:  migration/ changed      ./db-apply.sh
                     module changed          ./server.sh restart
                     Compose changed         ./server-restart.sh
                     cnr-editor/ changed     ./web-restart.sh

config/ is not sent. Edit the host's own nwserver.env, mysql.env and
mysql-init/ on the host, then ./server-restart.sh there.
NEXT
