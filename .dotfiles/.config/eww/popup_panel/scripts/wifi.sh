#!/bin/bash

SSID="$(iw wlan0 link| awk '/SSID/ {print $2}')"

# Eww's label word wrapping doesn't seem to work, so truncating the SSID manually
# At most, place 7 chars on the first lines, followed by 4 on the second
WRAP_LEN=7
MAX_LEN=11
SSID_LEN=$(echo $SSID| wc --chars)
if [[ $SSID_LEN -gt $WRAP_LEN ]]; then
    if [[ $SSID_LEN -gt $MAX_LEN ]]; then
        SSID="${SSID:0:7}\n${SSID:7:4}..."
    else
        SSID="${SSID:0:7}\n${SSID:7}"
    fi
fi

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
