#!/bin/bash

hosts=$(echo $WAIT_HOSTS | tr "," "\n")

for h in $hosts; do
	/usr/local/bin/wait.sh $h
done

exec /go/bin/tsdb-gw $@