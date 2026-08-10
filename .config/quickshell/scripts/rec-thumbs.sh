#!/bin/sh
dir="${1:-}"
[ -n "$dir" ] && [ -d "$dir" ] || exit 0

cache="${XDG_CACHE_HOME:-$HOME/.cache}/ukishima/rec-thumbs"
mkdir -p "$cache"

for f in "$cache"/*.jpg; do
    [ -e "$f" ] || continue
    base="$(basename "$f" .jpg)"
    [ -f "$dir/$base.mp4" ] || rm -f "$f"
done

find "$dir" -maxdepth 1 -type f -name 'recording_*.mp4' | while IFS= read -r src; do
    base="$(basename "$src" .mp4)"
    thumb="$cache/$base.jpg"
    if [ ! -s "$thumb" ] || [ "$src" -nt "$thumb" ]; then
        ffmpeg -y -loglevel quiet -i "$src" -frames:v 1 -vf 'scale=320:-2' -f image2 -c:v mjpeg "$thumb.tmp" 2>/dev/null
        if [ -s "$thumb.tmp" ]; then
            mv "$thumb.tmp" "$thumb"
        else
            rm -f "$thumb.tmp"
        fi
    fi
done
