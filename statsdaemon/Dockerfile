FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV GOPATH /go

RUN curl -SL https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN go get -u github.com/vimeo/statsdaemon/statsdaemon

COPY conf/statsdaemon.ini /etc/statsdaemon.ini

CMD ["/usr/bin/supervisord"]
