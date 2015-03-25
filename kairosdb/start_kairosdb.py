#!/usr/bin/python
from string import Template
import os

PROPERTIES_FILE="/opt/kairosdb/conf/kairosdb.properties"

params = {
	"HOST_LIST": "localhost:9160",
	"KEYSPACE": "kairosdb",
	"REPLICATION_FACTOR": 1,
	"WRITE_DELAY": 1000,
	"WRITE_BUFFER_MAX_SIZE": 500000,
}

for name,value in os.environ.items():
	if name.startswith('KDB_'):
		name = name[4:]
		if name in params:
			params[name] = value

config = None
with open(PROPERTIES_FILE+".tmpl") as stream:
	config = Template(stream.read())

with open(PROPERTIES_FILE, 'w') as stream:
	stream.write(config.safe_substitute(params))

# start kairosDB
os.system('/opt/kairosdb/bin/kairosdb.sh run')



