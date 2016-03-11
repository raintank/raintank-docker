#!/bin/sh

## set config options
ADDR=${ADDR:-0.0.0.0:80}
DB_PATH:${DB_PATH:-/tmp/apps-server.sqlite}
ADMIN_KEY=${ADMIN_KEY:-not_very_secret_key}
STATSD_ENABLED=${STATSD_ENABLED:-true}
STATSD_ADDR=${STATSD_ADDR:-statsdaemon:8125}
METRIC_TOPIC=${METRIC_TOPIC:-metrics}
NSQD_ADDR=${NSQD_ADDR:-nsqd:4150}
PUBLISH_METRICS=${PUBLISH_METRICS:-true}
GRAPHITE_URL=${GRAPHITE_URL:-http://graphiteapi:8888/}
mkdir -p /etc/raintank

cat <<EOM >/etc/raintank/tsdb.ini
addr = $ADDR
db-path = $DB_PATH
admin-key = $ADMIN_KEY
statsd-enabled = $STATSD_ENABLED
statsd-addr = $STATSD_ADDR
statsd-type = standard

metric-topic = $METRIC_TOPIC
nsqd-addr = $NSQD_ADDR
publish-metrics = $PUBLISH_METRICS
graphite-url = $GRAPHITE_URL
EOM

wait.sh $NSQD_ADDR
curl -X POST "http://$NSQD_ADDR/topic/create?topic=$METRIC_TOPIC"

exec /go/bin/tsdb --config /etc/raintank/tsdb.ini
