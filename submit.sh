#!/bin/bash

# ==========================
# Pop!_OS Safe User Cleaner
# ==========================
# Permanently clears user files from common folders while:
# - Skipping this script itself
# - Avoiding all .sh files in ~/Desktop
# - Preserving hidden/system files in ~
# ==========================

set -euo pipefail

# Full path to this script
SCRIPT_PATH="$(realpath "$0")"

# Directories to clear (relative to home)
TARGET_DIRS=("Desktop" "Documents" "Downloads" "Music" "Pictures" "Videos")

# Resolve absolute home directory
USER_HOME="$HOME"

# Confirm with user
echo "⚠️  This will permanently DELETE all contents in:"
for dir in "${TARGET_DIRS[@]}"; do
    echo "   - ${USER_HOME}/${dir}"
done
echo "🛡️  All .sh files in Desktop will be preserved."
echo "🛡️  This script will be preserved."
read -p "Type 'yes' to proceed: " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "❌ Cancelled."
    exit 1
fi

# Function to clear a directory
clear_dir() {
    local dir_path="$1"
    local dir_name="$(basename "$dir_path")"

    if [[ -d "$dir_path" ]]; then
        echo "🧹 Cleaning $dir_path..."

        shopt -s dotglob nullglob
        for item in "$dir_path"/* "$dir_path"/.*; do
            base_item="$(basename "$item")"

            # Skip . and ..
            [[ "$base_item" == "." || "$base_item" == ".." ]] && continue

            # Skip the script itself
            [[ "$item" == "$SCRIPT_PATH" ]] && continue

            # Skip .sh files ONLY in Desktop
            if [[ "$dir_name" == "Desktop" && "$item" == *.sh ]]; then
                echo "⚠️  Skipping script: $item"
                continue
            fi

            # Delete item
            rm -rf -- "$item"
        done
        shopt -u dotglob nullglob

        echo "✅ Done: $dir_path"
    else
        echo "⚠️  Skipping missing directory: $dir_path"
    fi
}

# Execute
for dir in "${TARGET_DIRS[@]}"; do
    clear_dir "${USER_HOME}/${dir}"
done

echo "🎉 Cleanup complete. Script and .sh files on Desktop were preserved."

# Now Clearing Passwords...\
echo "Now Clearing passwords... "

# Code here////

