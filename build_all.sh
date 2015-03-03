#!/bin/bash

for i in $(ls -r); do
	if [ -d $i ]; then
		cd $i
		if [ -e build.sh ]; then
			sh build.sh
		elif [ -e Dockerfile ]; then
			docker build -t raintank/$i .
		fi
		STATE=$?
		if [ $STATE -ne 0 ] ;then 
		  echo "failed building ${i}. stopping."
		  exit $STATE;
		fi 
		cd ..
	fi
done

