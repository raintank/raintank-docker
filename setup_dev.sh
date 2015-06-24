#!/bin/bash

GITHUBURL="https://github.com/"

# set the default branch to master if one is not supplied.
BRANCH=${1:-master}
MODE=${2:-docker}

# important: if you change this, you must also update fig-dev.yaml accordingly
RT_CODE="$(pwd)/raintank_code"

if [ "$MODE" == "docker" ]; then
	DIR=$(dirname $0)
	DIR=$(readlink -e $DIR)
	SCRIPT=$(basename $0)
	mkdir -p $RT_CODE

	args=("-v" "$DIR:/tmp/scripts" "-v" "/root:/root")
	cd $RT_CODE
  # assure the directories exist (irrespective of what we'll do with them, see below) so we can set up the volumes
	for i in raintank-docker raintank-collector raintank-metric grafana; do
	  mkdir -p $i
		args=("${args[@]}" "-v" "$RT_CODE/$i:/opt/raintank/$i")
	done
	cd -
	if [ -n "$SSH_AUTH_SOCK" ]; then
		args=("${args[@]}" "-v" $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK)
	fi

	docker run --rm -t -i "${args[@]}" raintank/nodejs /tmp/scripts/$SCRIPT $BRANCH code

elif [ $MODE == "code" ]; then

	mkdir -p /opt/raintank/node_modules
	cd /opt/raintank
	for i in raintank-docker raintank-collector raintank-metric grafana; do
		echo "> processing code for $i"
		if [ -f /opt/raintank/$i/.notouch ]; then
			echo "Skipping due to .notouch"
			continue
		elif [ -d /opt/raintank/$i/.git ]; then
			cd /opt/raintank/$i
			git fetch
			git checkout $BRANCH
			git pull
		else
			cd /opt/raintank
			git clone -b $BRANCH ${GITHUBURL}raintank/$i.git
		fi
	done

  echo "> collector > assuring config"
	cd /opt/raintank/raintank-collector
	if [ ! -e config/config.json ]; then
		cp /opt/raintank/raintank-docker/collector/config.json config/config.json
	fi
	echo "> collector > npm install"
	npm install

	echo "> installing go"
	curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz | tar -xzC /usr/local
	export GOPATH=/go
	export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

	echo "> grafana > npm install"
	cd /opt/raintank/grafana
	npm install
	npm install -g grunt-cli
	echo "> grafana > grunt"
	grunt

  echo "> grafana > assuring config"
	if [ ! -e conf/custom.ini ]; then
		cp /opt/raintank/raintank-docker/grafana/conf/custom.ini /opt/raintank/grafana/conf/
	fi
fi
