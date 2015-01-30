FROM raintank/nodejs

WORKDIR /opt

#install collector
RUN echo 1422597474; git clone git://github.com/raintank/raintank-collector-ctrl.git

WORKDIR /opt/raintank-collector-ctrl
RUN echo 1422597474; npm install

ADD config.js /opt/raintank-collector-ctrl/config.js
EXPOSE 8181

CMD nodejs /opt/raintank-collector-ctrl/app.js >> /var/log/raintank/collector-ctrl.log 2>&1