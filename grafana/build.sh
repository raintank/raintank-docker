#!/bin/sh

# tTis git repo is private.  The docker host will need to have your 
# github private key and you will need to have been granted access
# to this repo be able to clone.

if [ -e grafana ]; then
	cd grafana
	git pull && git submodule update --recursive && cd ..
else
	git clone --recursive \
	    git@github.com:raintank/grafana.git
fi
STATE=$?
if [ $STATE -ne 0 ]; then
	echo "Failed to get grafana repo."
	echo "Check that your github private SSH key is working on this host"
	exit $STATE
fi

docker build -t raintank/grafana ./ 

