#!/bin/bash

BRANCH=$1
MODE=$2

# set the default branch to master if one is not supplied.
if [ x"$BRANCH" == "x" ]; then
	BRANCH=master
fi

if [ x"$MODE" == "x" ]; then
	MODE=docker
fi

if [ "$MODE" == "docker" ]; then
	DIR=$(dirname $0)
	DIR=$(readlink -e $DIR)
	SCRIPT=$(basename $0)
	mkdir -p /opt/raintank
	docker run --rm -t -i -v $DIR:/tmp/scripts -v /opt/raintank:/opt/raintank raintank/nodejs /tmp/scripts/$SCRIPT $BRANCH code

elif [ $MODE == "code" ]; then

	mkdir -p /opt/raintank/node_modules
	cd /opt/raintank
	for i in raintank-docker raintank-collector raintank-workers raintank-core raintank-api raintank-queue grafana; do 
		if [ -d /opt/raintank/$i ]; then
			cd /opt/raintank/$i
			git pull
			git checkout $BRANCH
		else
			cd /opt/raintank
			git clone https://github.com/raintank/$i.git
			git checkout $BRANCH
		fi
	done
	
	if [ ! -e /opt/raintank/node_modules/raintank-core ] ; then
		ln -s /opt/raintank/raintank-core /opt/raintank/node_modules/raintank-core
	fi
	if [ ! -e /opt/raintank/node_modules/raintank-queue ] ; then
		ln -s /opt/raintank/raintank-queue /opt/raintank/node_modules/raintank-queue
	fi

	cd /opt/raintank/raintank-collector
	if [ ! -e config.js ]; then
		cp /opt/raintank/raintank-docker/collector/config.js config.js
	fi
	npm install

	cd /opt/raintank/raintank-queue
	npm install

	cd /opt/raintank/raintank-core
	if [ ! -e node_modules ] ; then
		mkdir node_modules
	fi
	if [ ! -e node_modules/raintank-queue ]; then
		ln -s /opt/raintank/node_modules/raintank-queue node_modules/raintank-queue
	fi
	npm install

	cd /opt/raintank/raintank-api
	if [ ! -e config.js ]; then
                cp /opt/raintank/raintank-docker/api/config.js config.js
        fi

	if [ ! -e node_modules ] ; then
		mkdir node_modules
	fi
	if [ ! -e node_modules/raintank-queue ]; then
		ln -s /opt/raintank/node_modules/raintank-queue node_modules/raintank-queue
	fi
	if [ ! -e node_modules/raintank-core ]; then
		ln -s /opt/raintank/node_modules/raintank-core node_modules/raintank-core
	fi
	npm install

	cd /opt/raintank/raintank-workers
	if [ ! -e config.js ]; then
                cp /opt/raintank/raintank-docker/workers/config.js config.js
        fi

	if [ ! -e node_modules ] ; then
		mkdir node_modules
	fi
	if [ ! -e node_modules/raintank-queue ]; then
		ln -s /opt/raintank/node_modules/raintank-queue node_modules/raintank-queue
	fi
	if [ ! -e node_modules/raintank-core ]; then
		ln -s /opt/raintank/node_modules/raintank-core node_modules/raintank-core
	fi
	npm install

	cd /opt/raintank/grafana
	npm install
	./node_modules/.bin/grunt
fi
