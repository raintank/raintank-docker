FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir /etc/raintank
COPY start.sh /start.sh

RUN go get -u github.com/raintank/raintank-metric/metric_tank

EXPOSE 6060

CMD ["/usr/bin/supervisord"]
