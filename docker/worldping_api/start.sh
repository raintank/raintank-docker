#!/bin/bash

hosts=$(echo $WAIT_HOSTS | tr "," "\n")

for h in $hosts; do
	/usr/local/bin/wait.sh $h
done

cd /go/src/github.com/raintank/worldping-api
exec /go/bin/worldping-api $@