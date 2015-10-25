#!/bin/bash

COLUMNS=512 top -b -c | grep -v sed | sed -u -n \
  -e 's#`-.*java.*cassandra.*#cassandra#p' \
  -e 's#`-.*grafana-server.*#grafana#p' \
  -e 's#`-.*java.*kairosdb.*#kairosdb#p' \
  -e 's#`-.*nsq_metrics_tank.*#nmt#p' \
  -e 's#`-.*nsq_metrics_to_kairos.*#nmk#p' \
  -e 's#`-.*python.*gunicorn.*#graphite-api#p' \
  | awk '{print $6,$7,$11;fflush();}' \
  | while read mem cpu process; do
    ts=$(date +%s)
    mem=${mem/m/}
    if [ "$process" != "graphite-api" ]; then
      graphite_api_i=0
      echo "measure.${process}_cpu $cpu $ts"
      echo "measure.${process}_rss $mem $ts"
    else
      graphite_api_i=$((graphite_api_i + 1))
      echo "measure.${process}.${graphite_api_i}_cpu $cpu $ts"
      echo "measure.${process}.${graphite_api_i}_rss $mem $ts"
    fi
done | nc -c localhost 2003
