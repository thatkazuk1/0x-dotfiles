#!/usr/bin/env bash

# Close if already open
if eww active-windows | grep -q "window_wifi_menu"; then
  eww close window_wifi_menu
  exit 0
fi

mapfile -t MONITORS < <(hyprctl monitors -j | python3 -c "
import sys, json
mons = json.load(sys.stdin)
focused = next((str(m['id']) for m in mons if m.get('focused')), str(mons[0]['id']))
print(focused)
")
FOCUSED="${MONITORS[0]}"

eww close window_panel 2>/dev/null
eww open window_wifi_menu --screen "$FOCUSED"
