#!/bin/bash

# Title
echo "🛠️  IntelliJ IDEA CLI Shortcut Setup (Pop!_OS)"
echo "-------------------------------------------"

# Search for all idea.sh files under JetBrains or custom locations
echo "🔍 Searching for IntelliJ installations..."
mapfile -t RESULTS < <(find "$HOME" -type f -path "*/idea.sh" 2>/dev/null)

# Exit if none found
if [ ${#RESULTS[@]} -eq 0 ]; then
    echo "❌ No IntelliJ IDEA installations found on this machine."
    exit 1
fi

# If only one result, use it automatically
if [ ${#RESULTS[@]} -eq 1 ]; then
    IDEA_BIN="${RESULTS[0]}"
    echo "✅ Found IntelliJ IDEA at: $IDEA_BIN"
else
    echo "🧠 Multiple IntelliJ installations found:"
    for i in "${!RESULTS[@]}"; do
        echo " [$i] ${RESULTS[$i]}"
    done

    while true; do
        read -rp "👉 Enter the number of the installation to use for the 'idea' command: " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -lt "${#RESULTS[@]}" ]; then
            IDEA_BIN="${RESULTS[$choice]}"
            break
        else
            echo "⚠️ Invalid choice. Please enter a number between 0 and $(( ${#RESULTS[@]} - 1 ))."
        fi
    done
fi

# Create symlink
echo "🔧 Creating symlink at /usr/local/bin/idea ..."
sudo ln -sf "$IDEA_BIN" /usr/local/bin/idea

# Test the result
if command -v idea &> /dev/null; then
    echo "🎉 Success! You can now launch IntelliJ IDEA using: idea"
    echo "📂 Try: idea .   to open current folder as project"
else
    echo "❌ Failed to create the 'idea' command. Please check permissions or try manually."
fi

