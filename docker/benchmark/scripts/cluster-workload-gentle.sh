#!/bin/bash
wait.sh kafka:9092
fakemetrics -shard-org -listen :6764 -kafka-mdm-tcp-address kafka:9092 -kafka-comp none -statsd-addr statsdaemon:8125 -orgs 2 -keys-per-org 10 &
