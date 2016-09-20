#!/bin/bash

COLUMNS=512 top -b -c | grep -v sed | sed -u -n \
  -e 's#`-.*java.*cassandra.*#cassandra#p' \
  -e 's#`-.*java.*elasticsearch.*#elasticsearch#p' \
  -e 's#`-.*grafana-server.*#grafana#p' \
  -e 's#`- /nsqd .*#nsqd#p' \
  -e 's#`- /usr/bin/metrictank.*#metrictank#p' \
  -e 's#`- ./nsq_probe_events_to_elastic.*#npee#p' \
  -e 's#`-.*python.*gunicorn.*#graphite-api#p' \
  -e 's#`-.*/carbon-relay-ng.*proxy.ini$#carbon-relay-ng#p' \
  -e 's#`-.*rabbitmq_server.*#rabbit#p' \
  -e 's#`-.*/go/bin/statsdaemon.*#statsdaemon#p' \
  -e 's#`-.*node.*raintank-collector.*#collector#p' \
  -e 's#`- /usr/lib/jvm/java-8-openjdk-amd64/.*kafkaServer.*#kafka#p' \
  -e 's#`-.*fake_metrics.*-kafka-mdam-tcp-address#fake_metrics-kafka-mdam#p' \
  -e 's#`-.*fake_metrics.*-kafka-mdm-tcp-address#fake_metrics-kafka-mdm#p' \
  -e 's#`-.*fake_metrics.*-nsqd-tcp-address#fake_metrics-nsqd#p' \
  -e 's#`-.*tsdb-gw --config.*#tsdb-gw#p' \
  | awk '{print $6,$7,$11;fflush();}' \
  | while read mem cpu process; do
    ts=$(date +%s)
    if [ "$ts" != "$prevTs" ]; then
      # a bit hacky.. since we receive a stream of process measurements, where multiple graphite instances that need sequential numbering
      # are intermingled with updates for the next time interval, we need a way to figure out when to bump the number vs resetting it.
      # checking the timestamps of our parse loop is not rock solid but should be good enough
      graphite_api_i=0
      collector_i=0
      mt_i=0
    fi
    if [[ $mem =~ g$ ]]; then
	    mem=$(bc -l <<< "${mem:0:-1} * 1024 * 1024 * 1024")
    elif [[ $mem =~ m$ ]]; then
	    mem=$(bc -l <<< "${mem:0:-1} * 1024 * 1024")
    elif [[ $mem =~ k$ ]]; then
	    mem=$(bc -l <<< "${mem:0:-1} * 1024")
    fi

    if [ "$process" == "graphite-api" ]; then
      graphite_api_i=$((graphite_api_i + 1))
      echo "measure.${process}.${graphite_api_i}.cpu $cpu $ts"
      echo "measure.${process}.${graphite_api_i}.rss $mem $ts"
    elif [ "$process" == "collector" ]; then
      collector_i=$((collector_i + 1))
      echo "measure.${process}.${collector_i}.cpu $cpu $ts"
      echo "measure.${process}.${collector_i}.rss $mem $ts"
    elif [ "$process" == "metrictank" ]; then
      mt_i=$((mt_i + 1))
      echo "measure.${process}.${mt_i}.cpu $cpu $ts"
      echo "measure.${process}.${mt_i}.rss $mem $ts"
    else
      echo "measure.${process}.cpu $cpu $ts"
      echo "measure.${process}.rss $mem $ts"
    fi
    prevTs=$ts
done | nc -c localhost 2003
