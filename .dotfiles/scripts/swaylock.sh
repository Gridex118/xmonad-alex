#!/bin/bash

BG_IMAGE="$HOME/Wallpapers/arknights_texas.png"

if pgrep -x swaylock &>/dev/null; then
    killall swaylock
fi

swaylock --image "$BG_IMAGE"
