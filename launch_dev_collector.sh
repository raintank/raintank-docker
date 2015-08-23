#!/bin/bash

# launch a collector with an auto-assigned id, based on an incrementing counter, and hook it into the screen session
# don't run this script concurrently

highest=$(docker ps | grep raintankdocker_raintankCollector_dev | sed 's#.*raintankdocker_raintankCollector_dev##' | sort -n | tail -n 1)
docker ps | grep raintankdocker_raintankCollector_dev
# if no containers yet, start at 1
[ -z "$highest" ] && highest=0
id=dev$((highest+1))

docker_name=raintankdocker_raintankCollector_$id

eval $(grep ^RT_CODE setup_dev.sh)

docker run --link=raintankdocker_grafana_1:grafana \
           -v $RT_CODE/raintank-collector:/opt/raintank/raintank-collector \
           -e RAINTANK_collector_name=$id -d \
           --name=$docker_name \
           raintank/collector

screen -S raintank -X screen -t collector-$id docker exec -t -i $docker_name bash
screen -S raintank -p collector-$id -X stuff 'supervisorctl restart all; touch /var/log/raintank/collector.log\n'
screen -S raintank -p collector-$id -X stuff 'tail -10f /var/log/raintank/collector.log\n'
