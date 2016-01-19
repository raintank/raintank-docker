FROM raintank/grafana

RUN apt-get -y install wget vim bc

RUN cd /go/src/github.com/grafana && \
	git clone https://github.com/raintank/grafana-api-golang-client.git && \
 	cd grafana-api-golang-client && \
 	git checkout raintank && \
 	go get github.com/raintank/env-load

RUN go get github.com/tsenart/vegeta

RUN cd /opt/raintank && \
	git clone https://github.com/raintank/raintank-tsdb-benchmark.git

WORKDIR /opt/raintank/raintank-tsdb-benchmark

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
