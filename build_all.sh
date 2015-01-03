#!/bin/bash

for i in $(ls -r); do
	if [ -d $i ]; then
		cd $i
		docker build -t raintank/$i .
		cd ..
	fi
done

