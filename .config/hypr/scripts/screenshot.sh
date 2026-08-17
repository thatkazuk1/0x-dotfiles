#!/usr/bin/env bash

# Snip Region / Monitor / Window / Edit — bound to Print in keybinding.conf.
# Region, monitor, and window capture save directly to disk.
# Edit pipes a picked area into swappy for annotation.

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

filename() {
    printf "%s/%s_%s.png" "$DIR" "$(date +%Y-%m-%d-%H%M%S)" "$1"
}

notify() {
    notify-send "Screenshot saved" "$(basename "$1")" -i "$1" -a "screenshot" -t 2500
}

case "${1:-}" in
    region)
        f="$(filename region)"
        grim -g "$(slurp)" "$f" && notify "$f"
        ;;
    monitor)
        output=$(hyprctl monitors -j | jq -r ".[] | select(.focused == true) | .name" | head -n1)
        [ -n "$output" ] || exit 1
        f="$(filename monitor)"
        grim -o "$output" "$f" && notify "$f"
        ;;
    window)
        geom=$(hyprctl activewindow -j | jq -r "\"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])\"")
        [ -n "$geom" ] || exit 1
        f="$(filename window)"
        grim -g "$geom" "$f" && notify "$f"
        ;;
    edit)
        grim -g "$(slurp)" - | swappy -f -
        ;;
    *)
        echo "Usage: $(basename "$0") {region|monitor|window|edit}" >&2
        exit 1
        ;;
esac
