#!/bin/bash

COLUMNS=512 top -b -c | grep -v sed | sed -u -n \
  -e 's#.wsgi.*#wsgi#p' \
  -e 's#apache2.*#apache2#p' \
  -e 's#/usr/*bin/grafana-server.*#grafana#p' \
  -e 's#/usr/bin/metrictank.*#metrictank#p' \
  -e 's#/usr/bin/carbon-relay-ng.*#carbon-relay-ng#p' \
  -e 's#/usr/bin/statsdaemon.*#statsdaemon#p' \
  -e 's#/usr/lib/jvm/java-8-openjdk-amd64/.*kafkaServer.*#kafka#p' \
  -e 's#fakemetrics.*-kafka-mdam-address#fakemetricsmdam#p' \
  -e 's#fakemetrics.*-kafka-mdm-address#fakemetrics-mdm#p' \
  -e 's#./fakemetrics.*-kafka-mdam-address#fakemetricsmdam#p' \
  -e 's#./fakemetrics.*-kafka-mdm-address#fakemetrics-mdm#p' \
  | awk '{print $1,$6,$7,$12;fflush();}' \
  | while read pid mem cpu process; do
    ts=$(date +%s)
    if [[ $mem =~ g$ ]]; then
	    mem=$(bc -l <<< "${mem:0:-1} * 1024 * 1024 * 1024")
    elif [[ $mem =~ m$ ]]; then
	    mem=$(bc -l <<< "${mem:0:-1} * 1024 * 1024")
    elif [[ $mem =~ k$ ]]; then
	    mem=$(bc -l <<< "${mem:0:-1} * 1024")
    fi

    echo "measure.${process}.$pid.cpu $cpu $ts"
    echo "measure.${process}.$pid.rss $mem $ts"
done | nc -c localhost 2003
