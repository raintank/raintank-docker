FROM raintank/nodejsgo

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/raintank-apps/tsdb

EXPOSE 80

COPY tsdb.ini /etc/raintank/tsdb.ini

WORKDIR /
CMD /go/bin/tsdb --config /etc/raintank/tsdb.ini > /var/log/raintank/tsdb.log 2>&1
