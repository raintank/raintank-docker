#!/bin/bash
curl -H "Authorization: Bearer eyJrIjoiMEVUVE52c3ZITnhpVldyOTI5cVFQcUxQWGR6V213bUIiLCJuIjoiZGV2c3RhY2stYWRtaW4iLCJpZCI6MX0=" \
  -H "content-type: application/json" \
  'http://localhost/api/datasources' -X PUT --data-binary '{"name":"influxdb","type":"influxdb_08","url":"http://influxdb:8086","access":"proxy","isDefault":false,"database":"raintank","user":"graphite","password":"graphite"}'
