#!/usr/bin/env bash

SSID="$1"
SECURITY="$2"

if [[ -z "$SSID" ]]; then
    exit 1
fi

# Check if connection is already known
KNOWN=$(nmcli -t -f NAME con show | grep -Fx "$SSID")

if [[ -n "$KNOWN" ]]; then
    nmcli con up "$SSID"
    notify-send "Wi-Fi" "Connected to $SSID" -t 3000
    exit 0
fi

# If it's an open network
if [[ "$SECURITY" == "" || "$SECURITY" == "--" ]]; then
    nmcli dev wifi connect "$SSID"
    notify-send "Wi-Fi" "Connected to open network $SSID" -t 3000
    exit 0
fi

# Need password
PASSWORD=$(wofi --dmenu -p "Password for $SSID" --password --lines 1)

if [[ -z "$PASSWORD" ]]; then
    notify-send "Wi-Fi" "Connection to $SSID cancelled." -t 3000
    exit 1
fi

notify-send "Wi-Fi" "Connecting to $SSID..." -t 3000
if nmcli dev wifi connect "$SSID" password "$PASSWORD"; then
    notify-send "Wi-Fi" "Successfully connected to $SSID" -t 3000
else
    notify-send "Wi-Fi" "Failed to connect to $SSID" -u critical -t 5000
fi
