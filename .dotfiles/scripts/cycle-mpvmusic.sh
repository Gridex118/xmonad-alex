#!/bin/bash

if [[ -S /tmp/mpvmusic ]]; then
    echo "cycle pause"| socat -U /tmp/mpvmusic -
fi
