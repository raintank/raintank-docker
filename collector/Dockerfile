FROM raintank/nodejsgo


RUN apt-get update && apt-get -y install supervisor
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN mkdir -p /opt/raintank
WORKDIR /opt/raintank

#install collector
RUN echo 1429107514; git clone git://github.com/raintank/raintank-collector.git

WORKDIR /opt/raintank/raintank-collector
RUN echo 1429107514; npm install

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get -u github.com/raintank/raintank-probe
RUN cp $GOPATH/bin/raintank-probe .

COPY config.json /opt/raintank/raintank-collector/etc/raintank.json

RUN mkdir -p /var/log/raintank

CMD ["/usr/bin/supervisord"]
