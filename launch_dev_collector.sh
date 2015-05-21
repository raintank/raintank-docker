#!/bin/bash

# launch a collector with the given identifier (or a randomly generated one), and hook it into the screen session

id=$1
[ -n "$id" ] || id=$(mktemp -u XXXXXXXXXXX)
docker_name=raintankdocker_raintankCollector_$id

eval $(grep ^RT_CODE setup_dev.sh)

docker run --link=raintankdocker_grafana_1:grafana \
           -v $RT_CODE/raintank-collector:/opt/raintank/raintank-collector \
           -e RAINTANK_collector_name=$id -d \
           --name=$docker_name \
           raintank/collector

screen -S raintank -X screen -t collector-$id docker exec -t -i $docker_name bash
screen -S raintank -p collector-$id -X stuff 'supervisorctl restart all; tail -10f /var/log/raintank/collector.log\n'
