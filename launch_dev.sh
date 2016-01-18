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
docker-compose -f fig-dev.yaml up -d || exit $?

echo "starting screen session..."
screen -S raintank -d -m -t shell bash

num=$(grep '^[a-z]' fig-dev.yaml | wc -l)
while [ $(docker ps | grep -c raintankdocker) -ne $num ]; do
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
   screen -S raintank -X screen -t $base docker exec -t -i raintankdocker_${base}_1 bash
  fi
  while read line; do
    screen -S raintank -p $(basename $service) -X stuff "$line\n"
  done < $service
done

echo "starting collector..."
./launch_dev_collector.sh

echo "now it's time to:"
echo "screen -r raintank"
