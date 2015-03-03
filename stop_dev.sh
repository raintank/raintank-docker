#!/bin/bash

docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
screen -X -S raintank quit
echo "Stopped docker dev environment"

if [ ! -z $1 ]; then
	if [ $1 == "destroy" ]; then
		docker rmi $(docker images -q)
	fi
	echo "Destroyed docker images"
fi
