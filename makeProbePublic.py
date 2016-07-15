#!/usr/bin/python

import json
import requests
import sys
import time 

found = False
while not found:
  data = requests.get("http://localhost/api/v2/probes", headers={"Authorization": "Bearer changeme"}).json()
  probes = data["body"]
  for probe in probes:
    if probe["slug"] == sys.argv[1]:
        found = True
        probe["public"] = True
        resp = requests.put("http://localhost/api/v2/probes", data=json.dumps(probe), headers={"Authorization": "Bearer changeme", "Content-Type": "json"})
  if not found:
    time.sleep(1)
