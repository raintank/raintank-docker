FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /opt/raintank
WORKDIR /opt/raintank

#install collector-ctrl
RUN echo 1425288058; git clone git://github.com/raintank/raintank-collector-ctrl.git

WORKDIR /opt/raintank/raintank-collector-ctrl
RUN echo 1425288058; npm install

COPY config.json /opt/raintank/raintank-collector-ctrl/config/config.json
EXPOSE 8181

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
