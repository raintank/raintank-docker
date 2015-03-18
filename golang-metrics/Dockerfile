FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /opt/raintank

ENV GOPATH /go

RUN curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN go get -u github.com/raintank/raintank-metric

COPY raintank.conf /etc/raintank-metric/raintank.conf

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
