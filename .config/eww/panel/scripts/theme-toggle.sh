#!/usr/bin/env bash

MODE_FILE="$HOME/.config/matugen/mode"
CURRENT_MODE="dark"

if [ -f "$MODE_FILE" ]; then
    CURRENT_MODE=$(cat "$MODE_FILE")
fi

if [ "$CURRENT_MODE" = "dark" ]; then
    NEW_MODE="light"
else
    NEW_MODE="dark"
fi

echo "$NEW_MODE" > "$MODE_FILE"

# Eww update is instantaneous so UI responds fast
eww update theme_mode="$NEW_MODE" 2>/dev/null || true

# Apply theme
WALLPAPER=$(cat "$HOME/.cache/current-wallpaper")
"$HOME/.config/hypr/scripts/set-theme.sh" "$WALLPAPER"
