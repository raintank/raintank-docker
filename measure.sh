#!/bin/bash

while true; do
  echo "$(date) measuring.."
  c_cpu=$(ps aux | grep -v awk | awk '/java.*cassandra/ { print $3}')
  c_rss=$(ps aux | grep -v awk | awk '/java.*cassandra/ { print $6}')
  g_cpu=$(ps aux | grep -v awk | awk '/grafana-server/ { print $3}')
  g_rss=$(ps aux | grep -v awk | awk '/grafana-server/ { print $6}')
  kairos_cpu=$(ps aux | grep -v awk | awk '/java.*kairosdb/ {print $3}')
  kairos_rss=$(ps aux | grep -v awk | awk '/java.*kairosdb/ {print $6}')
  nmt_cpu=$(ps aux | grep -v awk | awk '/nsq_metrics_tank/ {print $3}')
  nmt_rss=$(ps aux | grep -v awk | awk '/nsq_metrics_tank/ {print $6}')
  nmk_cpu=$(ps aux | grep -v awk | awk '/nsq_metrics_to_kairos/ {print $3}')
  nmk_rss=$(ps aux | grep -v awk | awk '/nsq_metrics_to_kairos/ {print $6}')
  ts=$(date +%s)
  ( cat << EOF
measure.cassandra_cpu $c_cpu $ts
measure.cassandra_rss $c_rss $ts
measure.grafana_cpu $g_cpu $ts
measure.grafana_rss $g_rss $ts
measure.kairosdb_cpu $kairos_cpu $ts
measure.kairosdb_rss $kairos_rss $ts
measure.nmt_cpu $nmt_cpu $ts
measure.nmt_rss $nmt_rss $ts
measure.nmk_cpu $nmk_cpu $ts
measure.nmk_rss $nmk_rss $ts
EOF
ps aux | grep -v awk | awk 'BEGIN { worker = 0} /python.*gunicorn/ {worker++; print "measure.graphite-api." worker "_cpu", $3}' | sed "s#\$# $ts#"
ps aux | grep -v awk | awk 'BEGIN { worker = 0} /python.*gunicorn/ {worker++; print "measure.graphite-api." worker "_rss", $6}' | sed "s#\$# $ts#"
) | nc -c localhost 2003
  sleep 10
done
