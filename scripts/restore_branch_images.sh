#!/bin/bash

branch=$(git rev-parse --abbrev-ref HEAD)

for service in $(docker images | grep "^raintank/.* $branch " | awk '{print $1}'); do
  # -f in case mapping already exists
  echo docker tag -f $service:$branch $service:latest
  docker tag -f $service:$branch $service:latest
done

