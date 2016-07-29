FROM raintank/nodejsgo
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/raintank-apps/task-server

EXPOSE 80

COPY task-server.ini /etc/raintank/task-server.ini
COPY start.sh /start.sh
WORKDIR /
ENTRYPOINT ["/start.sh"]
CMD ["--config", "/etc/raintank/task-server.ini"]