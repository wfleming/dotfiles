## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## standard stuffs
export PAGER=less
export LC_CTYPE=en_US.UTF-8
export EDITOR="vim"
export BUNDLER_EDITOR="subl"

export GOPATH="$HOME/projects/go"
export PATH="$PATH:$GOPATH/bin"

# Docker Daemon needs this (http://docs.docker.io/en/latest/installation/mac/)
export DOCKER_HOST=tcp://

# nokogiri doesn't like building from homebrew libxml2
export NOKOGIRI_USE_SYSTEM_LIBRARIES=1

# for Mint BloomBox
export PATH="$PATH:/usr/local/bloombox/bin"

eval "$(boot2docker shellinit)"
