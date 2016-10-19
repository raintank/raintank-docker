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
	if [ -f /go/src/github.com/$dir/.notouch ]; then
		echo ".notouch found -> Skipping"
		continue
	elif [ -d /go/src/github.com/$dir/.git ]; then
		echo "has a .git dir -> fetch, checkout and pull"
		cd /go/src/github.com/$dir
		git fetch
		git checkout $BRANCH
		git pull
	else
		echo "no git repo found -> cloning"
		cd /go/src/github.com/
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
	for i in inspect fakemetrics metrictank eventtank worldping-api raintank-probe tsdb-gw raintank-worldping-app; do
		mkdir -p $i
		args=("${args[@]}" "-v" "$CODE/$i:/go/src/github.com/raintank/$i")
	done

	i=carbon-relay-ng
	mkdir -p $i
	args=("${args[@]}" "-v" "$CODE/$i:/go/src/github.com/graphite-ng/$i")

	cd -
	if [ -n "$SSH_AUTH_SOCK" ]; then
		args=("${args[@]}" "-v" $SSH_AUTH_SOCK:$SSH_AUTH_SOCK -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK)
	fi

	docker run --rm -t -i "${args[@]}" raintank/nodejsgo /tmp/scripts/$SCRIPT $BRANCH code

elif [ $MODE == "code" ]; then
	for i in inspect fakemetrics metrictank eventtank worldping-api raintank-probe tsdb-gw; do
		assurecode ${GITHUBURL}raintank/$i.git raintank/$i
	done
	assurecode ${GITHUBURL}raintank/worldping-app raintank/raintank-worldping-app

	assurecode ${GITHUBURL}graphite-ng/carbon-relay-ng graphite-ng/carbon-relay-ng

	echo "> configuring go"
	export GOPATH=/go
	export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin


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

	echo "> building carbon-relay-ng"
	cd /go/src/github.com/graphite-ng/carbon-relay-ng
	go build
fi
