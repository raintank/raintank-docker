#!/bin/bash

COLUMNS=512 top -b -c | grep -v sed | sed -u -n \
  -e 's#`-.*java.*cassandra.*#cassandra#p' \
  -e 's#`-.*java.*elasticsearch.*#elasticsearch#p' \
  -e 's#`-.*grafana-server.*#grafana#p' \
  -e 's#`- /nsqd .*#nsqd#p' \
  -e 's#`- ./metric_tank.*#nmt#p' \
  -e 's#`- ./nsq_metrics_to_kairos.*#nmk#p' \
  -e 's#`- ./nsq_metrics_to_elastic.*#nme#p' \
  -e 's#`- ./nsq_probe_events_to_elastic.*#npee#p' \
  -e 's#`-.*python.*gunicorn.*#graphite-api#p' \
  -e 's#`-.*bin/carbon-relay-ng proxy.ini.*#carbon-relay-ng#p' \
  -e 's#`-.*rabbitmq_server.*#rabbit#p' \
  -e 's#`-.*/go/bin/statsdaemon.*#statsdaemon#p' \
  -e 's#`-.*node.*raintank-collector.*#collector#p' \
  | awk '{print $6,$7,$11;fflush();}' \
  | while read mem cpu process; do
    ts=$(date +%s)
    mem=${mem/m/}
    if [ "$process" == "graphite-api" ]; then
      graphite_api_i=$((graphite_api_i + 1))
      echo "measure.${process}.${graphite_api_i}_cpu $cpu $ts"
      echo "measure.${process}.${graphite_api_i}_rss $mem $ts"
    elif [ "$process" == "collector" ]; then
      collector_i=$((collector_i + 1))
      echo "measure.${process}.${collector_i}_cpu $cpu $ts"
      echo "measure.${process}.${collector_i}_rss $mem $ts"
    else
      graphite_api_i=0
      collector_i=0
      echo "measure.${process}_cpu $cpu $ts"
      echo "measure.${process}_rss $mem $ts"
    fi
done | nc -c localhost 2003
