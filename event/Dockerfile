FROM raintank/nodejs

WORKDIR /opt

#install api
RUN echo 1424674887; git clone git://github.com/raintank/raintank-workers.git

WORKDIR /opt/raintank-workers
RUN echo 1424674887; npm install
RUN mkdir -p /var/log/raintank/

ADD config.js /opt/raintank-workers/config.js

CMD nodejs /opt/raintank-workers/eventWorker.js >> /var/log/raintank/event.log 2>&1
