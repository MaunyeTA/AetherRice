#!/bin/bash
set -euo pipefail

# ----------------------------
# Colors
# ----------------------------
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Run the install script
bash scripts/install.sh

# TODO: Backup current configs

# Ensure the required directories exists
mkdir -p ~/.config/{hypr,waybar,rofi,kitty,assets}

# Copy configs
cp -r configs/hypr ~/.config/
cp -r configs/waybar ~/.config/
cp -r configs/rofi ~/.config/
cp -r configs/kitty ~/.config/
cp -r configs/fastfetch ~/.config/
cp -r assets ~/.config/ 
cp -r configs/fish/config.fish ~/.config/fish/config.fish
# ...

log "Setup Complete"
log "Starting Hyprland."

# Enable the login/session management daemon
log "Enabling SDDM service..."

if sudo systemctl enable sddm >/dev/null 2>&1; then
    log "SDDM enabled successfully."
else
    error "Failed to enable SDDM."
    exit 1
fi

# If hyprland is already running, just reload the configs
if hyprctl reload >/dev/null 2>&1; then
    log "Hyprland configs reloaded successfully."
fi

log "DONE"