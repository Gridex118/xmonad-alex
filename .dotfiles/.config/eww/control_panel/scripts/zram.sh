#!/bin/bash

# Assume that the machine swaps on only a single ZRam disk
ZRAM_USED="$(swapon| awk '/zram/ {print $4}')"

GETOPTS_OUT=$(getopt -o tu -l toggle,used -n "zram.sh" -- "$@")
[[ $? != 0 ]] && exit 1
eval set -- "$GETOPTS_OUT"

while true; do
	case "$1" in
		-t | --toggle )
            if [[ -z $ZRAM_USED ]];then
                sudo /usr/local/bin/initzram.sh &>/dev/null
            else
                sudo /usr/local/bin/initzram.sh -k &>/dev/null
            fi
            shift ;;
        -u | --used )
            echo "$ZRAM_USED"
            shift ;;
        * )
            shift; break ;;
	esac
done
