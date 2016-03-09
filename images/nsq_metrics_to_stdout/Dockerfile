FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN go get -u github.com/Dieterbe/linecounter
RUN go get -u github.com/raintank/raintank-metric/nsq_metrics_to_stdout

CMD ["/usr/bin/supervisord"]
