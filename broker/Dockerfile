FROM raintank/workers

RUN mkdir -p /var/log/raintank
WORKDIR /opt/raintank-workers

EXPOSE 9997 9998 9999

CMD nodejs /opt/raintank-workers/broker.js >> /var/log/raintank/broker.log 2>&1