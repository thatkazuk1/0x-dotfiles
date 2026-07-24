#!/bin/bash
# Read/mutate the notification store used by the eww panel.
# Usage: notif-store.sh get | remove <id> | clear
STORE="$HOME/.cache/eww-notifications.json"

get() {
  if [ -s "$STORE" ]; then cat "$STORE"; else echo "[]"; fi
}

push() {
  eww update "notifications=$(get)" 2>/dev/null
}

case "$1" in
get)
  get
  ;;
remove)
  [ -n "$2" ] || exit 1
  python3 - "$2" <<'EOF'
import json, os, sys
store = os.path.expanduser("~/.cache/eww-notifications.json")
try:
    with open(store) as f:
        items = json.load(f)
except (OSError, ValueError):
    items = []
items = [n for n in items if str(n.get("id")) != sys.argv[1]]
tmp = store + ".tmp"
with open(tmp, "w") as f:
    json.dump(items, f)
os.replace(tmp, store)
EOF
  push
  ;;
clear)
  echo "[]" > "$STORE"
  swaync-client --close-all 2>/dev/null
  push
  ;;
esac
