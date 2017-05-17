## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## standard stuffs
export PAGER=less
export LC_CTYPE=en_US.UTF-8
export EDITOR="nvim"

export LS_COLORS="$LS_COLORS:di=00;33"
