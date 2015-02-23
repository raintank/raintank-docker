FROM raintank/nodejs

WORKDIR /opt

#install api
RUN echo 1424177505; git clone git://github.com/raintank/raintank-workers.git

WORKDIR /opt/raintank-workers
RUN echo 1424177505; npm install
RUN mkdir -p /var/log/raintank/

ADD config.js /opt/raintank-workers/config.js

CMD nodejs /opt/raintank-workers/metricStore.js >> /var/log/raintank/metric.log 2>&1
