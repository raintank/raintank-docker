FROM raintank/nodejsgo

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/tsdb-gw

EXPOSE 80

COPY tsdb-gw.ini /etc/raintank/tsdb-gw.ini
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /
CMD ["/usr/bin/supervisord"]
