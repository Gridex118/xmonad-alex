#!/bin/bash

BG_IMAGE_DIR="$HOME/Wallpapers/PGR_rotate"
BG_IMAGE="${BG_IMAGE_DIR}/$(ls $BG_IMAGE_DIR| shuf -n1)"

if pgrep -x swaylock &>/dev/null; then
    killall swaylock
fi

swaylock --image "$BG_IMAGE"
