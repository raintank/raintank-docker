FROM raintank/workers

RUN mkdir -p /var/log/raintank
WORKDIR /opt/raintank-workers

CMD nodejs /opt/raintank-workers/eventWorker.js >> /var/log/raintank/event.log 2>&1