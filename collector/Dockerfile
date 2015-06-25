FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor fping
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /opt/raintank
WORKDIR /opt/raintank

#install collector
RUN echo 1429107514; git clone git://github.com/raintank/raintank-collector.git

WORKDIR /opt/raintank/raintank-collector
RUN echo 1429107514; npm install

COPY config.json /opt/raintank/raintank-collector/etc/raintank.json

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
