FROM raintank/nodejsgo

RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN go get -u github.com/raintank/metrictank

RUN mkdir /etc/raintank
ADD storage-schemas.conf /etc/raintank/storage-schemas.conf
ADD metrictank.ini /etc/raintank/metrictank.ini

CMD ["/usr/bin/supervisord"]
