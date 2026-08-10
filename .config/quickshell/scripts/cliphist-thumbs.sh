#!/bin/sh
MAGICK_CONFIGURE_PATH="$(dirname "$0")/magick-policy"
export MAGICK_CONFIGURE_PATH

cache="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist-thumbs"
mkdir -p "$cache"

ids=$(cliphist list 2>/dev/null | awk -F'\t' '$2 ~ /\[\[ binary data .*(png|jpg|jpeg|gif|bmp|webp).*\]\]/ { print $1 }')

has_id() {
    printf '%s\n' "$ids" | grep -Fxq "$1"
}

for f in "$cache"/*.png; do
    [ -e "$f" ] || continue
    id="$(basename "$f" .png)"
    has_id "$id" || rm -f "$f"
done

printf '%s\n' "$ids" | while IFS= read -r id; do
    [ -n "$id" ] || continue
    thumb="$cache/$id.png"
    [ -s "$thumb" ] && continue
    printf '%s' "$id" | cliphist decode 2>/dev/null | magick - -strip -resize 256x256 "png:$thumb.tmp" 2>/dev/null
    if [ -s "$thumb.tmp" ]; then
        mv "$thumb.tmp" "$thumb"
    else
        rm -f "$thumb.tmp"
    fi
done
