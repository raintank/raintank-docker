#!/bin/bash

for i in *; do
	if [ -d $i ]; then
		cd $i
		docker build -t raintank/$i .
		cd ..
	fi
done

