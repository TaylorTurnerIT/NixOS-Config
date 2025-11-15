#!/usr/bin/env bash

set -e

CONFIG_REPO="/home/taylort/NixOS Config"
LOG_FILE="/var/log/auto-deploy.log"

echo "[$(date)] Starting auto-deploy script..." >> "$LOG_FILE"

cd "$CONFIG_REPO"

echo "[$(date)] Pulling latest changes from Git repository..." >> "$LOG_FILE"
git pull origin main >> "$LOG_FILE" 2>&1

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse origin/main)

if [ "$LOCAL" != "$REMOTE" ]; then
    echo "[$(date)] Changes detected. Pulling..." >> "$LOG_FILE"
    git pull origin main >> "$LOG_FILE" 2>&1

    # Copy updated configuration files
    echo "[$(date)] Copying updated configuration files..." >> "$LOG_FILE"
    cp -r /home/taylort/Desktop/NixOS\ Config/* /etc/nixos/

    # Rebuild NixOS configuration
    echo "[$(date)] Rebuilding NixOS configuration..." >> "$LOG_FILE"
    nixos-rebuild switch 2>$1 | tee -a "$LOG_FILE"

    echo "[$(date)] Auto-deploy completed successfully." >> "$LOG_FILE"
else
    echo "[$(date)] No changes detected. Exiting." >> "$LOG_FILE"
fi