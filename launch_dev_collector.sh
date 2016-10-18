#!/bin/bash
set -x
# launch a collector with an auto-assigned id, based on an incrementing counter, and hook it into the screen session
# don't run this script concurrently

highest=$(docker ps | grep raintank_raintankCollector_dev | sed 's#.*raintank_raintankCollector_dev##' | sort -n | tail -n 1)
docker ps | grep raintank_raintankCollector_dev
# if no containers yet, start at 1
[ -z "$highest" ] && highest=0
id=dev$((highest+1))

docker_name=raintank_raintankCollector_$id

eval $(grep ^CODE setup_dev.sh)
eval $(grep ^LOGS setup_dev.sh)

docker run --network raintank_default \
           -v $CODE/raintank-probe/build:/go/bin/ \
           -d --name=$docker_name \
           -h collector-$id \
           -e WAIT_HOSTS=worldpingApi:80 \
           raintank/raintank-probe -api-key=changeme -name=$id -server-url=ws://worldpingApi/ -tsdb-url=http://tsdbgw/

screen -S raintank -X screen -t collector-$id docker logs -f $docker_name
./docker/nodejsgo/wait.sh localhost:80
./makeProbePublic.py $id
