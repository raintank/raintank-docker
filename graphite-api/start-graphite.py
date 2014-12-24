#!/usr/bin/python
import yaml
import os

stream = open('/etc/graphite-api.yaml', 'r')
config = yaml.load(stream)
stream.close()

def parseEnv(name, value, cnf):
	if name in cnf:
		cnf[name] = value
		return
	parts = name.split('_')
	pos = 0
	found = False
	while not found and pos < len(parts):
		pos = pos + 1
		group = '_'.join(parts[:pos])
		if group in cnf:
			found = True
			parseEnv('_'.join(parts[pos:]), value, cnf[group])

	if not found:
		print "%s not found in config" % name

for name,value in os.environ.items():
	if name.startswith('GRAPHITE_'):
		name = name[9:]
		parseEnv(name, value, config)

stream = open('/etc/graphite-api.yaml', 'w')
yaml.dump(config, stream, default_flow_style=False)
stream.close()

os.system('/usr/local/bin/gunicorn graphite_api.app:app -b 0.0.0.0:8888 -w 2 --log-level debug')