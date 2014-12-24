#!/bin/bash

LOG_FILE=/var/log/mongodb.log
# Initialize a mongo data folder and logfile
mkdir -p /data/db
touch $LOG_FILE

# Launch admin configuration in background.
/scripts/configure-admin-account.sh &

# Start mongodb with logging
# --logpath    Without this mongod will output all log information to the standard output.
# --logappend  Ensure mongod appends new entries to the end of the logfile. We create it first so that the below tail always finds something
ARGS=" --config /config/mongodb.conf"
/usr/bin/mongod $ARGS | tee $LOG_FILE
