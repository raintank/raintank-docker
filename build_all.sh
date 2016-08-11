#!/bin/bash

rebuild=0
cd docker

function fail() {
	echo "ERROR: failed building $1. stopping." >&2
	exit $STATE;
}

function build () {
	local service=$1
	cd $service

	echo
	echo "##### -> docker build -t raintank/$service ."
	if [ $rebuild -eq 1 ]; then
		docker build --no-cache -t raintank/$service . || fail $service
	else
		docker build -t raintank/$service . || fail $service
	fi
	docker tag raintank/$service raintank/$service:$(git rev-parse --abbrev-ref HEAD) || fail $service
	cd ..
}

if [ "$1" == "help" -o "$1" == "-h" -o "$1" == "--help" ]; then
	echo "$0 # builds all"
	echo "$0 rebuild # rebuilds all"
	echo "$0 <service> # builds service"
	echo "$0 rebuild <service> # rebuilds service"
fi

if [ "$1" == "rebuild" ]; then
	rebuild=1
	shift
fi

if [ -n "$1" ]; then
	build $1
	exit 0
fi

# first build containers on which others depend
build nodejs
build nodejsgo
build worldping_api

# then build the rest
for i in */Dockerfile; do
	i=$(dirname "$i")
	[ -d $i ] && [[ $i != nodejs ]] && [[ $i != nodejsgo ]] && [[ $i != worldping_api ]] && build $i
done
exit 0
