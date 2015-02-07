#!/bin/sh

# tTis git repo is private.  The docker host will need to have your 
# github private key and you will need to have been granted access
# to this repo be able to clone.

if [ -e grafana-pro ]; then
	cd grafana-pro
	git pull && git submodule update --recursive && cd ..
else
	git clone -b raintank-api --recursive \
	    git@github.com:torkelo/grafana-pro.git
fi
STATE=$?
if [ $STATE -ne 0 ]; then
	echo "Failed to get grafana-pro repo."
	echo "Check that your github private SSH key is working on this host"
	exit $STATE
fi

docker build -t raintank/grafana-pro ./ 

