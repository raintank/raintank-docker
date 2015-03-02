FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /opt

#install collector
RUN echo 1425289957; git clone git://github.com/raintank/raintank-collector.git

WORKDIR /opt/raintank-collector
RUN echo 1425289957; npm install

ADD config.js /opt/raintank-collector/config.js

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
