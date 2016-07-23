FROM raintank/nodejsgo

RUN apt-get update && apt-get -y install libfontconfig1 libfreetype6 libjpeg8 libstdc++6
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN mkdir -p /go/src/github.com/raintank/
RUN cd /go/src/github.com/raintank/ && git clone https://github.com/raintank/worldping-api.git
RUN cd /go/src/github.com/raintank/worldping-api && ./rt-pkg/depends.sh
RUN cd /go/src/github.com/raintank/worldping-api && ./rt-pkg/build.sh
RUN cd /go/src/github.com/raintank/worldping-api && go build -o /go/bin/worldping-api

EXPOSE 80
EXPOSE 443

ADD prepare-nsqd.sh /tmp/prepare-nsqd.sh
RUN chmod +x /tmp/prepare-nsqd.sh

RUN mkdir -p /var/log/raintank
COPY conf/worldping.ini /etc/raintank/worldping.ini

CMD ["/usr/bin/supervisord"]
