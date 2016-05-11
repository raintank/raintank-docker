FROM raintank/nodejsgo

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN mkdir -p /var/spool/carbon-relay-ng

WORKDIR /
ADD proxy.ini /proxy.ini
ADD storage-schemas.conf /storage-schemas.conf
CMD while true; do sleep 10; done  # do just enough to keep the container running
