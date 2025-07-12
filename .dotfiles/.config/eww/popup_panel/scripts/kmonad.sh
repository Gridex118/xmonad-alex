#!/bin/bash

STATUS="off"

if xinput | grep -iqP "kmonad.*internal"; then
    STATUS="Internal"
elif xinput | grep -iqP "kmonad"; then
    STATUS="External"
fi

GETOPTS_OUT=$(getopt -o s -l status,toggle,toggle-in-ext -n "kmonad.sh" -- "$@")
[[ $? != 0 ]] && exit 1
eval set -- "$GETOPTS_OUT"

while true; do
	case "$1" in
		-s | --status )
            echo "$STATUS"
			shift ;;
		--toggle )
            if [[ "$STATUS" = "off" ]]; then
                ~/scripts/kmonad-init.sh &>/dev/null
            else
                killall kmonad
            fi
            shift ;;
		--toggle-in-ext )
            if [[ "$STATUS" = "External" ]]; then
                killall kmonad
                ~/scripts/kmonad-init.sh --force-use-internal &>/dev/null
            else
                killall kmonad
                ~/scripts/kmonad-init.sh &>/dev/null
            fi
            shift ;;
        * )
            shift; break ;;
	esac
done
