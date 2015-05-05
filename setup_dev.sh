#!/bin/bash

GITHUBURL="https://github.com/"

# set the default branch to master if one is not supplied.
BRANCH=${1:-master}
MODE=${2:-docker}

RT_CODE="$(pwd)/raintank_code"

if [ "$MODE" == "docker" ]; then
	DIR=$(dirname $0)
	DIR=$(readlink -e $DIR)
	SCRIPT=$(basename $0)
	mkdir -p $RT_CODE
	docker run --rm -t -i -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK -v $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -v $DIR:/tmp/scripts -v $RT_CODE:/opt/raintank -v /root:/root raintank/nodejs /tmp/scripts/$SCRIPT $BRANCH code

elif [ $MODE == "code" ]; then

	mkdir -p /opt/raintank/node_modules
	cd /opt/raintank
	for i in raintank-docker raintank-collector raintank-metric grafana; do 
		if [ -d /opt/raintank/$i ]; then
			cd /opt/raintank/$i
			git fetch
			git checkout $BRANCH
			git pull
		else
			cd /opt/raintank
			git clone -b $BRANCH ${GITHUBURL}raintank/$i.git
		fi
	done

	# start collector
	cd /opt/raintank/raintank-collector
	if [ ! -e config/config.json ]; then
		cp /opt/raintank/raintank-docker/collector/config.json config/config.json
	fi
	npm install
	# end Collector

	# install go
	curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz | tar -xzC /usr/local
	export GOPATH=/go
	export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
	# end 

	cd /opt/raintank/grafana
	npm install
	npm install -g grunt-cli
	grunt

	if [ ! -e conf/custom.ini ]; then
		cp /opt/raintank/raintank-docker/grafana/conf/custom.ini /opt/raintank/grafana/conf/
	fi
fi
