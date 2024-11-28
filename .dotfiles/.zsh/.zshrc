HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd histignorespace

autoload -Uz compinit
compinit

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

source ~/.zsh/themes/p10k/powerlevel10k.zsh-theme
source ~/.zsh/lib/zsh-autosuggestions.zsh
source ~/.zsh/.zalias
source ~/.zsh/.zkeys
