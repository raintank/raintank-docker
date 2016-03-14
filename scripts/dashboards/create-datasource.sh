#!/bin/bash
BASE=$(dirname $0)
sleep 30

echo "> adding datasources"

curl -u admin:admin \
  -H "content-type: application/json" \
  'http://localhost:3000/api/datasources' -X POST --data-binary '{"name":"graphite","type":"graphite","url":"http://graphitemon:8000","access":"proxy","isDefault":false}'

curl -u admin:admin \
  -H "content-type: application/json" \
  'http://localhost:3000/api/datasources' -X POST --data-binary '{"name":"benchmarks","type":"elasticsearch","url":"http://elasticsearch:9200","access":"proxy","isDefault":false,"database":"benchmark","user":"","password":"", "jsonData": {"timeField": "timestamp"}}'


for file in $BASE/*.json; do
  echo "> adding dashboard $file"
  curl -u admin:admin \
    -H "content-type: application/json" \
    'http://localhost:3000/api/dashboards/db' -X POST -d "{\"dashboard\": $(cat $file)}"
done

