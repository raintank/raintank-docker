FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /opt

#install collector
RUN echo 1425288058; git clone git://github.com/raintank/raintank-collector-ctrl.git

WORKDIR /opt/raintank-collector-ctrl
RUN echo 1425288058; npm install

ADD config.js /opt/raintank-collector-ctrl/config.js
EXPOSE 8181

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
