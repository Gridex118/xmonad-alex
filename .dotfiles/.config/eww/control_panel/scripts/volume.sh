#!/bin/bash

SINK="$(pactl list sinks| grep 'Sink #'| grep -o '[0-9]*')"

GETOPTS_OUT=$(getopt -o gs -l get,set -n "volume.sh" -- "$@")
[[ $? != 0 ]] && exit 1
eval set -- "$GETOPTS_OUT"

SET_VOLUME=0

while true; do
	case "$1" in
        -g | --get )
            CURRENT_VOLUME=$(pactl get-sink-volume $SINK \
                                 | awk -F',' 'NR==1 {print $1}' \
                                 | grep -o "[0-9]*%" \
                                 | tr -d ' ' \
                                 | tr -d '%')
            echo "$CURRENT_VOLUME"
            shift ;;
        -s | --set )
            SET_VOLUME=1
            shift ;;
        * )
            shift; break ;;
	esac
done

if [[ $SET_VOLUME -eq 1 ]]; then
    pactl set-sink-volume $SINK "$1"%
fi
