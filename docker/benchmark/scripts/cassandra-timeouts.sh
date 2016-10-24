#!/bin/bash

# first steps:
# in ./code, need metrictank latest cassandra-retry branch
# launch docker stack, make sure all containers are running with docker ps -a
# go to http://localhost:3000/plugins/raintank-worldping-app/edit to login and enter `changeme` to have plugin create metrictank datasource
# open metrictank dash, and sys dash and take snapshot at the end.
# optional: open fake metrics data dash and reload a couple times both during the HEALTH and the TIMEOUTS step of this simulation to see if data is missing

# we wait for metrictank even though fakemetrics doesn't connect to it,
# but since it uses latest offset we need this for the backfill+realtime load to be correct, and also vegeta start
wait.sh kafka:9092 metrictank:6063
cd /go/src/github.com/raintank/fakemetrics

# fill up all of metrictanks RAM followed by a realtime load
./fakemetrics -listen :6764 -kafka-mdm-tcp-address kafka:9092 -kafka-comp none -statsd-addr statsdaemon:8125 -orgs 10 -keys-per-org 100 -speedup 30 -offset 90min -stop-at-now
./fakemetrics -listen :6764 -kafka-mdm-tcp-address kafka:9092 -kafka-comp none -statsd-addr statsdaemon:8125 -orgs 10 -keys-per-org 100 &

# let the "realtime workload" settle in for a bit, and measure how MT performs
sleep 10s
echo "HEALTHY:"
inspect-idx -from 1h cass cassandra:9042 raintank vegeta-mt | vegeta attack -rate 10 -duration 60s > vegeta-healthy
cat vegeta-healthy | vegeta report

# make cassandra timeout once in a while, and measure how MT performs
/go/src/github.com/Shopify/toxiproxy/cmd/toxiproxy-cli/toxiproxy-cli -h http://toxiproxy:8474 toxic add -t latency -a latency=0 -a jitter=1500 cassandra
echo "TIMEOUTS:"
inspect-idx -from 1h cass cassandra:9042 raintank vegeta-mt | vegeta attack -rate 10 -duration 60s > vegeta-timeouts
cat vegeta-timeouts | vegeta report
