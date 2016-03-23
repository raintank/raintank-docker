#!/bin/sh

## set config options
ADDR=${ADDR:-0.0.0.0:80}
DB_PATH=${DB_PATH:-/tmp/worldping-api.sqlite}
ADMIN_KEY=${ADMIN_KEY:-not_very_secret_key}
STATSD_ENABLED=${STATSD_ENABLED:-true}
STATSD_ADDR=${STATSD_ADDR:-statsdaemon:8125}
TASK_SERVER_ADDR=${TASK_SERVER_ADDR:-http://taskserver/}
mkdir -p /etc/raintank

cat <<EOM >/etc/raintank/worldping-api.ini
addr = $ADDR
db-path = $DB_PATH
admin-key = $ADMIN_KEY
task-server-addr = $TASK_SERVER_ADDR
statsd-enabled = $STATSD_ENABLED
statsd-addr = $STATSD_ADDR
statsd-type = standard
EOM

exec /go/bin/worldping-api --config /etc/raintank/worldping-api.ini

