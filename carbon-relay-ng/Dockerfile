FROM raintank/nodejsgo

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN mkdir -p /go/src/github.com/graphite-ng && cd /go/src/github.com/graphite-ng && git clone --branch routeGrafanaNet --depth 1 https://github.com/graphite-ng/carbon-relay-ng.git && cd carbon-relay-ng && go install
RUN mkdir -p /var/log/spool/carbon-relay-ng

WORKDIR /
ADD proxy.ini /proxy.ini
ADD storage-schemas.conf /storage-schemas.conf
CMD /go/bin/carbon-relay-ng proxy.ini > /var/log/raintank/carbon-relay-ng.log 2>&1
