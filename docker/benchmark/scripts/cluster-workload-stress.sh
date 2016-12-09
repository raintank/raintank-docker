#!/bin/bash
wait.sh kafka:9092 cassandra:9042
fakemetrics -shard-org -listen :6764 -kafka-mdm-tcp-address kafka:9092 -kafka-comp none -statsd-addr statsdaemon:8125 -orgs 2 -keys-per-org 10000 &

echo "$(date) waiting a minute to let the data flow through into MT and into cassandra"
sleep 60
echo "$(date) waiting done"
inspect-idx -addr http://metrictank0:6063 cass cassandra:9042 raintank vegeta-mt-graphite | vegeta attack -rate 10 -duration=1min | vegeta report
