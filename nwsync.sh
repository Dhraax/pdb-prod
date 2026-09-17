#!/bin/bash

set -euo pipefail

# Publishes the module the server actually loads. On the repository root that is
# the staged copy under server/; on the host this script sits in the server
# directory itself, beside modules/.
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
module="modules/Puerta de Baldur 5E.mod"

if [[ -f "$script_dir/server/$module" ]]; then
    module_path="$script_dir/server/$module"
elif [[ -f "$script_dir/$module" ]]; then
    module_path="$script_dir/$module"
else
    echo "ERROR: $module not found under $script_dir/server/ or $script_dir/" >&2
    exit 1
fi

echo "[*] Publishing $module_path"
"$script_dir/nwn_nwsync_write" --description="PROD PDB NWSYNC" --limit-file-size 26 /var/www/html/nwsync "$module_path"
