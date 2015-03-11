FROM raintank/nodejs

WORKDIR /opt/raintank

ENV GOPATH /go

RUN curl -SL https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz \
    | tar -xzC /usr/local

ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
RUN echo 1426057489 && go get -u github.com/raintank/raintank-metric
COPY raintank.conf /opt/raintank/raintank.conf
CMD raintank-metric -c /opt/raintank/raintank.conf 2>&1
