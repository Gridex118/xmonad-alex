# XMonad-Alex :: XMonad
These are the dots for my XMonad installation, xmonad-alex; so that I can reproduce it easily when
changing systems.

## Installation Dependencies, for the WM
- **git**: If you're here, you probably already have it installed.
- **Haskell**: I recommend you install the all the tools provided under `ghcup`. This configuration
  uses `cabal`, rather than using the `xmonad` package provided by any particular Linux distribution.
  
## UI Applications
- **XMobar**: for the top/status bar
- **Picom**: as the compositor; I use the one available in the official Arch Linux *extra* repository.
- **Conky**: for resource monitoring
- **Nitrogen**: for the wallpaper
- **notification-daemon**: I mean, its in the name
- **Redshift**: to not make my eyes hurt
- **Unclutter**: to not have to stare at the mouse pointer
- **Rofi**: as the application launcher

## Other Applications
- **emacs**: as the text editor
- **Alacritty**: as the primary terminal emulator
- **Wezterm**: when I wish to see the light
- **Firefox**: as the web browser
- **Zathura**: as the primary pdf viewer
- **zsh**: as the shell

## Usage Directions
1. `git clone` this repository to your `$HOME` directory.
2. In the root folder, run `stow .dotfiles` from the command line. This will create the necessary
   symlinks (*yes, you need to install `stow` separately).  
   *Note, you should probably create most of the directories yourself, especially ones
   like `.config`, `.config/xmoand`, and `.emacs` since a lot of the files in these directories
   really don't need to be tracked(and adding those files to `.gitignore` is a pain).*

### XMonad Installation
1. The first thing to do is getting a working Haskell installation. Check
   [here](https://www.haskell.org/ghcup/install/) for the required script. Also add `~/.cabal/bin`
   and `~/.ghcup/bin` to your `$PATH`(maybe using `.zshenv`).
2. Look [here](https://xmonad.org/INSTALL.html) for the packages required for installation. Last I
   checked, the command you need for Arch was,
   ```sh
   sudo pacman -Syu \
   git \
   xorg-server xorg-apps xorg-xinit xorg-xmessage \
   libx1 libxft libxinerama libxrandr libxss \
   pkgconf
   ```
3. `cd` to `.config/xmoand`, and run
   ```sh
   cabal update
   cabal build
   cabal install
   ```
   to build the package. This should add the binary's symlink in `~/.cabal/bin`.  
4. Install `xmobar` from Hackage: `cabal install xmobar`.
5. Symlink the executable, since the recompile keybinds assume that your executable is named
   `xmoand`, and I never really found out how to change that(if it can be changed).
   ```sh
   xmonad-alex --recompile
   ln -s ~/.cache/xmonad/xmoand-x86_64-linux ~/.local/bin/xmonad
   ```
   
