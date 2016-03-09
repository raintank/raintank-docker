FROM raintank/golang-service

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN go get -u github.com/vimeo/statsdaemon/statsdaemon

COPY conf/statsdaemon.ini /etc/statsdaemon.ini

CMD ["/usr/bin/supervisord"]
