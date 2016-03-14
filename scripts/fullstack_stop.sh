#!/bin/bash

BASE=$(dirname $0)

# important: if you change this, you must also update fig-dev.yaml accordingly
RT_CODE=$(readlink -e "$BASE/../raintank_code")
RT_LOGS=$(readlink -e "$BASE/../logs")
COMPOSE_BASE=$(readlink -e "$BASE/../")


if [ -n "$STY" ]; then
  echo "don't run this script in the screen session" >&2
  exit 2
fi

screen -X -S raintank quit
docker-compose -f $COMPOSE_BASE/compose-statsd.yaml -p rt stop
docker-compose -f $COMPOSE_BASE/compose-tsdb.yaml -p rt stop
docker-compose -f $COMPOSE_BASE/compose-task.yaml -p rt stop
docker-compose -f $COMPOSE_BASE/compose-grafana.yaml -p rt stop
yes | docker-compose -f $COMPOSE_BASE/compose-statsd.yaml -p rt rm
yes | docker-compose -f $COMPOSE_BASE/compose-tsdb.yaml -p rt rm
yes | docker-compose -f $COMPOSE_BASE/compose-task.yaml -p rt rm
yes | docker-compose -f $COMPOSE_BASE/compose-grafana.yaml -p rt rm

# stop other collectors that were started, if any
for id in $(docker ps | grep rt_raintankCollector | cut -d' ' -f1); do
  docker stop $id
done

# assure no collectors images occupying the name, which can happen by stopped containers
for id in $(docker ps -a | grep rt_raintankCollector | cut -d' ' -f1); do
  docker rm -v $id
done

echo "Stopped docker apps environment"
