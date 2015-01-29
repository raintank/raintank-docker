FROM raintank/nodejs

COPY grafana-pro/ /opt/grafana-pro
ENV GOPATH /go

WORKDIR /opt/grafana-pro/grafana
RUN npm install && npm install -g grunt-cli && grunt -f

RUN curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
WORKDIR /opt/grafana-pro
RUN mkdir -p /go/src/github.com/torkelo \
    && ln -s /opt/grafana-pro /go/src/github.com/torkelo/grafana-pro \
    && go run build.go setup \
	&& go run build.go build

ADD grafana.custom.ini /opt/grafana-pro/config/
EXPOSE 3000

CMD cd /opt/grafana-pro && /opt/grafana-pro/bin/grafana web
