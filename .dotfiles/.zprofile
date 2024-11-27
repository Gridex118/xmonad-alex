clear

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    systemd-inhibit \
	--what=handle-power-key \
	--why="Restrict power key in Graphical environment" \
	startx &>/dev/null
    logout
fi
