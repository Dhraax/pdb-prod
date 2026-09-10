#!/usr/bin/env bash

set -e

ROHOMEPATH=/nwn/home
HOMEPATH=/nwn/run
ARCHIVE_LOG_DIR="$ROHOMEPATH/logs"
STARTDATE=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$ARCHIVE_LOG_DIR"
printf '%s\n' "$STARTDATE" > "$ROHOMEPATH/startup_time"

# Keep a complete, live copy of stdout and stderr on the host-mounted home.
# This file survives even if the server or the whole container crashes.
exec > >(tee -a "$ARCHIVE_LOG_DIR/console_${STARTDATE}.log") 2>&1

archive_runtime_logs()
{
    local destination="$1"
    local runtime_logs=()
    local log_path

    shopt -s nullglob
    runtime_logs=("$HOMEPATH"/logs.*)
    shopt -u nullglob

    [ "${#runtime_logs[@]}" -gt 0 ] || return 0

    mkdir -p "$destination"
    for log_path in "${runtime_logs[@]}"; do
        [ -e "$log_path" ] || continue
        mv -- "$log_path" "$destination/"
        echo "[*] Archived $log_path in $destination"
    done
}

# Recover log directories left behind by an unclean restart of this container.
archive_runtime_logs "$ARCHIVE_LOG_DIR/recovered_${STARTDATE}"

# Make a shadow copy of home and link persistent directories into the runtime.
echo "[*] Linking in user home"
for path_name in database hak modules override portraits saves servervault tlk development; do
    if [ ! -d "$ROHOMEPATH/$path_name" ]; then mkdir -v "$ROHOMEPATH/$path_name"; fi
    if [ ! -e "$HOMEPATH/$path_name" ]; then ln -vs "$ROHOMEPATH/$path_name" "$HOMEPATH/"; fi
done
for path_name in dialog.tlk dialogf.tlk; do
    if [ ! -L "$HOMEPATH/$path_name" ]; then ln -vs "$ROHOMEPATH/$path_name" "$HOMEPATH/"; fi
done

if [ -e "$ROHOMEPATH/settings.tml" ] && [ ! -e "$HOMEPATH/settings.tml" ]; then
    echo "[*] Linking in settings.tml"
    ln -vs "$ROHOMEPATH/settings.tml" "$HOMEPATH/"
fi

echo "[*] Importing configuration"
if [ -f "$ROHOMEPATH/nwn.ini" ]; then
    echo "[*] .. nwn.ini"
    awk -f /nwn/prep-nwn-ini.awk < "$ROHOMEPATH/nwn.ini" > "$HOMEPATH/nwn.ini"
fi

if [ -f "$ROHOMEPATH/nwnplayer.ini" ]; then
    echo "[*] .. nwnplayer.ini"
    awk -f /nwn/prep-nwnplayer-ini.awk < "$ROHOMEPATH/nwnplayer.ini" > "$HOMEPATH/nwnplayer.ini"
fi

if [ -f "$ROHOMEPATH/cryptographic_secret" ]; then
    echo "[*] .. cryptographic_secret"
    cp -a "$ROHOMEPATH/cryptographic_secret" "$HOMEPATH/"
fi

TAIL_PID=""
if [ "${NWN_TAIL_LOGS:-n}" = "y" ]; then
    echo "[*] Server logs mirrored to stdout"
    (sleep 1; tail -q -F \
        "$HOMEPATH/logs.0/nwserverLog1.txt" \
        "$HOMEPATH/logs.0/nwserverError1.txt") &
    TAIL_PID=$!
fi

backup_runtime_configuration()
{
    if [ -f "$HOMEPATH/cryptographic_secret" ] && [ ! -f "$ROHOMEPATH/cryptographic_secret" ]; then
        echo "Backing up cryptographic_secret to your user home"
        cp -a "$HOMEPATH/cryptographic_secret" "$ROHOMEPATH/cryptographic_secret"
    fi

    if [ -f "$HOMEPATH/settings.tml" ] && [ ! -f "$ROHOMEPATH/settings.tml" ]; then
        echo "Backing up settings.tml to your user home"
        cp -a "$HOMEPATH/settings.tml" "$ROHOMEPATH/settings.tml"
    fi
}
(sleep 10; backup_runtime_configuration) &
CONFIG_BACKUP_PID=$!

echo "[*] Port: ${NWN_PORT:-5121}/udp"

args=()
if [[ "${NWN_MODULEURL:-}" != "" ]]; then
    args+=("-moduleurl" "${NWN_MODULEURL}")
else
    args+=("-module" "${NWN_MODULE:-DockerDemo}")
fi
if [[ "${NWN_NWSYNCURL:-}" != "" ]]; then
    args+=("-nwsyncurl" "${NWN_NWSYNCURL}")
fi
if [[ "${NWN_NWSYNCHASH:-}" != "" ]]; then
    args+=("-nwsynchash" "${NWN_NWSYNCHASH}")
fi
if [[ "${NWN_MODULEHASH:-}" != "" ]]; then
    args+=("-modulehash" "${NWN_MODULEHASH}")
