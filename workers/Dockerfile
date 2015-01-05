FROM dockerfile/ubuntu

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install nodejs nodejs-legacy nodejs-dev npm git libzmq3 libzmq3-dev
WORKDIR /opt

#install api
RUN echo 1420429119; git clone git://github.com/raintank/raintank-workers.git

WORKDIR /opt/raintank-workers
RUN echo 1420429119; npm install

ADD config.js /opt/raintank-workers/config.js

WORKDIR /opt/raintank-workers
