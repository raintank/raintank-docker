FROM raintank/kafka

RUN apt-get update && apt-get install -y netcat

ADD kafkaready.sh /usr/bin/kafkaready.sh
EXPOSE 10101
CMD ["kafkaready.sh"]
