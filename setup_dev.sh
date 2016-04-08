#!/bin/bash

GITHUBURL="https://github.com/"

# set the default branch to master if one is not supplied.
BRANCH=${1:-master}
MODE=${2:-docker}

# important: if you change this, you must also update fig-dev.yaml accordingly
RT_CODE="$(pwd)/raintank_code"
RT_LOGS="$(pwd)/logs"

if [ "$MODE" == "docker" ]; then
	DIR=$(dirname $0)
	DIR=$(readlink -e $DIR)
	SCRIPT=$(basename $0)
	mkdir -p $RT_CODE

	args=("-v" "$DIR:/tmp/scripts" "-v" "/root:/root")
	cd $RT_CODE
  args=("${args[@]}" "-v" "$DIR:/opt/raintank/raintank-docker")
  # assure the directories exist (irrespective of what we'll do with them, see below) so we can set up the volumes
	for i in raintank-collector raintank-metric plugins worldping-api; do
	  mkdir -p $i
		args=("${args[@]}" "-v" "$RT_CODE/$i:/opt/raintank/$i")
	done
	cd -
	if [ -n "$SSH_AUTH_SOCK" ]; then
		args=("${args[@]}" "-v" $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK)
	fi

	docker run --rm -t -i "${args[@]}" raintank/nodejsgo /tmp/scripts/$SCRIPT $BRANCH code

elif [ $MODE == "code" ]; then

	mkdir -p /opt/raintank/node_modules
	cd /opt/raintank
	for i in raintank-collector raintank-metric worldping-api raintank-probe; do
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

    # install grafana plugins
    mkdir -p /opt/raintank/plugins/
    for i in worldping-app; do
		echo "> processing code for grafana plugin $i"
        if [ -f /opt/raintank/plugins/$i/.notouch ]; then
           echo "Skipping due to .notouch"
           continue
        elif [ -d /opt/raintank/plugins/$i/.git ]; then
            cd /opt/raintank/plugins/$i
            git fetch
            git checkout $BRANCH
            git pull
        else
            cd /opt/raintank/plugins
            git clone -b $BRANCH ${GITHUBURL}raintank/$i.git
        fi
    done

	echo "> configuring go"
	export GOPATH=/go
	export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

    echo "> collector > assuring config"
	cd /opt/raintank/raintank-collector
	if [ ! -e etc/raintank.json ]; then
		cp /opt/raintank/raintank-docker/collector/config.json etc/raintank.json
	fi
	echo "> collector > build"
	#./pkg/build.sh
	npm install
	go get -u -f github.com/raintank/raintank-probe
    cp $(which raintank-probe) .
fi
