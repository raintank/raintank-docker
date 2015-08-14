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
#elasticSearch
docker-compose -f fig-dev.yaml up -d
sleep 5
echo starting screen session
screen -S raintank -d -m -t shell bash
sleep 1

#graphite-api
screen -S raintank -X screen -t graphite-api docker exec -t -i raintankdocker_graphiteApi_1 bash

#grafana
screen -S raintank -X screen -t grafana docker exec -t -i raintankdocker_grafana_1 bash

#statsdaemon
screen -S raintank -X screen -t statsdaemon docker exec -t -i raintankdocker_statsdaemon_1 bash

#influxdb
screen -S raintank -X screen -t influxdb docker exec -t -i raintankdocker_influxdb_1 bash


#nsqtokairos
screen -S raintank -X screen -t nsqtokairos docker exec -t -i raintankdocker_nsqtokairos_1 bash

#nsqtoelasticsearch
screen -S raintank -X screen -t nsqtoelasticsearch docker exec -t -i raintankdocker_nsqtoelasticsearch_1 bash

# open a mysql cli for convenience
screen -S raintank -X screen -t mysql-cli docker exec -t -i $(docker ps | awk '/raintankdocker_mysql_1/ {print $1}') mysql -prootpass grafana

sleep 5
screen -S raintank -p graphite-api -X stuff 'tail -10f /var/log/raintank/graphite-api.log\n'
screen -S raintank -p grafana -X stuff '/tmp/create-influxdb-dev-datasource.sh &> /var/log/raintank/create-influxdb-datasource.log; touch /var/log/raintank/grafana-dev.log\n'
screen -S raintank -p grafana -X stuff 'cat /var/log/raintank/create-influxdb-datasource.log\n'
screen -S raintank -p grafana -X stuff 'tail -10f /var/log/raintank/grafana-dev.log\n'
screen -S raintank -p nsqtokairos -X stuff 'cd /go/src/github.com/raintank/raintank-metric/nsq_to_kairos\n'
screen -S raintank -p nsqtokairos -X stuff './nsq_to_kairos --topic metrics --channel tokairos --nsqd-tcp-address nsqd:4150 2>&1 | tee /var/log/raintank/nsq-to-kairos.log\n'
screen -S raintank -p nsqtoelasticsearch -X stuff 'cd /go/src/github.com/raintank/raintank-metric/nsq_to_elasticsearch\n'
screen -S raintank -p nsqtoelasticsearch -X stuff './nsq_to_elasticsearch --topic metrics --channel toelasticsearch --nsqd-tcp-address nsqd:4150\n'
screen -S raintank -p statsdaemon -X stuff 'tail -f /var/log/statsdaemon.log\n'
screen -S raintank -p influxdb -X stuff 'tail -f /opt/influxdb/shared/log.txt\n'

#raintank-collector - this is an instance of an edge collector.
./launch_dev_collector.sh dev-1


echo "now it's time to:"
echo "screen -r raintank"
