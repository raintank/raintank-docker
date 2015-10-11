#!/bin/bash

echo "waiting for Grafana to start listening..."
while true; do
  netstat -nlp | grep -q ':80' && break
  sleep 0.5
done
echo "ok grafana is listening"

echo "> creating api key entry"

echo 'INSERT INTO api_key (`org_id`,`name`,`key`,`role`,`is_admin`,`created`,`updated`) VALUES (1,"devstack-admin","bcc429f8b9b2a0f5e5fef92416a4f24e8abd3332a619d33e8961db21cefe4a9b0ed81369dbdc6a800063aba2731256aa67fc","Admin",0,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP);' | mysql -prootpass grafana -h mysql
echo 'api keys currently known:'
echo 'select * from api_key;' | mysql -prootpass grafana -h mysql

echo "> adding datasource"

curl -H "Authorization: Bearer eyJrIjoiMEVUVE52c3ZITnhpVldyOTI5cVFQcUxQWGR6V213bUIiLCJuIjoiZGV2c3RhY2stYWRtaW4iLCJpZCI6MX0=" \
  -H "content-type: application/json" \
  'http://localhost/api/datasources' -X POST --data-binary '{"name":"influxdb","type":"influxdb_08","url":"http://localhost:8086","access":"direct","isDefault":false,"database":"raintank","user":"graphite","password":"graphite"}'

for file in /tmp/dashboards/*; do
  echo "> adding dashboard $file"
  curl -H "Authorization: Bearer eyJrIjoiMEVUVE52c3ZITnhpVldyOTI5cVFQcUxQWGR6V213bUIiLCJuIjoiZGV2c3RhY2stYWRtaW4iLCJpZCI6MX0=" \
    -H "content-type: application/json" \
    'http://localhost/api/dashboards/db' -X POST -d "{\"dashboard\": $(cat $file)}"
done
