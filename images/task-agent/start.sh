#!/bin/sh

## set config options
NODE_NAME=${NODE_NAME:-demo1}
SERVER_ADDR=${SERVER_ADDR:-ws://taskserver/api/v1}
TSDB_ADDR=${TSDB_ADDR:-http://tsdb:80/metrics}
ADMIN_KEY=${ADMIN_KEY:-not_very_secret_key}

mkdir -p /etc/raintank

cat <<EOM >/etc/raintank/agent.ini
server-addr = $SERVER_ADDR
tsdb-addr = $TSDB_ADDR
name = $NODE_NAME
admin-key = $ADMIN_KEY
EOM

# extract the protocol
proto="$(echo $SERVER_ADDR | grep :// | sed -e's,^\(.*://\).*,\1,g')"

# remove the protocol -- updated
url=$(echo $SERVER_ADDR | sed -e s,$proto,,g)

# extract the user (if any)
user="$(echo $url | grep @ | cut -d@ -f1)"

# extract the host -- updated
host=$(echo $url | sed -e s,$user@,,g | cut -d/ -f1)

# extract port from host
port=$(echo $host|grep :|cut -d: -f2)
if [ -z $port]; then
        if [ "$proto" = "wss://" ]; then
                port=443
        else
                port=80
        fi
fi

# extract the path (if any)
path="$(echo $url | grep / | cut -d/ -f2-)"

wait.sh $host:$port
curl -H "Authorization: Bearer $ADMIN_KEY"\
 -H "content-type: application/json"\
 -X POST --data-binary "{\"name\": \"${NODE_NAME}\", \"enabled\": true, \"public\": true, \"tags\": [\"public\"]}"\
 "$(echo $proto|sed -e s,ws,http,)${host}:${port}/${path}/agents"


exec /go/bin/task-agent --config /etc/raintank/agent.ini
