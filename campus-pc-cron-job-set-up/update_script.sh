#!/bin/bash

# Create log directory if it doesn't exist
LOG_DIR="/home/wtc"
LOG_FILE="$LOG_DIR/update_logs.txt"

# Create log file if it doesn't exist smh
touch "$LOG_FILE"

# Update and upgrade
if /usr/bin/apt update && /usr/bin/apt upgrade -y; then
    echo "$(date +'%F %T') - Success" >> "$LOG_FILE"
else
    echo "$(date +'%F %T') - Failure" >> "$LOG_FILE"
fi

