FROM raintank/workers

RUN mkdir -p /var/log/raintank
WORKDIR /opt/raintank-workers

CMD nodejs /opt/raintank-workers/worker.js >> /var/log/raintank/task.log 2>&1
