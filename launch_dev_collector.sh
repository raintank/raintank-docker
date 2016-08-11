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

eval $(grep ^RT_CODE setup_dev.sh)
eval $(grep ^RT_LOGS setup_dev.sh)

./docker/nodejsgo/wait.sh localhost:80
docker run --link=raintank_worldpingApi_1:worldpingApi --link=raintank_tsdbgw_1:tsdbgw\
           -v $RT_CODE/raintank-probe/build:/go/bin/ \
           -d --name=$docker_name \
           -h collector-$id \
           -e WAIT_HOSTS=worldpingApi:80 \
           raintank/raintank-probe -api-key=changeme -name=$id -server-url=ws://worldpingApi/ -tsdb-url=http://tsdbgw/

screen -S raintank -X screen -t collector-$id docker logs -f $docker_name
sleep 15
./docker/nodejsgo/wait.sh localhost:80 # wait for worldpingApi
./makeProbePublic.py $id
