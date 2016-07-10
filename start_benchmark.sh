#!/bin/bash

ORG_COUNT=$1
RATE_HIGH=$2
RATE_LOW=$3

if [ -z "$ORG_COUNT" ]; then
  ORG_COUNT=10
fi

if [ -z "$RATE_HIGH" ]; then
  RATE_HIGH=50
fi

if [ -z "$RATE_LOW" ]; then
  RATE_LOW=50
fi

IP=$(ip addr show docker0 |grep "inet "|awk '{print $2}'|cut -d"/" -f 1)

screen -S raintank -p benchmark -X stuff "echo -e \
\"orgs=$ORG_COUNT\nrate_high=$RATE_HIGH\nrate_low=$RATE_LOW\ngraphite_host=$IP\ngraphitemon_host=$IP\ngrafana_host=$IP\nelasticsearch_host=$IP\nmon_host=raintank_grafana_1\nenv=raintank-docker\n\"\
 >raintank-docker.conf; ./run.sh raintank-docker.conf\n"


