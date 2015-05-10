#!/bin/bash

function build () {
	local service=$1
	cd $service
	[ -e build.sh -o -e Dockerfile ] || continue
	echo "##### $service ####"
	if [ -e build.sh ]; then
		echo "##### -> ./build.sh"
		sh build.sh
	elif [ -e Dockerfile ]; then
		echo "##### -> docker build -t raintank/$service ."
		docker build -t raintank/$service .
	fi
	STATE=$?
	if [ $STATE -ne 0 ]; then
		echo "failed building $service. stopping." >&2
		exit $STATE;
	fi
	cd ..
}

# first build containers on which others depend
build nodejs

# then build the rest
for i in *; do
	[ -d $i ] && [[ $i != nodejs ]] && build $i
done
exit 0
