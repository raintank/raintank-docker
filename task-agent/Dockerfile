FROM raintank/nodejsgo
RUN apt-get -y install curl apt-transport-https supervisor
RUN echo "deb https://packagecloud.io/raintank/raintank/ubuntu/ trusty main" > /etc/apt/sources.list.d/raintank.list
RUN curl https://packagecloud.io/gpg.key | apt-key add -

RUN apt-get update && apt-get install snap-agent

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/raintank-apps/task-agent

EXPOSE 8181

RUN mkdir -p /var/log/raintank
COPY task-agent.ini /etc/raintank/task-agent.ini

CMD ["/usr/bin/supervisord"]
