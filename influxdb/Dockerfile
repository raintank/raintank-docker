FROM dockerfile/ubuntu

RUN mkdir -p /opt/influxdb/shared/data

ADD http://s3.amazonaws.com/influxdb/influxdb_latest_amd64.deb /influxdb.deb
RUN dpkg -i /influxdb.deb
RUN rm -rf /opt/influxdb/shared/data

ADD config.toml /opt/influxdb/shared/config.toml

ADD setupInfluxdb.sh /tmp/setupInfluxdb.sh
ADD shards.json /tmp/shards.json
RUN chmod a+x /tmp/setupInfluxdb.sh
RUN /tmp/setupInfluxdb.sh

RUN rm -f /tmp/setupInfluxdb.sh
RUN rm -f /tmp/shards.json

EXPOSE 8083 8086 2003
ENTRYPOINT ["/usr/bin/influxdb"]
CMD ["-config=/opt/influxdb/shared/config.toml"]