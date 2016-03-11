FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN go get github.com/raintank/raintank-apps/tsdb

COPY start.sh /start.sh

EXPOSE 80

CMD ["/usr/bin/supervisord"]
