#!/usr/bin/env bash

set -euo pipefail

export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:${PATH:-}"

dir="${WALLPAPER_DIR:-$HOME/Pictures/Saved-Pictures/wallpapers}"
current_link="$HOME/.cache/current-wallpaper"

mkdir -p "$dir" "$(dirname "$current_link")"

# ---- Pick a file ------------------------------------------------------
if [[ $# -ge 1 ]]; then
    file="$1"
else
    file="$(find "$dir" -type f \
        \( -iname '*.jpg'  -o -iname '*.jpeg' \
        -o -iname '*.png'  -o -iname '*.webp' \
        -o -iname '*.gif' \) \
        | shuf -n 1)"
fi

if [[ -z "${file}" || ! -f "${file}" ]]; then
    notify-send "Wallpaper" "No images found in ${dir}" -u normal 2>/dev/null || true
    echo "No wallpapers found in ${dir}" >&2
    exit 1
fi

# ---- Make sure awww-daemon is running ---------------------------------
if ! awww query &>/dev/null; then
    awww-daemon &>/dev/null &
    for _ in 1 2 3 4 5 6 7 8 9 10; do
        sleep 0.2
        awww query &>/dev/null && break
    done
fi

# ---- Apply Theme & Wallpaper ---------------------------------------------
~/.config/hypr/scripts/set-theme.sh "${file}"

# ---- Notify -----------------------------------------------------------
notify-send "Wallpaper" "$(basename "${file}")" \
    -i "${file}" -a "wallpaper" -t 2500 \
    -h "string:x-canonical-private-synchronous:wallpaper" 2>/dev/null || true
