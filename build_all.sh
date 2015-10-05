#!/bin/bash

rebuild=0

function build () {
	[ -e $1/build.sh -o -e $1/Dockerfile ] || return
	local service=$1
  cd $service

  if [ $rebuild -eq 1 ]; then
		echo "##### -> docker rmi raintank/$service ."
		docker rmi raintank/$service
  fi

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

if [ "rebuild" == "$1" ]; then
  echo "rebuild"
  rebuild=1
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
