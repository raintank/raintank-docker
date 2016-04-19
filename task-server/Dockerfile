FROM raintank/nodejsgo
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/raintank-apps/task-server

EXPOSE 80

COPY task-server.ini /etc/raintank/task-server.ini

WORKDIR /
ENTRYPOINT ["/go/bin/task-server"]
CMD ["--config", "/etc/raintank/task-server.ini"]