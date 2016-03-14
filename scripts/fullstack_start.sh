#!/bin/bash
## Launch development environment using docker and screen.
#
# USAGE
#
#   ./fullstack_start.sh [-d container[,container]] 
#
# -d takes a comma separated list of containers to run in dev mode.
#     eg. ./fullstack_start.sh -d grafana,metricTank
# once it has completed, attach to the raintank screen session
#   screen -r raintank
#
# there will now be a screen window for each of the running components, and an additional screen window running a shell.
#

BASE=$(dirname $0)

DEVMODE=0
DEVCONTAINERS=""

if [ ! -z "$1" ]; then
  if [ "$1" != "-d" ]; then
    echo "invalid argument."
    exit 1
  fi
  if [ ! -z $2 ]; then
    DEVMODE=1
    DEVCONTAINERS=$2
  fi
fi

# important: if you change this, you must also update fig-dev.yaml accordingly
RT_CODE=$(readlink -e "$BASE/../raintank_code")
RT_LOGS=$(readlink -e "$BASE/../logs")
COMPOSE_BASE=$(readlink -e "$BASE/../compose")

if screen -ls | grep -q '[0-9]\.raintank[[:space:]]'; then
  echo "Running devstack screen session detected!" >&2
  echo "You probably want to run ./stop_dev.sh first!" >&2
  exit 2
fi

echo "cleaning logs..."
rm -rf $RT_LOGS/*

echo "docker-compose bringing up containers..."
docker-compose -f $COMPOSE_BASE/compose-statsd.yaml -p rt up -d || exit $?
docker-compose -f $COMPOSE_BASE/compose-tsdb.yaml -p rt up -d || exit $?
docker-compose -f $COMPOSE_BASE/compose-task.yaml -p rt up -d || exit $?
docker-compose -f $COMPOSE_BASE/compose-grafana.yaml -p rt up -d || exit $?

num=$(grep 'image:' $COMPOSE_BASE/compose-{tsdb,grafana,statsd,task}.yaml | wc -l)
while [ $(docker ps | grep -c rt_) -ne $num ]; do
  echo "waiting for all $num containers to run..."
  sleep 0.5
done

echo "starting screen session..."
screen -S raintank -d -m -t shell bash

# wait for all docker containers to completely start.
# i still don't understand why this is needed (dieter) but AJ says he needs this :?
sleep 5
containers=$(docker ps |awk '{print $NF}'|grep -v NAMES)
echo "starting screen tabs..."
for service in $BASE/../screens/*; do
  base=$(basename $service)
  if echo $containers|grep rt_${base}_1 >/dev/null; then
    if [ $base == measure ]; then
      screen -S raintank -X screen -t $base bash
    else
     screen -S raintank -X screen -t $base docker exec -t -i rt_${base}_1 bash
    fi
    while read line; do
      screen -S raintank -p $(basename $service) -X stuff "$line\n"
    done < $service
  fi
done

$BASE/wait.sh localhost:9200
D=$(( $(date +%s) * 1000))
payload='{"timestamp": '$D',"type": "devstack-start","tags": "start","text": "devstack started"}'
curl -s -X POST "localhost:9200/benchmark/event?" -d "$payload" >/dev/null

$BASE/wait.sh localhost:3000
$BASE/dashboards/create-datasource.sh

echo "starting agent..."
#$BASE/launch_dev_agent.sh

echo "now it's time to:"
echo "screen -r raintank"
