## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## standard stuffs
export PAGER=less
export LC_CTYPE=en_US.UTF-8
export EDITOR="vim"
export BUNDLE_EDITOR="atom"

## PhantomJS needs chrome path sometimes
export CHROME_BIN="$HOME/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

# Docker Daemon needs this (http://docs.docker.io/en/latest/installation/mac/)
export DOCKER_HOST=tcp://
