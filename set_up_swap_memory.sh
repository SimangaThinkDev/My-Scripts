#!/bin/bash

# This script increases swap memory on a Linux system using a swap file.

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root (use sudo)"
  exit 1
fi

# Ask the user how much swap memory they want
read -rp "Enter desired swap size (e.g. 4G, 2048M): " swapsize

# Validate input (basic check)
if [[ ! "$swapsize" =~ ^[0-9]+[GgMm]$ ]]; then
  echo "❌ Invalid size format. Use something like 2G or 2048M."
  exit 1
fi

# Turn off swap if active
echo "🔧 Disabling existing swap (if any)..."
swapoff -a

# Remove old swapfile if it exists
if [ -f /swapfile ]; then
  echo "🗑️ Removing existing /swapfile..."
  rm /swapfile
fi

# Create new swapfile
echo "📦 Creating new swapfile of size $swapsize..."
fallocate -l "$swapsize" /swapfile 2>/dev/null || dd if=/dev/zero of=/swapfile bs=1M count=$(echo "$swapsize" | sed 's/[MmGg]//') status=progress

# Set correct permissions
chmod 600 /swapfile

# Set up swap area
mkswap /swapfile

# Enable swap
swapon /swapfile

# Backup fstab and add swap entry if not present
echo "📁 Ensuring /etc/fstab contains swap entry..."
cp /etc/fstab /etc/fstab.bak

if ! grep -q '/swapfile' /etc/fstab; then
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# Ask to adjust swappiness
read -rp "Do you want to change swappiness value (default 60)? [y/N]: " changeswappiness
if [[ "$changeswappiness" =~ ^[Yy]$ ]]; then
  read -rp "Enter swappiness value (e.g. 10 for low swap use): " swappiness
  if [[ "$swappiness" =~ ^[0-9]+$ ]]; then
    echo "vm.swappiness=$swappiness" >> /etc/sysctl.conf
    sysctl -w vm.swappiness="$swappiness"
  else
    echo "❌ Invalid swappiness value. Skipping..."
  fi
fi

# Confirm result
echo "✅ Swap setup complete."
swapon --show
free -h

