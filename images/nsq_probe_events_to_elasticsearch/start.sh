#!/bin/sh

## set config options
LISTEN=${LISTEN:-0.0.0.0:6060}
CHANNEL=${CHANNEL:-tank}
TOPIC=${TOPIC:-metrics}
MAX_IN_FLIGHT=${MAX_IN_FLIGHT:-200}
CONCURRENCY=${CONCURRENCY:-10}
NSQD_TCP_ADDRESS=${NSQD_TCP_ADDRESS:-nsqd:4150}
ELASTIC_ADDR=${ELASTIC_ADDR:-elasticsearch:9200}
STATSD_ADDR=${STATSD_ADDR:-statsdaemon:8125}


mkdir -p /etc/raintank

cat <<EOM >/etc/raintank/npee.ini
listen = $LISTEN
channel = $CHANNEL
topic = $TOPIC
max-in-flight = $MAX_IN_FLIGHT
concurrency = $CONCURRENCY
nsqd-tcp-address = $NSQD_TCP_ADDRESS
elastic-addr = $ELASTIC_ADDR
statsd-addr = $STATSD_ADDR
statsd-type = standard
EOM
wait.sh $ELASTIC_ADDR $NSQD_TCP_ADDRESS
exec /go/bin/nsq_probe_events_to_elasticsearch --config /etc/raintank/npee.ini