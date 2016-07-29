FROM raintank/nodejsgo

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/tsdb-gw

EXPOSE 80

COPY tsdb-gw.ini /etc/raintank/tsdb-gw.ini
COPY start.sh /start.sh

WORKDIR /
ENTRYPOINT ["/start.sh"]
CMD ["-config", "/etc/raintank/tsdb-gw.ini"]
