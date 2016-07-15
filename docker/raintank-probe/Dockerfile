FROM raintank/nodejsgo
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/raintank-probe
RUN mkdir -p /etc/raintank
RUN cp /go/src/github.com/raintank/raintank-probe/publicChecks.json /etc/raintank/publicChecks.json
WORKDIR /
ENTRYPOINT ["/go/bin/raintank-probe"]
CMD ["-log-level", "2"]