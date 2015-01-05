FROM dockerfile/ubuntu

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install nodejs nodejs-legacy nodejs-dev npm git libzmq3 libzmq3-dev
WORKDIR /opt

#install api
RUN echo 1420430805;  git clone git://github.com/raintank/raintank-api.git

RUN echo 1420430805;  git clone git://github.com/raintank/grafana.git

WORKDIR /opt/raintank-api
RUN echo 1420430805; npm install

WORKDIR /opt/grafana
RUN echo 1420430805; npm install
RUN echo 1420430805; ./node_modules/.bin/grunt --force

ADD config.js /opt/raintank-api/config.js

WORKDIR /opt/raintank-api
EXPOSE 4000

RUN mkdir -p /var/log/raintank

CMD nodejs /opt/raintank-api/app.js >> /var/log/raintank/api.log 2>&1
