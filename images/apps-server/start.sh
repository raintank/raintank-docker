#!/bin/sh

## set config options
ADDR=${ADDR:-0.0.0.0:80}
DB_PATH:${DB_PATH:-/tmp/apps-server.sqlite}
ADMIN_KEY=${ADMIN_KEY:-not_very_secret_key}
STATSD_ENABLED=${STATSD_ENABLED:-true}
STATSD_ADDR=${STATSD_ADDR:-statsdaemon:8125}
mkdir -p /etc/raintank

cat <<EOM >/etc/raintank/apps-server.ini
addr = $ADDR
db-path = $DB_PATH
admin-key = $ADMIN_KEY
statsd-enabled = $STATSD_ENABLED
statsd-addr = $STATSD_ADDR
statsd-type = standard
EOM

exec /go/bin/apps-server --config /etc/raintank/apps-server.ini

