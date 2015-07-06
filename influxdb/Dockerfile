FROM library/ubuntu

RUN mkdir -p /opt/influxdb/shared/data

RUN apt-get update && apt-get -y upgrade && apt-get -y install curl
RUN curl --location https://s3.amazonaws.com/influxdb/influxdb_0.8.8_amd64.deb -o /influxdb.deb
RUN dpkg -i /influxdb.deb && rm /influxdb.deb
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
