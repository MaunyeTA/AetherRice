#!/usr/bin/env bash

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

# ----------------------------
# Checks
# ----------------------------

if [[ ! -f /etc/arch-release ]]; then
    error "This script is intended for Arch Linux."
    exit 1
fi

if ! ping -c 1 archlinux.org &>/dev/null; then
    error "No internet connection detected."
    exit 1
fi

# ----------------------------
# Update system
# ----------------------------

log "Updating system..."

sudo pacman -Syu --noconfirm

# ----------------------------
# Packages
# ----------------------------

PACKAGES=(
    hyprland
    waybar
    rofi-wayland
    kitty
    dunst
    polkit-kde-agent
    xdg-desktop-portal-hyprland

    qt5-wayland
    qt6-wayland

    pipewire
    wireplumber
    pipewire-pulse

    sddm

    ttf-jetbrains-mono-nerd

    git
    base-devel
)

# ----------------------------
# Install packages
# ----------------------------

log "Installing packages..."

for pkg in "${PACKAGES[@]}"; do
    if pacman -Qi "$pkg" &>/dev/null; then
        warn "$pkg already installed"
    else
        sudo pacman -S --needed --noconfirm "$pkg"
    fi
done

log "Installation complete."