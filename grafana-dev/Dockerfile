FROM raintank/grafana

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add script, but don't run it yet. will be run when grafana is running
ADD create-influxdb-dev-datasource.sh /tmp/create-influxdb-dev-datasource.sh
RUN chmod +x /tmp/create-influxdb-dev-datasource.sh

RUN apt-get -y install mysql-client

CMD ["/usr/bin/supervisord"]
