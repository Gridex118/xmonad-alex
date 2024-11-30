#!/bin/bash

# Preliminary Check
if [ ! -e ~/xmonad-alex ]; then
    echo "Expected ~/xmonad-alex to be present; aborting"
    exit -1
fi

# Create the relevant directories, if they aren't already there. 
[ -d ~/.emacs.d ] || mkdir ~/.emacs.d
[ -d ~/.config ] || mkdir ~/.config
[ -d ~/.config/xmonad ] || mkdir ~/.config/xmonad
[ -d ~/.config/zathura ] || mkdir ~/.config/zathura
# For all the other directories, it's more convenient to have git track them completely

# Making the symlinks
cd ~/xmonad-alex
stow .dotfiles
