FROM raintank/nodejs

COPY grafana-pro/ /opt/raintank/grafana-pro
ENV GOPATH /go

RUN curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN go get -u github.com/grafana/grafana
WORKDIR $GOPATH/src/github.com/grafana/grafana
RUN git checkout -t origin/develop \
	go run build.go setup \
	go run build.go build
RUN npm install && npm install -g grunt-cli && grunt -f

ADD grafana.custom.ini $GOPATH/src/github.com/grafana/grafana/conf/grafana.custom.ini
EXPOSE 3000

ADD dump.sql /tmp/dump.sql
RUN apt-get -y install sqlite3 \
    && cat /tmp/dump.sql | sqlite3 $GOPATH/src/github.com/grafana/grafana/data/grafana.db \
    && rm /tmp/dump.sql

CMD cd /opt/raintank/grafana-pro && $GOPATH/src/github.com/grafana/grafana/bin/grafana web
