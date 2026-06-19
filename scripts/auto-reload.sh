#!/bin/bash
while inotifywait -e close_write ~/.config/waybar; do killall -SIGUSR2 waybar; done

# If you will be editing the congigs, run this in the terminal... 
# while inotifywait -e close_write configs/*; do bash ./setup.sh; killall -SIGUSR2 waybar; done