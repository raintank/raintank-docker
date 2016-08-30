FROM raintank/nodejsgo

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin
#RUN go get -u github.com/raintank/inspect/graphitewatcher
RUN mkdir -p /go/src/github.com/raintank/ && \
	cd /go/src/github.com/raintank/ && \
	git clone https://github.com/raintank/inspect.git && \
	cd inspect && \
	git checkout mt-update && go get github.com/raintank/inspect/graphitewatcher

CMD ["/usr/bin/supervisord"]
