# for boot2docker/docker machine
function docker-env {
  if command -v boot2docker > /dev/null 2>&1; then
    eval "$(boot2docker shellinit 2> /dev/null)"
  elif command -v docker-machine > /dev/null 2>&1; then
    eval "$(docker-machine env default)"
  fi
}
docker-env

function docker-cleanup {
  docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs docker rm
  docker images | fgrep "<none>" | awk '{print $3}' | xargs docker rmi
}
