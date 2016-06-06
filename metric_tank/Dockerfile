FROM raintank/nodejsgo

RUN apt-get update

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN mkdir /etc/raintank
COPY config.ini /etc/raintank/
RUN go get -u github.com/raintank/raintank-metric/metric_tank

CMD [ "/go/bin/metric_tank", "-config", "/etc/raintank/config.ini" ]
