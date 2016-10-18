#!/bin/bash

GITHUBURL="https://github.com/"

# set the default branch to master if one is not supplied.
BRANCH=${1:-master}
MODE=${2:-docker}

# important: if you change this, you must also update fig-dev.yaml accordingly
CODE="$(pwd)/code"
LOGS="$(pwd)/logs"

function assurecode() {
	local repo=$1
	local dir=$2
	echo -n "> processing code for $dir: "
	if [ -f /go/src/github.com/raintank/$dir/.notouch ]; then
		echo ".notouch found -> Skipping"
		continue
	elif [ -d /go/src/github.com/raintank/$dir/.git ]; then
		echo "has a .git dir -> fetch, checkout and pull"
		cd /go/src/github.com/raintank/$dir
		git fetch
		git checkout $BRANCH
		git pull
	else
		echo "no git repo found -> cloning"
		cd /go/src/github.com/raintank
		git clone -b $BRANCH $repo $dir
	fi
}

if [ "$MODE" == "docker" ]; then
	DIR=$(dirname $0)
	DIR=$(readlink -e $DIR)
	SCRIPT=$(basename $0)
	mkdir -p $CODE

	args=("-v" "$DIR:/tmp/scripts" "-v" "/root:/root")
	cd $CODE

	args=("${args[@]}" "-v" "$DIR:/opt/raintank/raintank-docker")
	# assure the directories exist (irrespective of what we'll do with them, see below) so we can set up the volumes
	for i in inspect fakemetrics metrictank eventtank worldping-api raintank-probe raintank-apps carbon-relay-ng tsdb-gw raintank-worldping-app; do
		mkdir -p $i
		args=("${args[@]}" "-v" "$CODE/$i:/go/src/github.com/raintank/$i")
	done
	cd -
	if [ -n "$SSH_AUTH_SOCK" ]; then
		args=("${args[@]}" "-v" $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK)
	fi

	docker run --rm -t -i "${args[@]}" raintank/nodejsgo /tmp/scripts/$SCRIPT $BRANCH code

elif [ $MODE == "code" ]; then
	cd /go/src/github.com/raintank
	for i in inspect fakemetrics metrictank eventtank worldping-api raintank-probe raintank-apps carbon-relay-ng tsdb-gw; do
		assurecode ${GITHUBURL}raintank/$i.git $i
	done
	assurecode ${GITHUBURL}raintank/worldping-app raintank-worldping-app

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
	make bin

fi
