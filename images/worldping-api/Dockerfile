FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start.sh /start.sh

RUN go get github.com/mattn/go-sqlite3
RUN go install github.com/mattn/go-sqlite3
RUN go get github.com/raintank/raintank-apps/worldping-api

EXPOSE 80

CMD ["/usr/bin/supervisord"]
