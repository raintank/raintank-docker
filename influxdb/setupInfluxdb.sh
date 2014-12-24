#!/bin/bash

/usr/bin/influxdb -config=/opt/influxdb/shared/config.toml &
PID=$!

#wait for server to come be ready.
NOTRUNNING=1
while [ $NOTRUNNING -eq 1 ] ; do
  netstat -lntp|grep "::8086" > /dev/null
  NOTRUNNING=$?
  sleep 1
done

curl -X POST -H "Accept: application/json" -d @/tmp/shards.json 'http://localhost:8086/cluster/database_configs/raintank?u=root&p=root'
curl -X POST -H "Accept: application/json" -d '{"name": "graphite", "password": "graphite"}' 'http://localhost:8086/db/raintank/users?u=root&p=root'
kill $PID
