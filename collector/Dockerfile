FROM raintank/nodejs

WORKDIR /opt

#install collector
RUN echo 1422541085; git clone git://github.com/raintank/raintank-collector.git

WORKDIR /opt/raintank-collector
RUN echo 1422541085; npm install

ADD config.js /opt/raintank-collector/config.js

CMD nodejs /opt/raintank-collector/app.js >> /var/log/raintank/collector.log 2>&1