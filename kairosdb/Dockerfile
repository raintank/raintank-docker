FROM library/java:7

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install python supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# KairosDB
RUN curl --location https://github.com/kairosdb/kairosdb/releases/download/v0.9.4/kairosdb_0.9.4-6_all.deb -o /kairosdb_all.deb
RUN dpkg -i /kairosdb_all.deb && rm -f /kairosdb_all.deb

ADD kairosdb.properties /opt/kairosdb/conf/kairosdb.properties.tmpl
EXPOSE 4242 8080

ADD start_kairosdb.py /usr/bin/start_kairosdb.py
RUN chmod a+x /usr/bin/start_kairosdb.py

RUN mkdir -p /var/log/raintank
CMD ["/usr/bin/supervisord"]