fi

copy_crash_log()
{
    inotifywait -mq -e moved_to -e create "$HOMEPATH" --format "%f" | while IFS= read -r filename; do
        if [[ "$filename" = nwserver-crash*.log ]]; then
            echo "The server crashed; saving $filename into the persistent server home."
            cp -a "$HOMEPATH/$filename" "$ROHOMEPATH/"
        fi
    done
}
copy_crash_log &
CRASH_WATCH_PID=$!

copy_runtime_configuration()
{
    inotifywait -mq -e close_write "$HOMEPATH" --format "%f" | while IFS= read -r filename; do
        if [[ "$filename" = cryptographic_secret ]] || [[ "$filename" = settings.tml ]]; then
            backup_runtime_configuration
        fi
    done
}
copy_runtime_configuration &
CONFIG_WATCH_PID=$!

SERVER_PID=""

stop_background_processes()
{
    local process_id

    for process_id in "$TAIL_PID" "$CONFIG_BACKUP_PID" "$CRASH_WATCH_PID" "$CONFIG_WATCH_PID"; do
        [ -n "$process_id" ] || continue
        kill "$process_id" 2>/dev/null || true
    done
}

finish()
{
    local server_status="$1"

    trap - INT TERM
    stop_background_processes
    archive_runtime_logs "$ARCHIVE_LOG_DIR/$STARTDATE"
    exit "$server_status"
}

shutdown()
{
    local server_status=0

    trap - INT TERM
    if [ -n "$SERVER_PID" ] && kill -0 "$SERVER_PID" 2>/dev/null; then
        echo "[*] Stopping NWN server before archiving logs"
        kill -INT "$SERVER_PID" 2>/dev/null || true
        wait "$SERVER_PID"
        server_status=$?
    fi
    finish "$server_status"
}

trap shutdown INT TERM

configure_nwnx_sql()
{
    [ "${NWNX_SQL_SKIP:-y}" = "n" ] || return 0

    export NWNX_SQL_TYPE="${NWNX_SQL_TYPE:-MYSQL}"
    export NWNX_SQL_HOST="${NWNX_SQL_HOST:-mysql}"
    export NWNX_SQL_PORT="${NWNX_SQL_PORT:-3306}"
    export NWNX_SQL_USERNAME="${NWNX_SQL_USERNAME:-${MYSQL_USER:-}}"
    export NWNX_SQL_PASSWORD="${NWNX_SQL_PASSWORD:-${MYSQL_PASSWORD:-}}"
    export NWNX_SQL_DATABASE="${NWNX_SQL_DATABASE:-${MYSQL_DATABASE:-}}"
    export NWNX_SQL_CHARACTER_SET="${NWNX_SQL_CHARACTER_SET:-utf8mb4}"
    export NWNX_SQL_USE_UTF8="${NWNX_SQL_USE_UTF8:-true}"
    export NWNX_SQL_QUERY_METRICS="${NWNX_SQL_QUERY_METRICS:-false}"

    if [ -z "$NWNX_SQL_USERNAME" ] || [ -z "$NWNX_SQL_PASSWORD" ] || [ -z "$NWNX_SQL_DATABASE" ]; then
        echo "ERROR: NWNX_SQL is enabled but database credentials are incomplete."
        exit 1
    fi
}

configure_nwnx_sql

set +e
export LD_PRELOAD="${NWN_LD_PRELOAD:-}"
export LD_LIBRARY_PATH="${NWN_LD_LIBRARY_PATH:-}"
./nwserver \
    ${NWN_EXTRA_ARGS:-} \
    -port "${NWN_PORT:-5121}" \
    -interactive \
    -servername "${NWN_SERVERNAME:-I was too lazy to configure my server.}" \
    -publicserver "${NWN_PUBLICSERVER:-0}" \
    -maxclients "${NWN_MAXCLIENTS:-96}" \
    -minlevel "${NWN_MINLEVEL:-1}" \
    -maxlevel "${NWN_MAXLEVEL:-40}" \
    -pauseandplay "${NWN_PAUSEANDPLAY:-1}" \
    -pvp "${NWN_PVP:-2}" \
    -servervault "${NWN_SERVERVAULT:-1}" \
    -elc "${NWN_ELC:-1}" \
    -ilr "${NWN_ILR:-1}" \
    -gametype "${NWN_GAMETYPE:-0}" \
    -oneparty "${NWN_ONEPARTY:-0}" \
    -difficulty "${NWN_DIFFICULTY:-3}" \
    -autosaveinterval "${NWN_AUTOSAVEINTERVAL:-0}" \
    -playerpassword "${NWN_PLAYERPASSWORD:-}" \
    -dmpassword "${NWN_DMPASSWORD:-}" \
    -adminpassword "${NWN_ADMINPASSWORD:-}" \
    -reloadwhenempty "${NWN_RELOADWHENEMPTY:-0}" \
    "${args[@]}" &
SERVER_PID=$!

wait "$SERVER_PID"
SERVER_STATUS=$?
SERVER_PID=""
finish "$SERVER_STATUS"
