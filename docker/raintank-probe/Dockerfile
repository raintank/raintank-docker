FROM raintank/nodejsgo
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/raintank-probe
RUN mkdir -p /etc/raintank
RUN cp /go/src/github.com/raintank/raintank-probe/publicChecks.json /etc/raintank/publicChecks.json
COPY start.sh /start.sh
WORKDIR /
ENTRYPOINT ["/start.sh"]
CMD ["-log-level", "2"]