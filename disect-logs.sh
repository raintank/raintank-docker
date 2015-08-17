#!/bin/bash
# the sed is to strip color escape sequences
dupes=$(awk '/DIETERPUBLISHED/ {print $5}' $PUB | sort | uniq -c | sed 's/\x1B\[[0-9;]*[JKmsu]//g' | grep -v '1 ')
if [ -n "$dupes" ]; then
  echo "ERROR: duplicate message ID's found :("
  echo "$dupes"
        echo "test failed."
  exit 1
fi

echo "FYI: long submissions (should not have caused drops)"
grep 'loop duration' $PUB | egrep -v '(.|1.|2.|3.)\.[0-9]+ms'

awk '/DIETERPUBLISHED/ {print $5}' $PUB | sort -n | uniq | sed 's/\x1B\[[0-9;]*[JKmsu]//g' > pub-ids.txt
awk '/DIETER/ {print $5}' $CON $CON2 | sort -n | uniq > con-ids.txt

echo "counted this many id's in pub and con:"

wc -l pub-ids.txt con-ids.txt

echo "diff pub-ids con-ids:"

diff pub-ids.txt con-ids.txt

