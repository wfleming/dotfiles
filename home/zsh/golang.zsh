# Add Go to path
export GOPATH="$HOME/projects/go"
export PATH="$PATH:$GOPATH/bin"
export GO15VENDOREXPERIMENT=1

# for boot2docker/docker machine
if command -v boot2docker > /dev/null 2>&1; then
  eval "$(boot2docker shellinit 2> /dev/null)"
else
  eval "$(docker-machine env default)"
fi

function docker_cleanup {
  docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs docker rm
  docker images | fgrep "<none>" | awk '{print $3}' | xargs docker rmi
}
