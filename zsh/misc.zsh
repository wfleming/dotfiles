## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## standard stuffs
export PAGER=less
export LC_CTYPE=en_US.UTF-8
export EDITOR="subl -w"

## chrome is used for JS tests, esp. testacular with node
export CHROME_BIN="~/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
