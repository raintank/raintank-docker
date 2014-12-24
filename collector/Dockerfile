FROM dockerfile/ubuntu

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install nodejs nodejs-legacy nodejs-dev npm git
WORKDIR /opt

#install collector
RUN echo 1419410278; git clone git://github.com/raintank/raintank-collector.git

WORKDIR /opt/raintank-collector
RUN echo 1419410278; npm install

ADD config.js /opt/raintank-collector/config.js

CMD nodejs /opt/raintank-collector/app.js >> /var/log/raintank/collector.log 2>&1