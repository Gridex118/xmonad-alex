#!/bin/bash

STATUS="off"

if libinput list-devices | grep -q "Kanata-Alex" ; then
    STATUS="Kanata"
fi

GETOPTS_OUT=$(getopt -o s -l status,toggle -n "kanata.sh" -- "$@")
[[ $? != 0 ]] && exit 1
eval set -- "$GETOPTS_OUT"

while true; do
	case "$1" in
		-s | --status )
            echo "$STATUS"
			shift ;;
		--toggle )
            if [[ "$STATUS" = "off" ]]; then
                ~/scripts/kanata-init.sh &>/dev/null
            else
                killall kanata
            fi
            shift ;;
        * )
            shift; break ;;
	esac
done
