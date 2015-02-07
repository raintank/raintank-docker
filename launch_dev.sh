## Launch development environment using docker and screen.
#
# USAGE
# 
# run this script,
#   sh launch.sh
#
# once it has completed, attach to the raintank screen session
#   screen -r raintank
#
# there will now be a screen window for each of the running components, and an additional screen window running a shell.
# You can 
#

#elasticSearch
echo launching elasticsearch
docker run -d -p 9200  -v /data --name elasticsearch dockerfile/elasticsearch:latest

#mongodb
echo launching rabbitmq
docker run -d -p 5672 -p 15672 --name rabbitmq raintank/rabbitmq

#influxdb
echo launching influxdb
docker run -d -p 8083 -p 8086 -p 2003 --name influxdb raintank/influxdb

sleep 5
echo starting screen session
screen -S raintank -d -m -t shell bash
sleep 1
#graphite-api
echo starting graphite-api container
screen -S raintank -X screen -t graphite-api docker run -t -i -p 8888  --name graphite-api --link elasticsearch:elasticsearch --link influxdb:influxdb -e GRAPHITE_influxdb_host=influxdb raintank/graphite-api bash

sleep 10

#grafana
echo starting grafana container
screen -S raintank -X screen -t grafana docker run -t -i -p 80:3000 -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name grafana --link rabbitmq:rabbitmq --link graphite-api:graphite-api --link elasticsearch:elasticsearch -e GOPATH=/opt/raintank/go raintank/grafana bash


#raintank-collector-ctrl - this handles communication with the remote collector nodes.
echo starting collector-ctrl container
screen -S raintank -X screen -t collector-ctrl docker run -t -i -p 8181:8181 -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name raintank-collector-ctrl  --link grafana:grafana --link rabbitmq:rabbitmq raintank/collector-ctrl bash


#raintank-metric - this app consumes the metric data written to the message queue and sends it to influxdb.  The app also performs threshold checking and data roll-ups
echo starting metric container
screen -S raintank -X screen -t metric docker run -t -i -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name raintank-metric  --link elasticsearch:elasticsearch --link rabbitmq:rabbitmq --link influxdb:influxdb raintank/metric bash

sleep 10

#raintank-collector - this is an instance of an edge collector.
echo starting collector container
screen -S raintank -X screen -t collector docker run -t -i -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name raintank-collector  --link raintank-collector-ctrl:collector-ctrl --link grafana:grafana raintank/collector bash

echo "all containers started."

sleep 5
echo "starting services up in containers"
screen -S raintank -p graphite-api -X stuff 'start-graphite.py\n'
screen -S raintank -p grafana -X stuff 'cd /opt/raintank/grafana; /opt/raintank/grafana/bin/grafana web\n'
screen -S raintank -p collector-ctrl -X stuff 'cd /opt/raintank/collector-ctrl; nodejs app.js\n'
screen -S raintank -p metric -X stuff 'cd /opt/raintank/raintank-workers; nodejs metricStore.js\n'
screen -S raintank -p collector -X stuff 'cd /opt/raintank/raintank-collector; nodejs app.js\n'
