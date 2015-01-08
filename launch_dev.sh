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
echo launching mongodb
docker run -d -p 27017 --name mongodb raintank/mongodb

#influxdb
echo launching influxdb
docker run -d -p 8083 -p 8086 -p 2003 --name influxdb raintank/influxdb

sleep 5
echo starting screen session
screen -S raintank -d -m -t shell bash

#raintank-broker
echo starting broker container
screen -S raintank -X screen -t broker docker run -t -i -p 9997 -p 9998 -p 9999 -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name broker raintank/broker bash


#graphite-api
echo starting graphite-api container
screen -S raintank -X screen -t graphite-api docker run -t -i -p 8888  --name graphite-api --link mongodb:mongodb --link influxdb:influxdb -e GRAPHITE_influxdb_host=influxdb raintank/graphite-api bash

sleep 10

#raintank-api - this is the Nodejs Express app that provides the API. It also serves the Grafana static html/js/css files.
echo starting api container
screen -S raintank -X screen -t api docker run -t -i -p 4000 -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name raintank-api  --link mongodb:mongodb --link influxdb:influxdb --link graphite-api:graphite-api --link elasticsearch:elasticsearch --link broker:broker -e RAINTANK_carbon_host=influxdb -e RAINTANK_siteUrl=http://192.168.1.131/ raintank/api bash


#raintank-location-mgr - this handles communication with the remote collector nodes.
echo starting location-mgr container
screen -S raintank -X screen -t location-mgr docker run -t -i -p 8181:8181 -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt --name raintank-location-mgr  --link mongodb:mongodb --link broker:broker raintank/location-mgr bash


#raintank-dispatcher - this app schedules the execution of continuous query tasks.
echo starting dispatcher container
screen -S raintank -X screen -t dispatcher docker run -t -i -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name raintank-dispatcher  --link mongodb:mongodb --link broker:broker raintank/dispatcher bash


#raintank-task - this app runs the continuous queries.  The app reads reads 'task' events written to the message queue by the dispatcher app.
echo starting task container
screen -S raintank -X screen -t task docker run -t -i -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name raintank-task  --link mongodb:mongodb --link broker:broker --link graphite-api:graphite-api raintank/task bash


#raintank-event - this app processes event messages written to the message queue.  Currently, processing just involves writing the messages to Elasticsearch.
echo starting event container
screen -S raintank -X screen -t event docker run -t -i -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name raintank-event  --link mongodb:mongodb --link broker:broker --link elasticsearch:elasticsearch raintank/event bash


#raintank-metric - this app consumes the metric data written to the message queue and sends it to influxdb.  The app also performs threshold checking and data roll-ups
echo starting metric container
screen -S raintank -X screen -t metric docker run -t -i -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name raintank-metric  --link mongodb:mongodb --link broker:broker --link influxdb:influxdb raintank/metric bash

sleep 10

# raintank-proxy - this is an nginx reverse-proxy which handles routing HTTP request to either the raintank-api or graphite-api so that both can be served over the same ip:port
echo starting proxy container
screen -S raintank -X screen -t proxy docker run -t -i -p 80:80 --name raintank-proxy  --link raintank-api:raintank-api --link graphite-api:graphite-api raintank/proxy bash


#raintank-collector - this is an instance of an edge collector.
echo starting collector container
screen -S raintank -X screen -t collector docker run -t -i -v /var/docker/raintank/logs:/var/log/raintank -v /opt/raintank:/opt/raintank --name raintank-collector  --link raintank-location-mgr:raintank-locationmgr raintank/collector bash

echo "all containers started."

sleep 5
echo "starting services up in containers"
screen -S raintank -p broker -X stuff 'cd /opt/raintank; nodejs /opt/raintank/aintank-workers/broker.js\n'
screen -S raintank -p graphite-api -X stuff 'start-graphite.py\n'
screen -S raintank -p api -X stuff 'cd /opt/raintank; nodejs /opt/raintank/raintank-api/app.js\n'
screen -S raintank -p location-mgr -X stuff 'cd /opt/raintank; nodejs /opt/raintank/raintank-workers/locationManager.js\n'
screen -S raintank -p dispatcher -X stuff 'cd /opt/raintank; nodejs /opt/raintank/raintank-workers/dispatcher.js\n'
screen -S raintank -p task -X stuff 'cd /opt/raintank; nodejs /opt/raintank/raintank-workers/worker.js\n'
screen -S raintank -p event -X stuff 'cd /opt/raintank; nodejs /opt/raintank/raintank-workers/eventWorker.js\n'
screen -S raintank -p metric -X stuff 'cd /opt/raintank; nodejs /opt/raintank/raintank-workers/metricStore.js\n'
screen -S raintank -p proxy -X stuff 'nginx\n'
screen -S raintank -p collector -X stuff 'cd /opt/raintank; nodejs /opt/raintank/raintank-collector/app.js\n'