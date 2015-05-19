FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor libfontconfig1 libfreetype6 libjpeg8 libstdc++6
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# add script, but don't run it. for now this is only used in dev stack
ADD create-influxdb-dev-datasource.sh /tmp/create-influxdb-dev-datasource.sh
RUN chmod +x /tmp/create-influxdb-dev-datasource.sh

ENV GOPATH /go

RUN curl -SL https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz \
    | tar -xzC /usr/local

RUN mkdir -p /go/src/github.com/grafana
RUN mkdir -p /go/src/github.com/raintank
RUN ln -s /go/src/github.com/raintank/grafana /go/src/github.com/grafana/grafana

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN go get github.com/raintank/grafana
RUN go get github.com/Unknwon/bra
RUN go get github.com/tools/godep
WORKDIR /go/src/github.com/raintank/grafana
RUN npm install && npm install -g grunt-cli && grunt build

EXPOSE 80
EXPOSE 443

RUN mkdir -p /var/log/raintank
COPY conf/custom.ini /etc/grafana/custom.ini

CMD ["/usr/bin/supervisord"]
