#!/bin/sh

## set config options
LISTEN=${LISTEN:-0.0.0.0:6060}
CHANNEL=${CHANNEL:-tank}
TOPIC=${TOPIC:-metrics}
MAX_IN_FLIGHT=${MAX_IN_FLIGHT:-200}
CONCURRENCY=${CONCURRENCY:-10}
NSQD_TCP_ADDRESS=${NSQD_TCP_ADDRESS:-nsqd:4150}
CASSANDRA_ADDRS=${CASSANDRA_ADDRS:-cassandra}
ELASTIC_ADDR=${ELASTIC_ADDR:-elasticsearch:9200}
INDEX_NAME=${INDEX_NAME:-metric}
STATSD_ADDR=${STATSD_ADDR:-statsdaemon:8125}
CHUNKSPAN=${CHUNKSPAN:-600}
NUMCHUNKS=${NUMCHUNKS:-3}
CASSANDRA_WRITE_CONCURRENCY=${CASSANDRA_WRITE_CONCURRENCY:-5}
CASSANADRA_WRITE_QUEUE_SIZE=${CASSANADRA_WRITE_QUEUE_SIZE:-1000000}
CASSANDRA_READ_CONCURRENCY=${CASSANDRA_READ_CONCURRENCY:-20}
CASSANADRA_READ_QUEUE_SIZE=${CASSANADRA_READ_QUEUE_SIZE:-100}
TTL=${TTL:3024000}
AGG_SETTINGS=${AGG_SETTINGS:-10min:6h:2:38d:true,2h:6h:2:120d:true}
PRIMARY_NODE=${PRIMARY_NODE:-true}
GC_INTERVAL=${GC_INTERVAL:-3600}
CHUNK_MAX_STALE=${CHUNK_MAX_STALE:-3600}
METRIC_MAX_STALE=${METRIC_MAX_STALE:-21600}


mkdir -p /etc/raintank

cat <<EOM >/etc/raintank/metric-tank.ini
listen = $LISTEN
channel = $CHANNEL
topic = $TOPIC
max-in-flight = $MAX_IN_FLIGHT
concurrency = $CONCURRENCY
nsqd-tcp-address = $NSQD_TCP_ADDRESS
cassandra-addrs = $CASSANDRA_ADDRS
elastic-addr = $ELASTIC_ADDR
index-name = $INDEX_NAME
statsd-addr = $STATSD_ADDR
statsd-type = standard
chunkspan = $CHUNKSPAN
numchunks = $NUMCHUNKS
cassandra-write-concurrency = $CASSANDRA_WRITE_CONCURRENCY
cassandra-write-queue-size = $CASSANADRA_WRITE_QUEUE_SIZE
cassandra-read-concurrency = $CASSANDRA_READ_CONCURRENCY
cassandra-read-queue-size = $CASSANADRA_READ_QUEUE_SIZE
ttl = $TTL
agg-settings = $AGG_SETTINGS
primary-node = $PRIMARY_NODE
gc-interval = $GC_INTERVAL
chunk-max-stale = $CHUNK_MAX_STALE
metric-max-stale = $METRIC_MAX_STALE
EOM

exec /go/bin/metric_tank --config /etc/raintank/metric-tank.ini