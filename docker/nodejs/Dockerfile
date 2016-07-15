FROM ubuntu

RUN apt-get update && apt-get -y upgrade && apt-get -y install nodejs nodejs-legacy nodejs-dev npm git curl
RUN npm install -g npm

# target directory for all applications
RUN mkdir /opt/raintank

# use a volume for our log directory so that it is not saved as part of the container.
VOLUME /var/log/raintank

