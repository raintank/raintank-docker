FROM raintank/nodejsgo

RUN apt-get update && apt-get -y install supervisor libfontconfig1 libfreetype6 libjpeg8 libstdc++6
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /go/src/github.com/grafana
RUN mkdir -p /go/src/github.com/raintank
RUN ln -s /go/src/github.com/raintank/grafana /go/src/github.com/grafana/grafana

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

# insecure due to bosun.org issue with cloudflare
RUN go get -insecure github.com/raintank/grafana || true
RUN go get github.com/Unknwon/bra
RUN go get github.com/tools/godep
WORKDIR /go/src/github.com/grafana/grafana
RUN go run build.go setup
RUN godep restore
RUN go build .
RUN npm install && npm install -g grunt-cli && grunt build

EXPOSE 80
EXPOSE 443

RUN mkdir -p /var/log/raintank
COPY conf/custom.ini /etc/grafana/custom.ini

CMD ["/usr/bin/supervisord"]
