FROM raintank/workers

RUN mkdir -p /var/log/raintank
WORKDIR /opt/raintank-workers

CMD nodejs /opt/raintank-workers/dispatcher.js >> /var/log/raintank/dispatcher.log 2>&1