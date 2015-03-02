FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /opt/raintank
WORKDIR /opt/raintank

#install api
RUN echo 1425289957; git clone git://github.com/raintank/raintank-workers.git

WORKDIR /opt/raintank/raintank-workers
RUN echo 1425289957; npm install
RUN mkdir -p /var/log/raintank/

ADD config.js /opt/raintank/raintank-workers/config.js

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
