FROM raintank/nodejs

COPY grafana-pro/ /opt/raintank/grafana-pro
ENV GOPATH /go

WORKDIR /opt/raintank/grafana-pro/grafana
RUN npm install && npm install -g grunt-cli && grunt -f

RUN curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
WORKDIR /opt/raintank/grafana-pro
RUN mkdir -p /go/src/github.com/torkelo \
    && ln -s /opt/raintank/grafana-pro /go/src/github.com/torkelo/grafana-pro \
    && go run build.go setup \
	&& go run build.go build

ADD grafana.custom.ini /opt/raintank/grafana-pro/config/
EXPOSE 3000

ADD dump.sql /tmp/dump.sql
RUN apt-get -y install sqlite3 \
    && cat /tmp/dump.sql | sqlite3 /opt/raintank/grafana-pro/data/grafana.db \
    && rm /tmp/dump.sql

CMD cd /opt/raintank/grafana-pro && /opt/raintank/grafana-pro/bin/grafana web
