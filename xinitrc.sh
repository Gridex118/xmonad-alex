#!/bin/bash

#########################
WM="~/.cache/xmonad/xmonad-x86_64-linux"

#########################
if [ -f ~/.xinitrc ]; then
    mv ~/.xinitrc ~/old.xinitrc
fi

#########################
echo "# Set up input devices" >> ~/.xinitrc
TOUCHPAD_ID="$(\
    xinput | grep -i 'touch' \
    | awk -F'=' '{print $2}' | awk '{print $1}' \
)"
ACCEL_PROP_ID="$(\
    xinput list-props $TOUCHPAD_ID | grep -i 'accel speed (' \
    | awk -F'(' '{print $2}' | awk -F')' '{print $1}' \
)"
TAP_PROP_ID="$(\
    xinput list-props $TOUCHPAD_ID | grep -i 'tapping enabled (' \
    | awk -F'(' '{print $2}' | awk -F')' '{print $1}' \
)"
echo "xinput set-prop $TOUCHPAD_ID $ACCEL_PROP_ID 0.55" >> ~/.xinitrc
echo "xinput set-prop $TOUCHPAD_ID $TAP_PROP_ID 1" >> ~/.xinitrc
echo "xset r rate 310 30" >> ~/.xinitrc
echo "" >> ~/.xinitrc

#########################
echo "# Set screen saver at 30 minutes" >> ~/.xinitrc
echo "xset s 3000 3000" >> ~/.xinitrc
echo "xset dpms 3000 3000 3000" >> ~/.xinitrc
echo "" >> ~/.xinitrc

#########################
echo "# XKB Options" >> ~/.xinitrc
echo "setxkbmap -option caps:swapescape" >> ~/.xinitrc
echo "setxkbmap -option altwin:swap_lalt_lwin" >> ~/.xinitrc
echo "setxkbmap -option ctrl:menu_rctrl" >> ~/.xinitrc
echo "" >> ~/.xinitrc

#########################
echo "# start some nice programs" >> ~/.xinitrc
echo "if [ -d /etc/X11/xinit/xinitrc.d ] ; then" >> ~/.xinitrc
echo "    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do" >> ~/.xinitrc
echo "    [ -x \"\$f\" ] && . \"\$f\"" >> ~/.xinitrc
echo "    done" >> ~/.xinitrc
echo "    unset f" >> ~/.xinitrc
echo "fi" >> ~/.xinitrc
echo "" >> ~/.xinitrc

#########################
echo "# Decoration" >> ~/.xinitrc
echo "nitrogen --restore&" >> ~/.xinitrc
echo "xsetroot -cursor_name left_ptr" >> ~/.xinitrc
echo "xrdb ~/.Xresources" >> ~/.xinitrc
echo "unclutter&" >> ~/.xinitrc

#########################
echo "# Xss lock" >> ~/.xinitrc
echo "xss-lock --transfer-sleep-lock -- ~/.local/bin/transfer-sleep-lock-generic-delay.sh --nofork&" >> ~/.xinitrc

#########################
echo "# Start WM" >> ~/.xinitrc
echo "exec $WM" >> ~/.xinitrc

