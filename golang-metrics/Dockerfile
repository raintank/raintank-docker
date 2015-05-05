FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor curl
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV GOPATH /go

RUN curl -SL https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN go get -u github.com/raintank/raintank-metric

COPY conf/raintank.conf /etc/raintank-metric/raintank.conf

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
