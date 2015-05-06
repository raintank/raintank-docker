#!/bin/bash
container=$(docker ps | awk '/raintankdocker_mysql_1/ {print $1}')
if [ -z "$container" ]; then
    echo "no running raintank mysql container found" >&2
    exit 1
fi
port=$(docker inspect -f "{{ .NetworkSettings.Ports }}" $container | sed 's#.*:\([0-9]\+\).*#\1#')
exec mysql -h 127.0.0.1 -P $port -D grafana -u grafana -ppassword
