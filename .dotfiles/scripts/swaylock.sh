#!/bin/bash

BG_IMAGE="$HOME/Wallpapers/lockscreen.png"

if pgrep -x swaylock &>/dev/null; then
    killall swaylock
fi

swaylock --image "$BG_IMAGE"
