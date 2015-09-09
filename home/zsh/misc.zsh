## smart urls
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

## standard stuffs
export PAGER=less
export LC_CTYPE=en_US.UTF-8
export EDITOR="vim"
export BUNDLER_EDITOR="subl"

# Add Go to path
export GOPATH="$HOME/projects/go"
export PATH="$PATH:$GOPATH/bin"

# nokogiri doesn't like building from homebrew libxml2
export NOKOGIRI_USE_SYSTEM_LIBRARIES=1

# for boot2docker/docker machine
if command -v boot2docker > /dev/null 2>&1; then
  eval "$(boot2docker shellinit 2> /dev/null)"
else
  eval "$(docker-machine env default)"
fi
