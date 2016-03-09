#!/bin/bash
## Launch development environment using docker and screen.
#
# USAGE
#
#   ./launch_apps.sh
#
# once it has completed, attach to the raintank screen session
#   screen -r raintank
#
# there will now be a screen window for each of the running components, and an additional screen window running a shell.
#

BASE=$(dirname $0)

# important: if you change this, you must also update fig-dev.yaml accordingly
RT_CODE=$(readlink -e "$BASE/../raintank_code")
RT_LOGS=$(readlink -e "$BASE/../logs")
COMPOSE_FILE=$(readlink -e "$BASE/../compose-apps.yaml")

if screen -ls | grep -q '[0-9]\.raintank[[:space:]]'; then
  echo "Running devstack screen session detected!" >&2
  echo "You probably want to run ./stop_dev.sh first!" >&2
  exit 2
fi

echo "cleaning logs..."
rm -rf $RT_LOGS/*

echo "docker-compose bringing up containers..."
docker-compose -f $COMPOSE_FILE -p rt up -d || exit $?

echo "starting screen session..."
screen -S raintank -d -m -t shell bash

num=$(grep ':image' $COMPOSE_FILE | wc -l)
while [ $(docker ps | grep -c rt_) -ne $num ]; do
  echo "waiting for all $num containers to run..."
  sleep 0.5
done

# wait for all docker containers to completely start.
# i still don't understand why this is needed (dieter) but AJ says he needs this :?
sleep 5

echo "starting screen tabs..."
for service in $BASE/../screens/*; do
  base=$(basename $service)
  if [ $base == measure ]; then
    screen -S raintank -X screen -t $base bash
  else
   screen -S raintank -X screen -t $base docker exec -t -i rt_${base}_1 bash
  fi
  while read line; do
    screen -S raintank -p $(basename $service) -X stuff "$line\n"
  done < $service
done

$BASE/wait.sh localhost:9200
D=$(( $(date +%s) * 1000))
payload='{"timestamp": '$D',"type": "devstack-start","tags": "start","text": "devstack started"}'
curl -s -X POST "localhost:9200/benchmark/event?" -d "$payload" >/dev/null

$BASE/wait.sh localhost:80
$BASE/dashboards/create-datasource.sh

echo "starting agent..."
#$BASE/launch_dev_agent.sh

echo "now it's time to:"
echo "screen -r raintank"
