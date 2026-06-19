#!/bin/bash
# Backup the current configs to my repo

cp -r ~/.config/hypr configs/backup/
cp -r ~/.config/waybar/ configs/backup/
cp -r ~/.config/rofi/ configs/backup/
cp -r ~/.config/alacritty/ configs/backup/

# git add .
# git commit -m "Update configs $(date +%Y-%m-%d)"