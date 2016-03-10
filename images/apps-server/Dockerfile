FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN go get github.com/mattn/go-sqlite3
RUN go install github.com/mattn/go-sqlite3
RUN go get github.com/raintank/raintank-apps/apps-server

COPY ./config.ini /etc/raintank/apps-server.ini

EXPOSE 80

CMD ["/usr/bin/supervisord"]
