#!/bin/bash

try_connecting () {
    for network in $(cat ~/.networks); do
        iwctl station wlan0 connect $network&& notify-send "Connected to $network"&& exit 0
    done
}

if iw dev wlan0 link| grep "SSID" &>/dev/null; then
    iwctl station wlan0  disconnect
else
    iwctl station wlan0 scan on
    if [[ -f ~/.networks ]]; then
        for i in {1..2}; do try_connecting; done
    else
        notify-send "Required: a ~/.networks file, as a list of known networks (newline separated)"
        alacritty -e iwctl
    fi
fi
