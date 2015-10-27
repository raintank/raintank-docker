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
eval $(grep ^RT_LOGS setup_dev.sh)

docker run --link=raintankdocker_grafana_1:grafana \
           -v $RT_CODE/raintank-collector:/opt/raintank/raintank-collector \
           -v $RT_LOGS:/var/log/raintank \
           -e RAINTANK_collector_name=$id -d \
           --name=$docker_name \
           raintank/collector

screen -S raintank -X screen -t collector-$id docker exec -t -i $docker_name bash
screen -S raintank -p collector-$id -X stuff 'supervisorctl restart all; touch /var/log/raintank/collector.log\n'

while true; do
  data=$(curl -s -X GET -H "Authorization: Basic YWRtaW46YWRtaW4=" 'http://localhost/api/collectors')
  if grep -q "\"$id\"" <<< "$data"; then
    break
  fi
  echo "waiting for collector $id to be known to grafana..."
  sleep 1
done
mysql_id=$(sed 's#.*"id":\([0-9]\+\),"org_id":[0-9]\+,"slug":"'$id'".*#\1#' <<< "$data")
# make it a "public" collector so different orgs can use it
curl -X POST -H "Authorization: Basic YWRtaW46YWRtaW4=" -F "public=true" -F "enabled=true" -F "name=$id" -F "id=$mysql_id" 'http://localhost/api/collectors'

# restart the collector after making it public.
screen -S raintank -p collector-$id -X stuff 'supervisorctl stop all && pkill -f -9 raintank-probe && supervisorctl start all\n'
screen -S raintank -p collector-$id -X stuff 'tail -10f /var/log/raintank/collector.log\n'
