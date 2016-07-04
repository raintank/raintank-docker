FROM raintank/nodejsgo
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/raintank-probe

COPY publicChecks.json /publicChecks.json
WORKDIR /
ENTRYPOINT ["/go/bin/raintank-probe"]
CMD ["-log-level", "2", "-public-checks", "/publicChecks.json"]