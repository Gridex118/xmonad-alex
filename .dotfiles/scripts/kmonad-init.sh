#!/bin/zsh

if [[ -n "$(pgrep 'kmonad$')" ]]; then
    killall kmonad
fi

# Canonicalize the args
GETOPTS_OUT=$(getopt -o iI -l use-internal,force-use-internal -n "kmonad-init.sh" -- "$@")
if [[ $? != 0 ]]; then
	echo "getopts gave error; aborting" >&2
	exit 1
fi
eval set -- "$GETOPTS_OUT"

# Setup Variables
USE_INTERNAL=0    # Do not look for external keyboards if asked for internal

while true; do
	case "$1" in
		-i | --use-internal )
			USE_INTERNAL=1
			shift ;;
		-I | --force-use-internal )
			USE_INTERNAL=2
			shift ;;
		* ) shift; break ;;
	esac
done

# Setup keyboard device

if [[ $USE_INTERNAL -eq 0 ]]; then
	KBD_DEVICE="$1"
	if [[ -z "$KBD_DEVICE" ]]; then
		echo "No device file was specified; will look for an input device: *-kbd"
		KBD_DEVICE="$(find /dev/input/by-id/ -name '*kbd'| awk 'NR==1 {print $0}')"
	fi
	# If a keyboard device was specified, or was found, start KMonad using it
	if [[ -n "$KBD_DEVICE" ]]; then
		echo "Using $KBD_DEVICE as keyboard device (making a copy of the previous config)"
		cp ~/.config/kmonad/kmonad-alex.kbd ~/.config/kmonad/kmonad-alex.kbd.old
		sed -i "s|/dev/input/by-id/[^\"]*|$KBD_DEVICE|" ~/xmonad-alex/.dotfiles/.config/kmonad/kmonad-alex.kbd
		(~/.local/bin/kmonad ~/.config/kmonad/kmonad-alex.kbd &)
	else
		echo "No extenal keyboard device was found; aborting"
		echo "You might want to try the --use-internal flag"
	fi
else
    echo "Checking for an internal keyboard"
	# Working under the assumption that a laptop's internal keyboard is called "AT Translated Set 2"
	INTERNAL_KBD_DEVICE="$(journalctl -b -1| grep -i 'at translated set 2'| grep -i 'watching.*on'| sed -E 's|.*(/dev/.*) \(.*\)|\1|')"
	if [[ -n "$INTERNAL_KBD_DEVICE" ]]; then
		echo "$INTERNAL_KBD_DEVICE will be used"
		cp ~/.config/kmonad/kmonad-alex.kbd ~/.config/kmonad/kmonad-alex-internal.kbd
		sed -i "s|/dev/input/by-id/[^\"]*|$INTERNAL_KBD_DEVICE|" ~/.config/kmonad/kmonad-alex-internal.kbd
		sed -i "s/KMonad Alex/Kmonad Alex Laptop Internal Keyboard/" ~/.config/kmonad/kmonad-alex-internal.kbd
		# Patch the file to fix some keybindings
		PATCH_FILE="$HOME/scripts/internal.patch"
		cat $PATCH_FILE
        if [[ $USE_INTERNAL -eq 1 ]]; then
		    echo "Should these changes be made?[Ctrl-c to abort, ENTER to continue]"&& read
        fi
		patch -b -i $PATCH_FILE ~/.config/kmonad/kmonad-alex-internal.kbd
		(~/.local/bin/kmonad ~/.config/kmonad/kmonad-alex-internal.kbd &)
	else
		echo "Nothing appropriate was found"
		echo "You might want to try specifying a device name manually"
		exit 1
	fi
fi
