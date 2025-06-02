#!/bin/bash

# ==========================
# Pop!_OS User Directory Cleaner
# ==========================
# Safely deletes all files and folders in Desktop, Documents, Downloads, Music, Pictures, and Videos.
# Keeps system/config files untouched and preserves this script itself.
# ==========================

set -euo pipefail

# Full path to this script
SCRIPT_PATH="$(realpath "$0")"

# Directories to clear (relative to home)
TARGET_DIRS=("Desktop" "Documents" "Downloads" "Music" "Pictures" "Videos")

# Resolve absolute home directory path
USER_HOME="$HOME"

# Confirm with user
echo "⚠️  This will permanently DELETE all contents in the following directories:"
for dir in "${TARGET_DIRS[@]}"; do
    echo "   - ${USER_HOME}/${dir}"
done
echo "❗ This action is irreversible. The script itself will be preserved."

read -p "Are you absolutely sure? Type 'yes' to proceed: " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "❌ Operation cancelled."
    exit 1
fi

# Function to clear a directory, skipping the script itself
clear_dir() {
    local dir_path="$1"
    if [[ -d "$dir_path" ]]; then
        echo "🧹 Clearing: $dir_path"

        # Iterate over files and folders in the directory
        shopt -s dotglob nullglob
        for item in "$dir_path"/* "$dir_path"/.*; do
            # Skip . and ..
            [[ "$(basename "$item")" == "." || "$(basename "$item")" == ".." ]] && continue
            # Skip the script itself
            [[ "$item" == "$SCRIPT_PATH" ]] && continue

            rm -rf -- "$item"
        done
        shopt -u dotglob nullglob

        echo "✅ Cleared: $dir_path"
    else
        echo "⚠️  Directory not found: $dir_path"
    fi
}

# Perform cleaning
for dir in "${TARGET_DIRS[@]}"; do
    clear_dir "${USER_HOME}/${dir}"
done

echo "🎉 All user directories cleaned successfully, and script preserved."

# Now Clearing Passwords...\
echo "Now Clearing passwords... "

# Code here////

