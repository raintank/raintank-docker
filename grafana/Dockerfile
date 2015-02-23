FROM raintank/nodejs

WORKDIR /opt/raintank
RUN echo 1424675800 && git clone git://github.com/raintank/grafana.git

ENV GOPATH /go

RUN curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
WORKDIR /opt/raintank/grafana
RUN echo 1424675800 && mkdir -p /go/src/github.com/grafana \
    && ln -s /opt/raintank/grafana /go/src/github.com/grafana/grafana \
    && go run build.go setup \
	&& go run build.go build
RUN echo 1424675800 &&  npm install && npm install -g grunt-cli && grunt -f

ADD grafana.custom.ini /opt/raintank/grafana/conf/grafana.custom.ini
EXPOSE 3000

CMD cd /opt/raintank/grafana && /opt/raintank/grafana/bin/grafana web
