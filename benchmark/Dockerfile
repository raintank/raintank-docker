FROM raintank/nodejsgo

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN apt-get -y install wget vim bc supervisor
RUN mkdir -p /go/src/github.com/grafana
RUN cd /go/src/github.com/grafana && \
	git clone https://github.com/raintank/grafana-api-golang-client.git && \
 	cd grafana-api-golang-client && \
 	git checkout raintank #&& \
 	#go get github.com/raintank/env-load

RUN go get github.com/tsenart/vegeta
RUN go get github.com/raintank/raintank-metric/inspect-es
RUN go get github.com/raintank/raintank-metric/fake_metrics

RUN cd /opt/raintank && \
	git clone https://github.com/raintank/raintank-tsdb-benchmark.git

WORKDIR /opt/raintank/raintank-tsdb-benchmark

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
