FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /opt/raintank
WORKDIR /opt/raintank

#install collector
RUN echo 1425289957; git clone git://github.com/raintank/raintank-collector.git

WORKDIR /opt/raintank/raintank-collector
RUN echo 1425289957; npm install

COPY config.json /opt/raintank/raintank-collector/config/config.json

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
