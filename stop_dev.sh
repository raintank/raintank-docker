#!/bin/bash

screen -X -S raintank quit
docker-compose -f fig-dev.yaml stop
yes | docker-compose -f fig-dev.yaml rm
echo "Stopped docker dev environment"
