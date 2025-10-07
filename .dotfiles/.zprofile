clear

. ~/.zshenv
export EDITOR=/usr/bin/nvim

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    systemd-inhibit \
	    --what=handle-power-key \
	    --why="Restrict power key in Graphical environment" \
        niri --session &>/dev/null
    logout
fi
