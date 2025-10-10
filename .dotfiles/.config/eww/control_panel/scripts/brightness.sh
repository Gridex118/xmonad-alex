#!/bin/bash

BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/brightness"
MAX_BRIGHTNESS_FILE="/sys/class/backlight/intel_backlight/max_brightness"

CURRENT_BRIGHTNESS="$(echo "$(cat $BRIGHTNESS_FILE) * 100 / $(cat $MAX_BRIGHTNESS_FILE)"| bc)"

SET_BRIGHTNESS=

GETOPTS_OUT=$(getopt -o g,s -l get,set -n "brightness.sh" -- "$@")
[[ $? != 0 ]] && exit 1
eval set -- "$GETOPTS_OUT"

while true; do
	case "$1" in
		-g | --get )
            echo "$CURRENT_BRIGHTNESS"
			shift ;;
		-s | --set )
            SET_BRIGHTNESS=1
            shift ;;
        * )
            shift; break ;;
	esac
done

if [[ $SET_BRIGHTNESS -eq 1 ]]; then
    CURRENT_BRIGHTNESS="$1"
    echo "$CURRENT_BRIGHTNESS * $(cat $MAX_BRIGHTNESS_FILE) / 100"| bc > $BRIGHTNESS_FILE
fi
