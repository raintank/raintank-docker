FROM raintank/nodejsgo

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

# insecure due to bosun.org issue with cloudflare
RUN go get github.com/tools/godep
RUN mkdir -p /go/src/github.com/raintank/
RUN cd /go/src/github.com/raintank/ && git clone https://github.com/raintank/worldping-api.git
RUN cd /go/src/github.com/raintank/worldping-api && godep go build -o /go/bin/worldping-api

EXPOSE 80
EXPOSE 443

ADD prepare-nsqd.sh /tmp/prepare-nsqd.sh
RUN chmod +x /tmp/prepare-nsqd.sh

RUN mkdir -p /var/log/raintank
COPY conf/worldping.ini /etc/raintank/worldping.ini

CMD ["/go/bin/worldping-api", "-config", "/etc/raintank/worldping.ini", "web"]
