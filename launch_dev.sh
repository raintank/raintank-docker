#!/bin/bash
## Launch development environment using docker and screen.
#
# USAGE
#
#   ./launch.sh
#
# once it has completed, attach to the raintank screen session
#   screen -r raintank
#
# there will now be a screen window for each of the running components, and an additional screen window running a shell.
#

if screen -ls | grep -q '[0-9]\.raintank[[:space:]]'; then
  echo "Running devstack screen session detected!" >&2
  echo "You probably want to run ./stop_dev.sh first!" >&2
  exit 2
fi

echo "cleaning logs..."
rm -rf logs/*

echo "docker-compose bringing up containers..."
docker-compose -p raintank -f docker/fig-dev.yaml up -d || exit $?

echo "starting screen session..."
screen -S raintank -d -m -t shell bash

num=$(grep '^[a-z]' docker/fig-dev.yaml | wc -l)
while [ $(docker ps | grep -c raintank) -ne $num ]; do
  echo "waiting for all $num containers to run..."
  sleep 0.5
done

# wait for all docker containers to completely start.
# i still don't understand why this is needed (dieter) but AJ says he needs this :?
sleep 5

echo "starting screen tabs..."
for service in screens/*; do
  base=$(basename $service)
  if [ $base == measure ]; then
    screen -S raintank -X screen -t $base bash
  else
   screen -S raintank -X screen -t $base docker exec -t -i raintank_${base}_1 bash
  fi
  while read line; do
    screen -S raintank -p $(basename $service) -X stuff "$line\n"
  done < <(grep -v '^#' $service)
done

./docker/nodejsgo/wait.sh localhost:9200
D=$(( $(date +%s) * 1000))
payload='{"timestamp": '$D',"type": "devstack-start","tags": "start","text": "devstack started"}'
curl -s -X POST "localhost:9200/benchmark/event?" -d "$payload" >/dev/null

echo "adding demo1 agent to task-server...."
./docker/nodejsgo/wait.sh localhost:8082
curl -X POST  -H "content-type: json" -H "Authorization: Bearer not_very_secret_key" -d '{"id": 1, "name": "demo1", "enabled": true, "public": true}' http://localhost:8082/api/v1/agents

echo "starting collector..."
./launch_dev_collector.sh

echo "now it's time to:"
echo "screen -r raintank"
