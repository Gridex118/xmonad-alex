HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd histignorespace

autoload -Uz compinit
compinit

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

vterm_printf() {
    if [ -n "$TMUX" ] \
        && { [ "${TERM%%-*}" = "tmux" ] \
            || [ "${TERM%%-*}" = "screen" ]; }; then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

source ~/.zsh/themes/p10k/powerlevel10k.zsh-theme
source ~/.zsh/lib/zsh-autosuggestions.zsh
source ~/.zsh/.zalias
source ~/.zsh/.zkeys
