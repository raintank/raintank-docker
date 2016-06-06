FROM raintank/nodejsgo

EXPOSE 8125
EXPOSE 8126

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN go get -u github.com/vimeo/statsdaemon/statsdaemon

COPY conf/statsdaemon.ini /etc/statsdaemon.ini

CMD ["/go/bin/statsdaemon"]
