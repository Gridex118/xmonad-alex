#!/bin/bash

STATUS_FILE=/tmp/current-variant

[ -f $STATUS_FILE ] || echo "qwerty" > $STATUS_FILE

CURRENT_VARIANT="$(cat $STATUS_FILE)"
if [[ $CURRENT_VARIANT = "qwerty" ]]; then
    notify-send -t 300 "Switching to DVORAK"
    setxkbmap -variant dvorak
    echo "dvorak" > $STATUS_FILE
elif [[ $CURRENT_VARIANT = "dvorak" ]]; then
    notify-send -t 300 "Switching to colemak Mod-DH"
    setxkbmap -variant colemak_dh
    echo "colemak-dh" > $STATUS_FILE
elif [[ $CURRENT_VARIANT = "colemak-dh" ]]; then
    notify-send -t 300 "Switching to QWERTY"
    setxkbmap us
    echo "qwerty" > $STATUS_FILE
fi

unset CURRENT_VARIANT
unset STATUS_FILE
