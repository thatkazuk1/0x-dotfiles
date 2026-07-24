#!/usr/bin/env bash
LOG=/tmp/weather-wrapper.log
{
  echo "=== $(date -Iseconds) args=[$*] ==="
  echo "PATH=$PATH"
  echo "HOME=$HOME"
  echo "USER=$USER"
  echo "PWD=$PWD"
  echo "XDG_STATE_HOME=$XDG_STATE_HOME"
  echo "XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
  echo "LANG=$LANG"
  echo "ruby=$(command -v ruby || echo MISSING)"
  echo "--- script output (stdout|stderr interleaved) ---"
} >>"$LOG" 2>&1

"$HOME/.config/waybar/scripts/weather/get-weather.rb" "$@" >>"$LOG" 2>&1
ec=$?
echo "--- exit=$ec ---" >>"$LOG"
exit "$ec"
