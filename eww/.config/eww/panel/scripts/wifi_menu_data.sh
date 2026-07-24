#!/usr/bin/env bash

# Fetch the wifi list, format as JSON for eww
# nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list

nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list | awk -F':' '
BEGIN {
    print "["
    first = 1
}
{
    ssid = $1
    signal = $2
    security = $3
    
    # skip empty SSIDs
    if (ssid == "") next
    
    # Escape quotes
    gsub(/"/, "\\\"", ssid)
    gsub(/"/, "\\\"", security)
    
    if (!first) {
        print ","
    }
    first = 0
    
    printf "  {\"ssid\": \"%s\", \"signal\": \"%s\", \"security\": \"%s\"}", ssid, signal, security
}
END {
    print "\n]"
}'
