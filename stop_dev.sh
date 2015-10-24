#!/bin/bash

screen -X -S raintank quit
docker-compose -f fig-dev.yaml stop
yes | docker-compose -f fig-dev.yaml rm

# stop other collectors that were started, if any
for id in $(docker ps | grep raintankdocker_raintankCollector | cut -d' ' -f1); do
  docker stop $id
done

# assure no collectors images occupying the name, which can happen by stopped containers
for id in $(docker ps -a | grep raintankdocker_raintankCollector | cut -d' ' -f1); do
  docker rm -v $id
done

echo "Stopped docker dev environment"
