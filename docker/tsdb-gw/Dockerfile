FROM raintank/nodejsgo

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/tsdb-gw

EXPOSE 80

COPY tsdb-gw.ini /etc/raintank/tsdb-gw.ini

WORKDIR /
CMD /go/bin/tsdb-gw --config /etc/raintank/tsdb-gw.ini > /var/log/raintank/tsdb-gw.log 2>&1
