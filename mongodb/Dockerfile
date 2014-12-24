#
# MongoDB Dockerfile
#
# https://github.com/dockerfile/mongodb
#

# Pull base image.
FROM dockerfile/ubuntu

ADD config/mongodb.conf /config/mongodb.conf

ADD scripts/configure-admin-account.sh /scripts/configure-admin-account.sh
ADD scripts/create-admin-account.js /scripts/create-admin-account.js
ADD scripts/create-user-account.js /scripts/create-user-account.js
ADD scripts/start-mongod.sh /scripts/start-mongod.sh

RUN chmod 755 /scripts/start-mongod.sh
RUN chmod 755 /scripts/configure-admin-account.sh

# Install MongoDB.
RUN \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list && \
  apt-get update && \
  apt-get install -y mongodb-org && \
  mkdir -p /data/db

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /scripts

# Start the server for a first time.
CMD /scripts/start-mongod.sh

# Expose ports.
#   - 27017: process
#   - 28017: http
EXPOSE 27017
EXPOSE 28017
