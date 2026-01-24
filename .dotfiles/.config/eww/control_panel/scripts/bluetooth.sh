#!/bin/bash

DEVICE="$(bluetoothctl devices Connected| head -n+1| sed -e 's/^[^ ]\+ //')"

toggle_bluetooth() {
    if [[ -n "$DEVICE" ]]; then
        bluetoothctl disconnect
    else
        TARGET="$(bluetoothctl devices Paired| head -n+1| sed -e 's/^[^ ]\+//'| awk '{print $1}')"
        bluetoothctl connect "$TARGET"
    fi
}

print_device_name() {
    DISPLAY_NAME="$(echo "$DEVICE"| sed -e 's/^[^ ]\+ //')"
    # Eww's label word wrapping doesn't seem to work, so truncating the SSID manually
    # At most, place 7 chars on the first lines, followed by 4 on the second
    WRAP_LEN=7
    MAX_LEN=11
    NAME_LEN=$(echo "$DISPLAY_NAME"| wc --chars)
    if [[ $NAME_LEN -gt $WRAP_LEN ]]; then
        if [[ $NAME_LEN -gt $MAX_LEN ]]; then
            DISPLAY_NAME="${DISPLAY_NAME:0:7}\n${DISPLAY_NAME:7:4}..."
        else
            DISPLAY_NAME="${DISPLAY_NAME:0:7}\n${DISPLAY_NAME:7}"
        fi
    fi
    echo "$DISPLAY_NAME"
}

GETOPTS_OUT=$(getopt -o s -l status,toggle -n "bluetooth.sh" -- "$@")
[[ $? != 0 ]] && exit 1
eval set -- "$GETOPTS_OUT"

while true; do
	case "$1" in
		-s | --status )
            [ -n "$DEVICE" ]&& print_device_name
			shift ;;
		--toggle )
            toggle_bluetooth
            shift ;;
        * )
            shift; break ;;
	esac
done
