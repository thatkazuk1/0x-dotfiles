#!/usr/bin/env bash
close_panel() {
  eww close window_panel 2>/dev/null
  while IFS=: read -r instance _name; do
    eww close "$instance" 2>/dev/null
  done < <(eww active-windows | grep "window_closer")
}

if [[ "$1" == "close" ]]; then
  close_panel
  exit 0
fi

if eww active-windows | grep -q "window_panel"; then
  close_panel
  exit 0
fi

mapfile -t MONITORS < <(hyprctl monitors -j | python3 -c "
import sys, json
mons = json.load(sys.stdin)
focused = next((str(m['id']) for m in mons if m.get('focused')), str(mons[0]['id']))
print(focused)
for m in mons:
    print(m['id'])
")
FOCUSED="${MONITORS[0]}"

for mon in "${MONITORS[@]:1}"; do
  eww open window_closer --screen "$mon" --id "closer_$mon" 2>/dev/null
done

eww open window_panel --screen "$FOCUSED"
