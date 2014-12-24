#!/bin/sh
exec /sbin/setuser root gunicorn -b 0.0.0.0:8888 -w 2 --log-level debug graphite_api.app:app >>/log/graphite-api.log 2>&1
