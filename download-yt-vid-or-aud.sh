#!/bin/bash

# Exit on error
set -e

echo "🎥 Welcome to YouTube Downloader using yt-dlp!"
read -p "🔗 Please paste the YouTube link here: " link

# Check if input is empty
if [[ -z "$link" ]]; then
    echo "❌ No link entered. Exiting..."
    exit 1
fi

# Ask for audio-only option
read -p "💾 Do you want to download audio only? (y/N): " audio_only

if [[ "$audio_only" == "y" || "$audio_only" == "Y" ]]; then
    echo "🔊 Downloading audio only..."
    yt-dlp -f bestaudio --extract-audio --audio-format mp3 "$link"
else
    echo "📥 Downloading video in 720p or lower..."
    yt-dlp -f "bestvideo[height<=720]+bestaudio/best[height<=720]" "$link"
fi

echo "✅ Done! Your download is complete."

