#!/bin/bash

screen -X -S raintank quit
docker-compose -f fig-dev.yaml stop
yes | docker-compose -f fig-dev.yaml rm

# stop other collectors that were stopped, if any
for id in $(docker ps | grep raintankdocker_raintankMetric | cut -d' ' -f1); do
  docker stop $id
  docker rm $id
done

echo "Stopped docker dev environment"
