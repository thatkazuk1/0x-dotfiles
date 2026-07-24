#!/usr/bin/env bash

# Takes a region screenshot using hyprshot
hyprshot -m region -z -o ~/Pictures/Screenshots --silent

# Check if the screenshot was saved recently
LATEST_SS=$(ls -t ~/Pictures/Screenshots/*.png 2>/dev/null | head -n 1)

if [ -n "$LATEST_SS" ]; then
    # Calculate age in seconds
    AGE=$(($(date +%s) - $(stat -c %Y "$LATEST_SS")))
    if [ "$AGE" -lt 5 ]; then
        notify-send "Screenshot Saved" "$LATEST_SS" -i "$LATEST_SS" -t 3000
        exit 0
    fi
fi

notify-send "Screenshot" "Screenshot cancelled or failed." -t 3000
