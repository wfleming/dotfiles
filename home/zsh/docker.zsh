function docker-cleanup {
  docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs docker rm
  docker images | fgrep "<none>" | awk '{print $3}' | xargs docker rmi
}
