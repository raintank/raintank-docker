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
	for i in inspect fakemetrics metrictank eventtank worldping-api raintank-probe raintank-apps carbon-relay-ng tsdb-gw plugins/worldping-app; do
		mkdir -p $i
		args=("${args[@]}" "-v" "$RT_CODE/$i:/go/src/github.com/raintank/$i")
	done
	cd -
	if [ -n "$SSH_AUTH_SOCK" ]; then
		args=("${args[@]}" "-v" $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK)
	fi

	docker run --rm -t -i "${args[@]}" raintank/nodejsgo /tmp/scripts/$SCRIPT $BRANCH code

elif [ $MODE == "code" ]; then
	cd /go/src/github.com/raintank
	for i in inspect fakemetrics raintank-collector metrictank eventtank worldping-api raintank-probe raintank-apps carbon-relay-ng tsdb-gw plugins/worldping-app; do
		echo "> processing code for $i"
		if [ -f /go/src/github.com/raintank/$i/.notouch ]; then
			echo "Skipping due to .notouch"
			continue
		elif [ -d /go/src/github.com/raintank/$i/.git ]; then
			cd /go/src/github.com/raintank/$i
			git fetch
			git checkout $BRANCH
			git pull
		else
			cd /go/src/github.com/raintank
			git clone -b $BRANCH ${GITHUBURL}raintank/$i.git
		fi
	done

	echo "> configuring go"
	export GOPATH=/go
	export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

	echo "> building raintank-apps binaries"
	cd /go/src/github.com/raintank/raintank-apps
	go get ./...
	./scripts/build_all.sh

    echo "> building raintank-probe"
    cd /go/src/github.com/raintank/raintank-probe
    go get ./...
    make

    echo "> building worldping-api"
    cd /go/src/github.com/raintank/worldping-api
    go get ./...
    go build

    echo "> building metrictank"
    cd /go/src/github.com/raintank/metrictank
    go get ./...
    go build

fi
