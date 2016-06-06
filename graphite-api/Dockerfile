FROM library/ubuntu

RUN apt-get update && apt-get upgrade -y && apt-get install -y supervisor build-essential python-dev libffi-dev libcairo2-dev python-pip-whl=8.1.1-2 python-pip=8.1.1-2 git

RUN pip install gunicorn Flask-Cache elasticsearch statsd

RUN echo 1448597559 \
    && pip install git+https://github.com/raintank/graphite-api.git \
	&& pip install git+https://github.com/raintank/graphite-raintank.git

RUN mkdir -p /var/lib/graphite
EXPOSE 8888
ADD graphite-api.yaml /etc/graphite-api.yaml

ADD start-graphite.py /usr/bin/start-graphite.py
RUN chmod a+x /usr/bin/start-graphite.py

RUN mkdir -p /var/log/raintank
VOLUME /var/log/raintank

CMD ["/usr/bin/start-graphite.py"]
