#!/bin/bash

if ! playerctl play-pause &>/dev/null; then
    ~/scripts/mpvmusic.sh
fi
