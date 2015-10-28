#!/bin/bash

# kairosdb has such a long process line where kairos only shows up at the end and top doesn't show it
kairosdb_pid=$(pgrep -fl 'java.*kairosdb' | grep java | cut -d' ' -f 1)

COLUMNS=512 top -b -c | grep -v sed | sed -u -n \
  -e "s#\($kairosdb_pid root.* \)\(.- java.*\)#\1 kairosdb#p" \
  -e 's#`-.*java.*cassandra.*#cassandra#p' \
  -e 's#`-.*java.*elasticsearch.*#elasticsearch#p' \
  -e 's#`-.*grafana-server.*#grafana#p' \
  -e 's#`- /nsqd .*#nsqd#p' \
  -e 's#`- ./nsq_metrics_tank.*#nmt#p' \
  -e 's#`- ./nsq_metrics_to_kairos.*#nmk#p' \
  -e 's#`- ./nsq_metrics_to_elastic.*#nme#p' \
  -e 's#`- ./nsq_probe_events_to_elastic.*#npee#p' \
  -e 's#`-.*python.*gunicorn.*#graphite-api#p' \
  -e 's#`-.*redis-server.*#redis#p' \
  -e 's#`-.*rabbitmq_server.*#rabbit#p' \
  -e 's#`-.*/go/bin/statsdaemon.*#statsdaemon#p' \
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
