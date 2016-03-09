FROM raintank/grafana

RUN apt-get -y install wget vim bc

#RUN go get github.com/raintank/env-load

RUN go get github.com/tsenart/vegeta
RUN mkdir -p /opt/raintank
RUN cd /opt/raintank && \
	git clone https://github.com/raintank/raintank-tsdb-benchmark.git

WORKDIR /opt/raintank/raintank-tsdb-benchmark

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
