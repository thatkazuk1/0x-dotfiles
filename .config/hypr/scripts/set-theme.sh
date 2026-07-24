#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <path-to-image>"
    exit 1
fi

IMAGE=$(realpath "$1")

if [ ! -f "$IMAGE" ]; then
    echo "Error: File not found at $IMAGE"
    exit 1
fi

# Read theme state, default to dark and scheme-tonal-spot
MODE="dark"
TYPE="scheme-tonal-spot"
STATE_DIR="$HOME/.config/matugen"
mkdir -p "$STATE_DIR"

if [ -f "$STATE_DIR/mode" ]; then
    MODE=$(cat "$STATE_DIR/mode")
fi

if [ -f "$STATE_DIR/type" ]; then
    TYPE=$(cat "$STATE_DIR/type")
fi

# Set GTK System Theme appearance preference
if [ "$MODE" = "light" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
fi

# Ensure awww-daemon is running
if ! pgrep -x awww-daemon > /dev/null; then
    awww-daemon &
    sleep 1
fi

# Set wallpaper using awww
awww img "$IMAGE" --transition-type grow --transition-pos 0.5,0.5 --transition-step 90

# Save current wallpaper path
echo "$IMAGE" > "$HOME/.cache/current-wallpaper"

# Run Matugen to generate colors and templates (force index 0 to avoid interactive prompt)
matugen image "$IMAGE" -m "$MODE" -t "$TYPE" -c "$STATE_DIR/config.toml" --source-color-index 0

# Reload Waybar to apply new colors (SIGUSR2 reloads config in waybar)
killall -SIGUSR2 waybar

# Reload Kitty config (SIGUSR1 tells kitty to reload its config)
killall -SIGUSR1 kitty

# Reload Eww to apply new colors
eww reload

echo "Theme applied: Mode=$MODE, Type=$TYPE, Image=$IMAGE"
