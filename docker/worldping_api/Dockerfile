FROM raintank/nodejsgo


ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN mkdir -p /go/src/github.com/raintank/
RUN cd /go/src/github.com/raintank/ && git clone https://github.com/raintank/worldping-api.git
RUN cd /go/src/github.com/raintank/worldping-api && make
RUN cp /go/src/github.com/raintank/worldping-api/build/worldping-api /go/bin/worldping-api

EXPOSE 80
EXPOSE 443

COPY conf/worldping.ini /etc/raintank/worldping.ini
COPY start.sh /start.sh
ENTRYPOINT ["/start.sh"] 
CMD ["-config", "/etc/raintank/worldping.ini"]
