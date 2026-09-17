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
#   config/nwserver.env and config/mysql.env, taken from the private config/host/
#   config/mysql-init/
#   migration/, read by db-apply.sh
#   cnr-editor/ and its cnr-editor/.env
#   modules/Puerta de Baldur 5E.mod
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

stack_scripts=(run-server.sh server-restart.sh web-restart.sh db-apply.sh nwsync.sh nwn_nwsync_write)

for path in docker-compose.yml "${stack_scripts[@]}" "$module_file" cnr-editor/compose.yml; do
    [[ -f "$path" ]] || fail "required file is missing: $path"
done
for path in config/mysql-init migration cnr-editor/backend cnr-editor/frontend; do
    [[ -d "$path" ]] || fail "required directory is missing: $path"
done

host_nwserver_env="config/host/nwserver.env"
host_mysql_env="config/host/mysql.env"
host_panel_env="config/host/cnr-editor.env"
[[ -f "$host_panel_env" ]] || host_panel_env="cnr-editor/host.env.example"

[[ -f "$host_nwserver_env" ]] \
    || fail "$host_nwserver_env is missing; create it from config/nwserver.env.example with the host's values"
[[ -f "$host_mysql_env" ]] \
    || fail "$host_mysql_env is missing; create it from config/mysql.env.example with the host's credentials"

# Last assignment of a key, as Compose reads an env file.
env_value() {
    sed -n "s/^[[:space:]]*$2=//p" "$1" | tail -n 1 | tr -d '\r'
}

reject_placeholder() {
    local value
    value="$(env_value "$1" "$2")"
    [[ "$value" != cambia-* ]] || fail "$2 in $1 still holds the .example placeholder"
}

require_value() {
    [[ -n "$(env_value "$1" "$2")" ]] || fail "$2 is missing or empty in $1"
    reject_placeholder "$1" "$2"
}

for key in NWN_PLAYERPASSWORD NWN_DMPASSWORD NWN_ADMINPASSWORD; do
    reject_placeholder "$host_nwserver_env" "$key"
done
[[ "$(env_value "$host_nwserver_env" NWN_MODULE)" == "$module_name" ]] \
    || fail "NWN_MODULE in $host_nwserver_env must be \"$module_name\", the module this script sends"
[[ "$(env_value "$host_nwserver_env" NWNX_SQL_SKIP)" == "n" ]] \
    || fail "NWNX_SQL_SKIP in $host_nwserver_env must be n: the module needs MySQL"

for key in MYSQL_ROOT_PASSWORD MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD; do
    require_value "$host_mysql_env" "$key"
done
if [[ -z "$(env_value "$host_mysql_env" CNR_EDITOR_MFA_ENCRYPTION_KEY)" ]]; then
    echo "WARNING: CNR_EDITOR_MFA_ENCRYPTION_KEY is empty in $host_mysql_env; the panel will refuse MFA enrolment." >&2
else
    reject_placeholder "$host_mysql_env" CNR_EDITOR_MFA_ENCRYPTION_KEY
fi
if [[ -f config/mysql.env ]] && cmp -s config/mysql.env "$host_mysql_env"; then
    fail "$host_mysql_env is identical to the local config/mysql.env; the host needs its own credentials"
fi

[[ "$(env_value "$host_panel_env" CNR_EDITOR_MYSQL_ENV_FILE)" == "../config/mysql.env" ]] \
    || fail "CNR_EDITOR_MYSQL_ENV_FILE in $host_panel_env must be ../config/mysql.env"
[[ "$(env_value "$host_panel_env" CNR_EDITOR_NETWORK_NAME)" == "server_default" ]] \
    || fail "CNR_EDITOR_NETWORK_NAME in $host_panel_env must be server_default"
[[ "$(env_value "$host_panel_env" CNR_EDITOR_PORT)" == 127.0.0.1:* ]] \
    || fail "CNR_EDITOR_PORT in $host_panel_env must be bound to 127.0.0.1; the panel is never published directly"

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
remote_dirs="config config/mysql-init modules migration cnr-editor"

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
echo "        config/nwserver.env <- $host_nwserver_env"
echo "        config/mysql.env    <- $host_mysql_env"
echo "        config/mysql-init/, migration/, cnr-editor/"
echo "        cnr-editor/.env     <- $host_panel_env"
echo "        $module_file"
echo "Keeps:  hak, tlk, servervault, database, logs and everything else already there"
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

sync_component "Server environment" config "config/nwserver.env" \
    --chmod=F600 "$host_nwserver_env"

sync_component "MySQL environment" config "config/mysql.env" \
    --chmod=F600 "$host_mysql_env"

sync_component "MySQL initialisation" config "config/mysql-init/" \
    --delete-delay --chmod=D755,F755 \
    config/mysql-init/

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
  first deployment:  docker compose -f docker-compose-pdb.yml down
                     ./db-apply.sh
                     ./nwsync.sh
                     docker compose up -d
                     ./web-restart.sh
  later, as needed:  migration/ changed      ./db-apply.sh
                     module changed          ./nwsync.sh, then ./server-restart.sh
                     Compose or env changed  ./server-restart.sh
                     cnr-editor/ changed     ./web-restart.sh
NEXT
