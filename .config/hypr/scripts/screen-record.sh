#!/usr/bin/env bash

VIDEOS_DIR="$HOME/Videos/Recordings"
mkdir -p "$VIDEOS_DIR"

if pgrep -x "wf-recorder" > /dev/null; then
    # Stop recording
    pkill -INT -x wf-recorder
    notify-send "Screen Record" "Recording saved to $VIDEOS_DIR" -i media-record
else
    # Start recording
    GEOM=$(slurp)
    if [ -z "$GEOM" ]; then
        exit 1
    fi
    
    FILE="$VIDEOS_DIR/record_$(date +'%Y-%m-%d_%H-%M-%S').mp4"
    
    # Run wf-recorder in the background
    wf-recorder -g "$GEOM" -f "$FILE" &
    
    # Give it a tiny moment to start up and catch errors
    sleep 0.5
    if pgrep -x "wf-recorder" > /dev/null; then
        notify-send "Screen Record" "Recording started. Click toggle again to stop." -i media-record
    else
        notify-send "Screen Record" "Failed to start recording." -u critical
    fi
fi
