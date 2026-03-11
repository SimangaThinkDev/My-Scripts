```bash
#!/usr/bin/env bash

# swapper — Safe Linux Swap Manager
# A safer CLI tool to create or resize swap files

set -e

VERSION="1.0"
SWAPFILE="/swapfile"
FSTAB="/etc/fstab"
LOGFILE="/var/log/swapper.log"

# Colors
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
RESET="\033[0m"

log() {
    echo -e "$1"
    echo "$(date '+%F %T') | $1" >> "$LOGFILE"
}

fail() {
    log "${RED}ERROR:${RESET} $1"
    exit 1
}

# ----------------------------
# Root check
# ----------------------------

if [[ "$EUID" -ne 0 ]]; then
    fail "Please run with sudo."
fi

# ----------------------------
# Help menu
# ----------------------------

help() {
cat << EOF

swapper v$VERSION

Safe swap file management tool.

Usage:
  swapper --size 4G
  swapper --auto
  swapper --status

Options:
  --size SIZE     Create swapfile of specified size (example: 4G)
  --auto          Automatically choose recommended swap size
  --status        Show current swap usage
  --help          Show this help message

Examples:
  sudo swapper --size 8G
  sudo swapper --auto

EOF
}

# ----------------------------
# Status command
# ----------------------------

status() {
    log "${BLUE}Current Swap Status${RESET}"
    swapon --show
    echo ""
    free -h
    exit 0
}

# ----------------------------
# Detect RAM
# ----------------------------

detect_ram() {
    RAM_GB=$(awk '/MemTotal/ {printf "%.0f\n", $2/1024/1024}' /proc/meminfo)
}

# ----------------------------
# Recommend swap
# ----------------------------

recommend_swap() {

    detect_ram

    if [[ "$RAM_GB" -le 2 ]]; then
        SWAPSIZE="2G"
    elif [[ "$RAM_GB" -le 8 ]]; then
        SWAPSIZE="${RAM_GB}G"
    else
        SWAPSIZE="4G"
    fi

    log "${BLUE}Detected RAM:${RESET} ${RAM_GB}GB"
    log "${GREEN}Recommended swap size:${RESET} $SWAPSIZE"
}

# ----------------------------
# Create swap
# ----------------------------

create_swap() {

    SIZE="$1"

    log "${BLUE}Setting up swapfile ($SIZE)...${RESET}"

    BACKUP="/etc/fstab.bak.$(date +%s)"
    cp "$FSTAB" "$BACKUP"

    log "Backup created: $BACKUP"

    if swapon --show | grep -q "$SWAPFILE"; then
        log "Disabling existing swapfile..."
        swapoff "$SWAPFILE"
    fi

    if [[ -f "$SWAPFILE" ]]; then
        rm -f "$SWAPFILE"
    fi

    log "Creating swapfile..."

    if ! fallocate -l "$SIZE" "$SWAPFILE"; then
        log "${YELLOW}fallocate failed, using dd fallback${RESET}"

        NUM=$(echo "$SIZE" | tr -dc '0-9')
        UNIT=$(echo "$SIZE" | tr -dc 'A-Za-z')

        if [[ "$UNIT" == "G" || "$UNIT" == "g" ]]; then
            COUNT=$((NUM*1024))
        else
            COUNT=$NUM
        fi

        dd if=/dev/zero of="$SWAPFILE" bs=1M count="$COUNT" status=progress
    fi

    chmod 600 "$SWAPFILE"

    mkswap "$SWAPFILE"

    swapon "$SWAPFILE"

    log "Updating fstab safely..."

    sed -i '\|/swapfile|d' "$FSTAB"

    echo "$SWAPFILE none swap sw 0 0" >> "$FSTAB"

    log "Validating system configuration..."

    if ! mount -a; then
        log "${RED}fstab validation failed.${RESET}"
        log "Restoring backup configuration."
        cp "$BACKUP" "$FSTAB"

        fail "Configuration restored. Please check disk settings."
    fi

    optimize_nvme

    log "${GREEN}Swap successfully configured.${RESET}"

    status
}

# ----------------------------
# NVMe optimization
# ----------------------------

optimize_nvme() {

    if lsblk -d -o name | grep -q nvme; then
        log "${BLUE}NVMe drive detected.${RESET}"

        SWAPPINESS=10

        sed -i '/vm.swappiness/d' /etc/sysctl.conf
        echo "vm.swappiness=$SWAPPINESS" >> /etc/sysctl.conf

        sysctl -w vm.swappiness="$SWAPPINESS" >/dev/null

        log "Swappiness optimized for SSD/NVMe ($SWAPPINESS)"
    fi
}

# ----------------------------
# Argument parsing
# ----------------------------

case "$1" in

--size)

    SIZE="$2"

    [[ -z "$SIZE" ]] && fail "Please provide size (example: --size 4G)"

    create_swap "$SIZE"
    ;;

--auto)

    recommend_swap
    create_swap "$SWAPSIZE"
    ;;

--status)

    status
    ;;

--help)

    help
    ;;

*)

    help
    ;;

esac
```
