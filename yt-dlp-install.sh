#!/bin/bash

# Exit on error
set -e

echo "Updating package list..."
sudo apt update

echo "Installing Python 3 and pip..."
sudo apt install -y python3 python3-pip

echo "Installing or upgrading yt-dlp using pip..."
pip3 install -U yt-dlp

echo "Creating yt-dlp alias for youtube-dl (optional)..."
SHELL_RC="$HOME/.bashrc"
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
fi

if ! grep -q "alias youtube-dl='yt-dlp'" "$SHELL_RC"; then
    echo "alias youtube-dl='yt-dlp'" >> "$SHELL_RC"
    echo "Alias added to $SHELL_RC"
else
    echo "Alias already exists in $SHELL_RC"
fi

echo "Installation complete. You may need to restart your terminal or run 'source $SHELL_RC' to use the alias."
yt-dlp --version

