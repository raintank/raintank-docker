FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN go get github.com/raintank/raintank-apps/tsdb
WORKDIR /go/src/github.com/raintank/raintank-apps/tsdb
RUN go build

COPY ./config.ini /etc/raintank/tsdb.ini

EXPOSE 80

CMD ["/usr/bin/supervisord"]
