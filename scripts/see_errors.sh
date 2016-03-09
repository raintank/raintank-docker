#!/bin/bash


BASE=$(dirname $0)
RT_LOGS=$(readlink -e "$BASE/../logs")


# see any errors across the entire dev stack
grep -Ri err $RT_LOGS/ | egrep -v 'compile_regex|initializing metric.*error_state|connection registered without error|graphite-api.*errorlog: -'
