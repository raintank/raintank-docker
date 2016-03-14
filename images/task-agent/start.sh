#!/bin/sh

## set config options
NODE_NAME=${NODE_NAME:-demo1}
SERVER_ADDR=${SERVER_ADDR:-taskserver:80}
TSDB_ADDR=${TSDB_ADDR:-http://tsdb:80/metrics}
ADMIN_KEY=${ADMIN_KEY:-not_very_secret_key}

mkdir -p /etc/raintank

cat <<EOM >/etc/raintank/agent.ini
server-addr = $SERVER_ADDR
tsdb-addr = $TSDB_ADDR
name = $NODE_NAME
admin-key = $ADMIN_KEY
EOM

wait.sh $SERVER_ADDR
curl -H "Authorization: Bearer $ADMIN_KEY"\
 -H "content-type: application/json"\
 -X POST --data-binary "{\"name\": \"${NODE_NAME}\", \"enabled\": true, \"public\": true, \"tags\": [\"public\"]}"\
 "http://${SERVER_ADDR}/api/agents"


exec /go/bin/task-agent --config /etc/raintank/agent.ini