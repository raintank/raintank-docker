#!/bin/bash

zk=${ZOOKEEPER:-localhost:2181}
topic=${TOPIC:-mdm}
parts=${PARTS:-16}
maxAttempt=${MAX_ATTEMPTS:-40}

attempt=0
found=0

function log {
	echo "$(date '+%F %T') $@"
}

while true; do
	attempt=$((attempt+1))
	echo
	log "###  waiting for topic $topic with $parts parts @ $zk.. attempt $attempt/$maxAttempt"
	echo
	out=$(/opt/kafka_2.11-0.10.0.1/bin/kafka-topics.sh --zookeeper $zk --topic $topic --describe 2>&1)
	log "description of current topics matching mdm:"
	log "$out"
	if grep -q "PartitionCount:$parts" <<< "$out"; then
		log "YES !!"
		found=1
		break
	fi
	log "nope...."
	if [ $attempt -eq $maxAttempt ]; then
		break
	fi
	sleep 1
done

if [ $found -eq 0 ]; then
	log "FATAL: timed out waiting for topic $topic with $parts parts" >&2
	exit 2
fi

nc -l -p 10101
