FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh

RUN go get github.com/raintank/raintank-apps/apps-agent

########## install snapd
RUN go get github.com/intelsdi-x/snap

COPY ./snapd.json /etc/raintank/snapd.json

##### install snap plugins
RUN mkdir -p /opt/snap/plugins
RUN go get github.com/raintank/raintank-apps/snap/plugin/snap-publisher-rt-hostedtsdb
RUN go get github.com/raintank/raintank-apps/snap/plugin/snap-collector-rt-gitstats
RUN go get github.com/raintank/raintank-apps/snap/plugin/snap-collector-worldping-ping

RUN cp /go/bin/snap-* /opt/snap/plugins/

EXPOSE 8181

CMD ["/usr/bin/supervisord"]
