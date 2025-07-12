#!/bin/bash

SSID="$(iw wlan0 link| awk '/SSID/ {print $2}')"

GETOPTS_OUT=$(getopt -o s -l ssid,toggle -n "wifi.sh" -- "$@")
[[ $? != 0 ]] && exit 1
eval set -- "$GETOPTS_OUT"

while true; do
	case "$1" in
		-s | --ssid )
            echo "$SSID"
			shift ;;
		--toggle )
            ~/scripts/nettoggle.sh &>/dev/null
            shift ;;
        * )
            shift; break ;;
	esac
done
