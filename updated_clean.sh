 #!/bin/bash

# ==========================
# Pop!_OS Safe User Cleaner
# ==========================
# Permanently clears user files from common folders while:
# - Skipping this script itself
# - Avoiding all .sh files in ~/Desktop
# - Preserving hidden/system files in ~
# Also clears Firefox saved passwords and browsing history (even in Trash)
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
    local dir_name
    dir_name="$(basename "$dir_path")"

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

# Execute main folder cleanup
for dir in "${TARGET_DIRS[@]}"; do
    clear_dir "${USER_HOME}/${dir}"
done

echo "🧼 User folder cleanup complete."

# Now Clearing Firefox Data...
echo ""
echo "🔐 Now clearing saved Firefox passwords and browsing history..."

# Firefox-related paths to scan
FIREFOX_DIRS=(
  "$HOME/.mozilla/firefox"
  "$HOME/.cache/mozilla/firefox"
  "$HOME/.local/share/Trash"
)

# Firefox data files to remove
FIREFOX_FILES=(
  "logins.json"         # Passwords
  "key4.db"             # Encryption key for logins
  "signons.sqlite"      # Old-style passwords
  "places.sqlite"       # Bookmarks and history
  "formhistory.sqlite"  # Autofill form data
)

for dir in "${FIREFOX_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        echo "📁 Scanning $dir..."

        for filename in "${FIREFOX_FILES[@]}"; do
            find "$dir" -type f -name "$filename" -exec rm -f {} \;
        done

        echo "✅ Firefox data wiped in: $dir"
    fi
done

echo ""
echo "🎉 Full cleanup complete. Firefox passwords and history have been cleared."

echo "🎉 Cleanup complete. Script and .sh files on Desktop were preserved."

SSH_DIR="${USER_HOME}/.ssh"

echo "🔐 This will also PERMANENTLY delete ALL existing SSH keys and configurations."
read -p "Are you sure you want to delete SSH keys? Type 'yes' to proceed: " confirm_ssh_keys
if [[ "$confirm_ssh_keys" != "yes" ]]; then
    echo "❌ Skipping SSH key deletion."
else
    if [[ -d "$SSH_DIR" ]]; then
        echo "💥 Deleting SSH directory: $SSH_DIR..."
        rm -rf -- "$SSH_DIR"
        echo "✅ SSH keys deleted."
    else
        echo "⚠️  .ssh directory not found. Skipping."
    fi
fi

echo "🛠️ Setting up username for git"

# Ask for name (must not be empty)
while true; do
    read -p "Enter your name: " name
    if [[ -n "$name" ]]; then
        echo "✅ Name set as: $name"
        break
    else
        echo "⚠️ Name cannot be empty. Please try again."
    fi
done

# Ask for email (must look like an email)
while true; do
    read -p "Enter your email: " email
    if [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
        echo "✅ Email set as: $email"
        break
    else
        echo "⚠️ That doesn't look like a valid email. Try again."
    fi
done

# Configure git safely
git config --global user.name "$name"
git config --global user.email "$email"

# Show result
echo ""
echo "🚀 Git config has been set successfully:"
git config --global --list | grep 'user\.'
echo ""
echo "🎉 All requested cleanup tasks are complete!"

