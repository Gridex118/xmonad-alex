#!/usr/bin/env bash

NIRI_TOUCHPAD_FILE=~/.config/niri/touchpad.kdl

if [ -f "$NIRI_TOUCHPAD_FILE" ]; then
    if grep 'off' "$NIRI_TOUCHPAD_FILE" &>/dev/null; then
        notify-send "Touchpad Toggled On"
        sed -i 's_off_// ON_' "$NIRI_TOUCHPAD_FILE"
    elif grep '// ON' "$NIRI_TOUCHPAD_FILE" &>/dev/null; then
        notify-send "Touchpad Toggled Off"
        sed -i 's_// ON_off_' "$NIRI_TOUCHPAD_FILE"
    fi
fi
