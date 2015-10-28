#!/bin/bash

# see any errors across the entire dev stack
grep -Ri err logs/ | egrep -v 'compile_regex|initializing metric.*error_state|connection registered without error|graphite-api.*errorlog: -'
