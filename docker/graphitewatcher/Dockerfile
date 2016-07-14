FROM raintank/nodejsgo

RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN go get -u github.com/raintank/inspect/graphitewatcher

CMD ["/usr/bin/supervisord"]
