#!/bin/bash

case "$1" in
status)
  swaync-client --get-dnd
  ;;
toggle)
  swaync-client --toggle-dnd
  ;;
state)
  if [ "$(swaync-client --get-dnd)" = "true" ]; then
    echo '{"class": "dnd"}'
  else
    echo '{"class": "dnd-off"}'
  fi
  ;;
esac
