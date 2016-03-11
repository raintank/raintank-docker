FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh
RUN go get -u github.com/raintank/raintank-metric/nsq_probe_events_to_elasticsearch

CMD ["/usr/bin/supervisord"]
