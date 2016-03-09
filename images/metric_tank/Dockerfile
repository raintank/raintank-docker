FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY wait.sh /wait.sh

RUN mkdir /etc/raintank
COPY config.ini /etc/raintank/metric_tank.ini
RUN go get -u github.com/raintank/raintank-metric/metric_tank

CMD ["/usr/bin/supervisord"]
