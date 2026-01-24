#!/bin/bash

SINK_NAME="Nirvana Ion ANC"
SINK_ID=$($HOME/scripts/wpctl_audio_sinks.py -n "$SINK_NAME")

GETOPTS_OUT=$(getopt -o gs -l get,set -n "volume.sh" -- "$@")
[[ $? != 0 ]] && exit 1
eval set -- "$GETOPTS_OUT"

SET_VOLUME=0

while true; do
	case "$1" in
        -g | --get )
            CURRENT_VOLUME=$(wpctl get-volume $SINK_ID \
                                 | awk -F':' '{print $2}' \
                                 | tr -d ' ')
            CURRENT_VOLUME=$(bc <<< "$CURRENT_VOLUME * 100")
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
    wpctl set-volume $SINK_ID "$1"%
fi
