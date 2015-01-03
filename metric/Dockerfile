FROM raintank/workers

RUN mkdir -p /var/log/raintank
WORKDIR /opt/raintank-workers

CMD nodejs /opt/raintank-workers/metricStore.js >> /var/log/raintank/metric.log 2>&1
