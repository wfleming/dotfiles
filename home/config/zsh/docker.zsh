function docker-cleanup {
  docker ps -a | grep --extended-regexp " (weeks|months) ago " | \
    grep -v " Up " | awk '{print $1}' | xargs --no-run-if-empty docker rm
  docker images | grep --fixed-strings "<none>" | awk '{print $3}' | \
    xargs --no-run-if-empty docker rmi
}
