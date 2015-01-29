FROM dockerfile/ubuntu

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y build-essential python-dev libffi-dev libcairo2-dev python-pip git
RUN pip install gunicorn Flask-Cache elasticsearch

RUN echo 1422541085 \
    && pip install git+https://github.com/raintank/graphite-api.git \
	&& pip install git+https://github.com/raintank/graphite-influxdb.git

RUN mkdir -p /var/lib/graphite
EXPOSE 8888
ADD graphite-api.yaml /etc/graphite-api.yaml
RUN mkdir /log
VOLUME /log
ADD start-graphite.py /usr/bin/start-graphite.py
RUN chmod a+x /usr/bin/start-graphite.py
CMD start-graphite.py