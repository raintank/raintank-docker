FROM raintank/nodejsgo

RUN apt-get update && apt-get -y install supervisor libfontconfig1 libfreetype6 libjpeg8 libstdc++6
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ENV GOPATH /go
ENV PATH $PATH:/usr/local/go/bin:$GOPATH/bin

# insecure due to bosun.org issue with cloudflare
RUN go get -insecure github.com/raintank/worldping-api

EXPOSE 80
EXPOSE 443

RUN mkdir -p /var/log/raintank
COPY conf/worldping.ini /etc/raintank/worldping.ini

CMD ["/usr/bin/supervisord"]
