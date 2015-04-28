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
docker-compose -f fig-tinyalpha.yaml up -d
sleep 5
echo starting screen session
screen -S raintank -d -m -t shell bash
sleep 1

#graphite-api
screen -S raintank -X screen -t graphite-api docker exec -t -i raintankdocker_graphiteApi_1 bash

#grafana
screen -S raintank -X screen -t grafana docker exec -t -i raintankdocker_grafana_1 bash


#raintank-metric - this app consumes the metric data written to the message queue and sends it to influxdb.  The app also performs threshold checking and data roll-ups
screen -S raintank -X screen -t metric docker exec -t -i raintankdocker_raintankMetric_1 bash

sleep 5
screen -S raintank -p graphite-api -X stuff 'tail -10f /var/log/raintank/graphite-api.log\n'
screen -S raintank -p grafana -X stuff 'supervisorctl restart all; tail -10f /var/log/raintank/grafana.log\n'
screen -S raintank -p metric -X stuff 'tail -10f /var/log/raintank/metric.log\n'

screen -r
