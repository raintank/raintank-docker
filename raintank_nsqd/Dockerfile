FROM nsqio/nsq:v0.3.6

EXPOSE 4150
EXPOSE 4151

CMD [ "/nsqd", "-max-msg-size=10024768", "-sync-every=1", "--mem-queue-size=0", "-e2e-processing-latency-percentile=0.90,0.99", "-e2e-processing-latency-window-time=10s", "-statsd-address=statsdaemon:8125", "-statsd-interval=10s" ]
