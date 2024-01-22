HISTFILE=$HOME/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

setopt inc_append_history # append immediately
setopt extended_history # store timestops
setopt hist_expire_dups_first
setopt hist_ignore_space

setopt SHARE_HISTORY
setopt APPEND_HISTORY
