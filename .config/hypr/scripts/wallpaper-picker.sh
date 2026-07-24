#!/usr/bin/env bash

set -euo pipefail
export PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:${PATH:-}"

dir="${WALLPAPER_DIR:-$HOME/Pictures/Saved-Pictures/wallpapers}"
cache_dir="$HOME/.cache/wallpaper-picker"
thumbs_dir="$cache_dir/thumbs"
state_file="$cache_dir/current"
mkdir -p "$thumbs_dir"

mapfile -t files < <(
    find "$dir" -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) \
        | sort
)
count=${#files[@]}
[[ $count -eq 0 ]] && { notify-send "Wallpaper picker" "No wallpapers in $dir"; exit 1; }

thumbnailer=""
if   command -v vipsthumbnail >/dev/null 2>&1; then thumbnailer="vips"
elif command -v magick        >/dev/null 2>&1; then thumbnailer="magick"
elif command -v convert       >/dev/null 2>&1; then thumbnailer="convert"
fi

thumb_path() {
    local key
    key=$(printf '%s' "$1" | sha256sum | cut -d' ' -f1)
    printf '%s/%s.jpg' "$thumbs_dir" "$key"
}

to_build=()
if [[ -n "$thumbnailer" ]]; then
    for f in "${files[@]}"; do
        t=$(thumb_path "$f")
        if [[ ! -f "$t" ]] || [[ "$f" -nt "$t" ]]; then
            to_build+=("$f")
        fi
    done

    if (( ${#to_build[@]} > 0 )); then
        notify-send -t 2000 "Wallpaper picker" "Caching ${#to_build[@]} thumbnail(s)..."
        printf '%s\0' "${to_build[@]}" | xargs -0 -P 4 -I{} bash -c '
            src="$1"
            key=$(printf "%s" "$src" | sha256sum | cut -d" " -f1)
            dst="'"$thumbs_dir"'/${key}.jpg"
            case "'"$thumbnailer"'" in
                vips)    vipsthumbnail "$src" --size 256x256 -o "${dst}[Q=80]" 2>/dev/null ;;
                magick)  magick  "$src" -thumbnail 256x256 -quality 80 "$dst" 2>/dev/null ;;
                convert) convert "$src" -thumbnail 256x256 -quality 80 "$dst" 2>/dev/null ;;
            esac || true
        ' _ {}
    fi
fi

build_entries() {
    printf '🎲 Random wallpaper\0icon\x1fmedia-playlist-shuffle\n'
    for f in "${files[@]}"; do
        name=$(basename "$f")
        if [[ -n "$thumbnailer" ]]; then
            icon=$(thumb_path "$f")
            [[ -f "$icon" ]] || icon="$f"
        else
            icon="$f"
        fi
        # Rofi dmenu icon format: text\0icon\x1f/path
        printf '%s\0icon\x1f%s\n' "$name" "$icon"
    done
}

selected=$(build_entries | rofi -dmenu -i \
    -p "  Wallpapers ($count)" \
    -theme ~/.config/rofi/wallpaper-picker.rasi)

[[ -z "$selected" ]] && exit 0

# Resolve to a real path
if [[ "$selected" == "🎲 Random wallpaper" ]]; then
    file="${files[RANDOM % count]}"
else
    file=""
    for f in "${files[@]}"; do
        [[ "$(basename "$f")" == "$selected" ]] && { file="$f"; break; }
    done
fi
[[ -z "$file" || ! -f "$file" ]] && exit 1

# Apply the theme (which also sets the wallpaper using awww via set-theme.sh)
~/.config/hypr/scripts/set-theme.sh "$file"

# Save state
echo "$file" > "$state_file"
echo "$file" > "$HOME/.cache/current-wallpaper"
notify-send "Wallpaper Updated" "$(basename "$file")" -i "$file" -a "wallpaper" -t 2500
