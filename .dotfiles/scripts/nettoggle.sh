#!/bin/bash

if [[ $(iw dev wlan0 info| grep "ssid" -c) -eq 0 ]]; then
    iwctl station wlan0 scan on
    sleep 2
    if [[ -f ~/.networks ]]; then
        for network in $(cat ~/.networks); do
            iwctl station wlan0 connect $network&& notify-send "Connect to $network"&& exit 0
        done
    else
        notify-send "Required: a ~/.networks file, as a list of known networks (newline separated)"
        alacritty -e iwctl
    fi
else
    iwctl station wlan0  disconnect
fi
