#!/usr/bin/env bash

# Fetch the wifi list, format as JSON for eww
# nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list

nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY dev wifi list | awk -F':' '
BEGIN {
    print "["
    first = 1
}
{
    in_use = ($1 == "*") ? "true" : "false"
    ssid = $2
    signal = $3
    security = $4
    
    # skip empty SSIDs
    if (ssid == "") next
    
    # Escape quotes
    gsub(/"/, "\\\"", ssid)
    gsub(/"/, "\\\"", security)
    
    if (!first) {
        print ","
    }
    first = 0
    
    printf "  {\"in_use\": %s, \"ssid\": \"%s\", \"signal\": \"%s\", \"security\": \"%s\"}", in_use, ssid, signal, security
}
END {
    print "\n]"
}'
