#!/bin/bash

echo "waiting for Grafana to start listening..."
while true; do
  netstat -nlp | grep -q ':3000' && break
  sleep 0.5
done
echo "ok grafana is listening"

echo "> adding datasources"

curl -u admin:admin \
  -H "content-type: application/json" \
  'http://localhost:3000/api/datasources' -X POST --data-binary '{"name":"graphite","type":"graphite","url":"http://localhost:8000","access":"direct","isDefault":false}'

curl -u admin:admin \
  -H "content-type: application/json" \
  'http://localhost:3000/api/datasources' -X POST --data-binary '{"name":"benchmarks","type":"elasticsearch","url":"http://elasticsearch:9200","access":"proxy","isDefault":false,"database":"benchmark","user":"","password":"", "jsonData": {"timeField": "timestamp"}}'

curl -u admin:admin \
  -H "content-type: application/json" \
  'http://localhost:3000/api/datasources' -X POST --data-binary '{"name":"metric-tank","type":"graphite","url":"http://localhost:18764","access":"direct","isDefault":false}'


for file in /tmp/dashboards/*; do
  echo "> adding dashboard $file"
  curl -u admin:admin \
    -H "content-type: application/json" \
    'http://localhost:3000/api/dashboards/db' -X POST -d "{\"dashboard\": $(cat $file)}"
done

