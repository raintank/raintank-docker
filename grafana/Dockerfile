FROM raintank/nodejs

RUN apt-get update && apt-get -y install supervisor libfontconfig1 libfreetype6 libjpeg8 libstdc++6
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /opt/raintank
RUN echo 1427269853 && git clone git://github.com/raintank/grafana.git

ENV GOPATH /go

RUN curl -SL https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
WORKDIR /opt/raintank/grafana
RUN echo 1425289957 && mkdir -p /go/src/github.com/grafana \
    && ln -s /opt/raintank/grafana /go/src/github.com/grafana/grafana \
    && go run build.go setup \
	&& go run build.go build
RUN echo 1425289957 &&  npm install && npm install -g grunt-cli && grunt
RUN apt-get update && apt-get install -y mysql-client

EXPOSE 3000

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
