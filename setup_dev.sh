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
	docker run --rm -t -i -v $DIR:/tmp/scripts -v /opt/raintank:/opt/raintank -v /root:/root raintank/nodejs /tmp/scripts/$SCRIPT $BRANCH code

elif [ $MODE == "code" ]; then

	mkdir -p /opt/raintank/node_modules
	cd /opt/raintank
	for i in raintank-docker raintank-collector raintank-workers raintank-queue; do 
		if [ -d /opt/raintank/$i ]; then
			cd /opt/raintank/$i
			git fetch
			git checkout $BRANCH
			git pull
		else
			cd /opt/raintank
			git clone -b $BRANCH https://github.com/raintank/$i.git
		fi
	done

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

	cd /opt/raintank/raintank-workers
	if [ ! -e config.js ]; then
        cp /opt/raintank/raintank-docker/metric/config.js config.js
    fi

	if [ ! -e node_modules ] ; then
		mkdir node_modules
	fi
	if [ ! -e node_modules/raintank-queue ]; then
		ln -s /opt/raintank/node_modules/raintank-queue node_modules/raintank-queue
	fi
	npm install


	curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz | tar -xzC /usr/local

	export GOPATH=/opt/raintank/go
	export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

	cd /opt/raintank
	git clone -b raintank-api --recursive git@github.com:torkelo/grafana-pro.git
	cd grafana-pro
	mkdir -p /opt/raintank/go/src/github.com/torkelo \
    && ln -s /opt/raintank/grafana-pro /opt/raintank/go/src/github.com/torkelo/grafana-pro \
    && go run build.go setup \
	&& go run build.go build
	
	cd grafana
	npm install
	npm install -g grunt-cli
	grunt -f

	apt-get -y install sqlite3
	sqlite3 /opt/raintank/grafana-pro/data/grafana.db < /opt/raintank/raintank-docker/grafana-pro/dump.sql
fi
