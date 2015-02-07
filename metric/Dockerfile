FROM raintank/nodejs

WORKDIR /opt
RUN mkdir -p /opt/raintank-workers
WORKDIR /opt/raintank-workers

ADD config.js /opt/raintank-workers/config.js

RUN curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN go get -u github.com/raintank/raintank-metric

CMD raintank-metric 2>&1
