FROM ubuntu:14.04

RUN apt-get update && apt-get -y upgrade && apt-get -y install git curl supervisor gcc

# install golang
RUN curl -SL https://storage.googleapis.com/golang/go1.6.linux-amd64.tar.gz \
    | tar -xzC /usr/local

RUN mkdir -p /go
ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

# use a volume for our log directory so that it is not saved as part of the container.
RUN mkdir -p /var/log/raintank
VOLUME /var/log/raintank

COPY ./wait.sh /usr/local/bin/