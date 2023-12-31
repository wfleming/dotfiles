## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## binding to edit command line in EDITOR
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

## standard stuffs
export PAGER=less
export LC_CTYPE=en_US.UTF-8
export EDITOR="nvim"

eval $(dircolors ~/.config/dircolors)
