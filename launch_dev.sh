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

echo "docker-compose bringing up containers..."
docker-compose -f fig-dev.yaml up -d

echo "starting screen session..."
screen -S raintank -d -m -t shell bash

num=$(grep '^[a-z]' fig-dev.yaml | wc -l)
while [ $(docker ps | grep -c raintankdocker) -ne $num ]; do
  echo "waiting for all $num containers to run..."
  sleep 0.5
done

echo "opening screen tabs..."

screen -S raintank -X screen -t graphite-api docker exec -t -i raintankdocker_graphiteApi_1 bash
screen -S raintank -X screen -t grafana docker exec -t -i raintankdocker_grafana_1 bash
screen -S raintank -X screen -t statsdaemon docker exec -t -i raintankdocker_statsdaemon_1 bash
screen -S raintank -X screen -t influxdb docker exec -t -i raintankdocker_influxdb_1 bash
screen -S raintank -X screen -t kairosdb docker exec -t -i raintankdocker_kairosdb_1 bash
screen -S raintank -X screen -t mysql-cli docker exec -t -i raintankdocker_mysql_1 bash
screen -S raintank -X screen -t nsq_metrics_to_kairos docker exec -t -i raintankdocker_nsqmetricstokairos_1 bash
screen -S raintank -X screen -t nsq_metrics_to_elasticsearch docker exec -t -i raintankdocker_nsqmetricstoelasticsearch_1 bash
screen -S raintank -X screen -t nsq_probe_events_to_elasticsearch docker exec -t -i raintankdocker_nsqprobeeventstoelasticsearch_1 bash

echo "starting commands in screen tabs..."
screen -S raintank -p graphite-api -X stuff 'tail -10f /var/log/raintank/graphite-api.log\n'
screen -S raintank -p grafana -X stuff '/tmp/create-influxdb-dev-datasource.sh &> /var/log/raintank/create-influxdb-datasource.log; touch /var/log/raintank/grafana-dev.log\n'
screen -S raintank -p grafana -X stuff 'cat /var/log/raintank/create-influxdb-datasource.log\n'
screen -S raintank -p grafana -X stuff 'tail -10f /var/log/raintank/grafana-dev.log\n'
screen -S raintank -p kairosdb -X stuff 'tail -f /opt/kairosdb/log/kairosdb.log\n'
screen -S raintank -p mysql-cli -X stuff 'while sleep 1; do mysql -prootpass grafana; done\n'
screen -S raintank -p nsq_metrics_to_kairos -X stuff 'cd /go/src/github.com/raintank/raintank-metric/nsq_metrics_to_kairos\n'
screen -S raintank -p nsq_metrics_to_kairos -X stuff './nsq_metrics_to_kairos --kairos-addr kairosdb:8080 --statsd-addr statsdaemon:8125 --nsqd-tcp-address nsqd:4150 2>&1 | tee /var/log/raintank/nsq_metrics_to_kairos.log\n'
screen -S raintank -p nsq_metrics_to_elasticsearch -X stuff 'cd /go/src/github.com/raintank/raintank-metric/nsq_metrics_to_elasticsearch\n'
screen -S raintank -p nsq_metrics_to_elasticsearch -X stuff './nsq_metrics_to_elasticsearch --elastic-addr elasticsearch:9200 --redis-addr redis:6379 --statsd-addr statsdaemon:8125 --nsqd-tcp-address nsqd:4150\n'
screen -S raintank -p nsq_probe_events_to_elasticsearch -X stuff 'cd /go/src/github.com/raintank/raintank-metric/nsq_probe_events_to_elasticsearch\n'
screen -S raintank -p nsq_probe_events_to_elasticsearch -X stuff './nsq_probe_events_to_elasticsearch --elastic-addr elasticsearch:9200 --statsd-addr statsdaemon:8125 --nsqd-tcp-address nsqd:4150\n'
screen -S raintank -p statsdaemon -X stuff 'tail -f /var/log/statsdaemon.log\n'
screen -S raintank -p influxdb -X stuff 'tail -f /opt/influxdb/shared/log.txt\n'

echo "starting collector..."
./launch_dev_collector.sh

echo "now it's time to:"
echo "screen -r raintank"
