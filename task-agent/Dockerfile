FROM raintank/nodejsgo
RUN apt-get update && apt-get -y install curl apt-transport-https
RUN echo "deb https://packagecloud.io/raintank/raintank/ubuntu/ trusty main" > /etc/apt/sources.list.d/raintank.list
RUN curl https://packagecloud.io/gpg.key | apt-key add -

RUN apt-get update && apt-get install snap-agent

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

RUN go get github.com/raintank/raintank-apps/task-agent

EXPOSE 8181

RUN mkdir -p /var/log/raintank
COPY task-agent.ini /etc/raintank/task-agent.ini

CMD ["/go/bin/task-agent", "-config", "/etc/raintank/task-agent.ini"]
