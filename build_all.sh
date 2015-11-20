#!/bin/bash

rebuild=0

function build () {
	[ -e $1/build.sh -o -e $1/Dockerfile ] || return
	local service=$1
  cd $service

	echo "##### $service ####"
	if [ -e build.sh ]; then
		echo "##### -> ./build.sh"
		sh build.sh
	elif [ -e Dockerfile ]; then
		echo "##### -> docker build -t raintank/$service ."
    if [ $rebuild -eq 1 ]; then
      docker build --no-cache -t raintank/$service .
    else
      docker build -t raintank/$service .
    fi
    # -f because docker will complain if the id->name mapping already exists, which is not an issue with docker build -t
    docker tag -f raintank/$service raintank/$service:$(git rev-parse --abbrev-ref HEAD)
	fi
	STATE=$?
	if [ $STATE -ne 0 ]; then
		echo "failed building $service. stopping." >&2
		exit $STATE;
	fi
	cd ..
}

if [ -n "$1" ]; then
	if [ "$1" == "rebuild" ]; then
	  rebuild=1
	else
		build $1
		exit 0
	fi
fi

# first build containers on which others depend
build nodejs
build nodejsgo
build grafana

# then build the rest
for i in *; do
	[ -d $i ] && [[ $i != nodejs ]] && [[ $i != nodejsgo ]] && [[ $i != grafana ]] && build $i
done
exit 0
