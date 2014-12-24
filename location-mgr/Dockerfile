FROM raintank/workers

RUN mkdir -p /var/log/raintank
WORKDIR /opt/raintank-workers
CMD nodejs /opt/raintank-workers/locationManager.js >> /var/log/raintank/locationMgr.log 2>&1
