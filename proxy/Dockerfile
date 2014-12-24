
FROM dockerfile/ubuntu
RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

ADD raintank.conf /etc/nginx/sites-enabled/raintank
RUN rm -f /etc/nginx/sites-enabled/default
EXPOSE 80
CMD ["nginx"]
