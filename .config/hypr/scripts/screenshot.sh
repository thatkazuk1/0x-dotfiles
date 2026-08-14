#!/usr/bin/env bash

# Snip Region / Monitor / Window / Edit — bound to Print in keybinding.conf.
# hyprshot handles save-to-disk + clipboard + its own notify-send for the
# direct-capture modes; "edit" pipes a picked region straight into swappy for
# annotation instead (save_dir/save_filename_format come from
# ~/.config/swappy/config).

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

case "${1:-}" in
    region)
        hyprshot -m region -o "$DIR"
        ;;
    monitor)
        hyprshot -m output -m active -o "$DIR"
        ;;
    window)
        hyprshot -m window -m active -o "$DIR"
        ;;
    edit)
        grim -g "$(slurp)" - | swappy -f -
        ;;
    *)
        echo "Usage: $(basename "$0") {region|monitor|window|edit}" >&2
        exit 1
        ;;
esac
