#!/bin/bash

try_connecting () {
    for network in $(cat ~/.networks); do
        iwctl station wlan0 connect $network \
            && notify-send "Connected to $network" \
            && exit 0
    done
}

if iw dev wlan0 link| grep "SSID" &>/dev/null; then
    SSID="$(iw dev wlan0 link| awk -F': ' '/SSID/{print $2}')"
    iwctl station wlan0 disconnect
    notify-send "Disconnected from $SSID"
    unset SSID
else
    iwctl station wlan0 scan on
    sleep 0.5
    if [[ -f ~/.networks ]]; then
        for i in {1..3}; do
            try_connecting
            sleep 0.2
        done
    else
        notify-send "Required: a ~/.networks file, as a list of known networks (newline separated)"
        alacritty -e iwctl
    fi
fi
