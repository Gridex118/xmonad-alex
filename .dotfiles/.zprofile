export EDITOR=/usr/bin/nvim

if [ -z "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
    source /usr/local/bin/colors.sh
    echo -e "${BLUE}Starting GUI session for ${GREENUNDER}Alex Rosegrid${NC}"
    systemd-inhibit \
	    --what=handle-power-key \
	    --why="Restrict power key in Graphical environment" \
        niri-session -l 1>/dev/null
    logout
fi
