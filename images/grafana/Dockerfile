FROM raintank/golang-service

RUN apt-get update && apt-get -y install nodejs nodejs-legacy nodejs-dev npm libfontconfig1 libfreetype6 libjpeg8 libstdc++6
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN go get github.com/grafana/grafana || true
WORKDIR /go/src/github.com/grafana/grafana
RUN go run build.go setup
RUN godep restore
RUN go run build.go build
RUN npm install && npm install -g grunt-cli && grunt build

EXPOSE 80
EXPOSE 443

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
