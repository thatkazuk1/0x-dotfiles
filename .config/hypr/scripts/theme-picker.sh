#!/bin/bash

STATE_DIR="$HOME/.config/matugen"
MODE_FILE="$STATE_DIR/mode"
TYPE_FILE="$STATE_DIR/type"

# Read current state
MODE="dark"
TYPE="scheme-tonal-spot"
[ -f "$MODE_FILE" ] && MODE=$(cat "$MODE_FILE")
[ -f "$TYPE_FILE" ] && TYPE=$(cat "$TYPE_FILE")

# Current wallpaper
WALLPAPER=$(cat "$HOME/.cache/current-wallpaper" 2>/dev/null || echo "")

options="Toggle Dark/Light Mode (Current: $MODE)
Tonal Spot (Default)
Vibrant
Expressive
Monochrome
Fruit Salad
Rainbow"

selected=$(echo "$options" | wofi --show dmenu -i --prompt "🎨 Theme Options" --width 400 --lines 8)

[ -z "$selected" ] && exit 0

case "$selected" in
    "Toggle Dark/Light Mode"*)
        if [ "$MODE" = "dark" ]; then
            echo "light" > "$MODE_FILE"
        else
            echo "dark" > "$MODE_FILE"
        fi
        ;;
    "Tonal Spot"*)
        echo "scheme-tonal-spot" > "$TYPE_FILE"
        ;;
    "Vibrant")
        echo "scheme-vibrant" > "$TYPE_FILE"
        ;;
    "Expressive")
        echo "scheme-expressive" > "$TYPE_FILE"
        ;;
    "Monochrome")
        echo "scheme-monochrome" > "$TYPE_FILE"
        ;;
    "Fruit Salad")
        echo "scheme-fruit-salad" > "$TYPE_FILE"
        ;;
    "Rainbow")
        echo "scheme-rainbow" > "$TYPE_FILE"
        ;;
esac

# If we have a wallpaper, apply it to trigger Matugen re-generation
if [ -f "$WALLPAPER" ]; then
    notify-send "Theme updated" "Applying new Material You theme..." -t 2000
    ~/.config/hypr/scripts/set-theme.sh "$WALLPAPER"
else
    notify-send "Theme updated" "Please set a wallpaper to apply the theme." -t 2000
fi
