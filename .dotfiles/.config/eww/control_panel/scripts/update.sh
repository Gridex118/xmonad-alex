#!/bin/bash

UPDATES_RUNNING=0

if niri msg windows| grep -q "PopupPanelUpdateWindow"; then
    UPDATES_RUNNING=1
fi

GETOPTS_OUT=$(getopt -o rs -l run,status -n "update.sh" -- "$@")
[[ $? != 0 ]] && exit 1
eval set -- "$GETOPTS_OUT"

while true; do
	case "$1" in
		-r | --run )
            alacritty --hold --class "PopupPanelUpdateWindow" -e sudo /usr/local/bin/sync-and-update.sh --ask
            exit 0 ;;
        -s | --status )
            echo "$UPDATES_RUNNING"
            shift ;;
        * )
            shift; break ;;
	esac
done
