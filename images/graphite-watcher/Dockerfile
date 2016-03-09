FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN go get -u github.com/raintank/raintank-metric/graphite-watcher

CMD ["/usr/bin/supervisord"]
