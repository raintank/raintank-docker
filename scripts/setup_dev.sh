#!/bin/bash

GITHUBURL="https://github.com/"

# set the default branch to master if one is not supplied.
BRANCH=${1:-master}

SOURCE="\
	github.com/raintank/raintank-metric\
	githun.com/grafana/grafana\
	github.com/raintank/raintank-apps\
"

BASE=$(dirname $0)

# important: if you change this, you must also update fig-dev.yaml accordingly
RT_CODE=$(readlink -e "$BASE/../raintank_code")
RT_LOGS=$(readlink -e "$BASE/../logs")
 
 ## GET/UPDATE all of our sourcecode.
cd $RT_CODE
for i in $SOURCE; do
	item=$(basename $i)
	echo "> processing $item"
	if [ -f $RT_CODE/$item/.notouch ]; then
		echo "Skipping due to .notouch"
		continue
	elif [ -d $RT_CODE/$item/.git ]; then
		cd $RT_CODE/$item
		git fetch
		git checkout $BRANCH
		git pull
	else
		cd $RT_CODE
		git clone -b $BRANCH https://$i.git
	fi
done

