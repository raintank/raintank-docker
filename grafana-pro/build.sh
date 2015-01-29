#!/bin/sh

git clone -b raintank-api --recursive \
    git@github.com:torkelo/grafana-pro.git \
    && docker build -t raintank/grafana-pro ./



