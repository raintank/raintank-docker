#!/bin/bash

function log () {
  echo "$(date +'%F %H:%M:%S') $1"
}

log "STEP 1. starting stack"
./launch_dev.sh
log "stack is launched."

log "STEP 2. waiting for grafana to compile and run.."
while ! pgrep grafana-server; do
  sleep 1
done

log "STEP 3. stack is running. in particular grafana and nsq_to_kairos:"
pgrep -fl grafana-server
pgrep -fl nsq_to_kairos
log "now waiting for grafana to start publishing.."
log "open http://localhost:4171/topic/metrics to monitor state"
while ! docker exec rt_grafana_1 grep -q 'published metrics' /var/log/raintank/grafana-dev.log; do
  sleep 1
done

log "STEP 4. publishing started"
log "let it running for 1 minute.."
sleep 60

log "STEP 5. kill nsq-to-kairos"
docker exec rt_nsqtokairos_1 pkill -f nsq_to_kairos
log "wait 5 minutes"
sleep 300

log "STEP 6. restarting nsq_to_kairos"
screen -S raintank -p nsqtokairos -X stuff './nsq_to_kairos --topic metrics --channel tokairos --nsqd-tcp-address nsqd:4150 2>&1 | tee /var/log/raintank/nsq-to-kairos2.log\n'
log "wait another minute..."
sleep 60

log "STEP 7. stop grafana aka producer"
# this would be the cleanest, but doesn't work properly due to https://github.com/Unknwon/bra/issues/4
#docker exec raintankdocker_grafana_1 supervisorctl stop all
# luckily this works too (bra doesn't restart it)
docker exec rt_grafana_1 pkill -f grafana-server
log "please open http://localhost:4171/topic/metrics and http://localhost:4171/topic/metrics-lowprio and confirm that no more messages are in flight/depth/requeued"
log "press enter to continue"
read

log "STEP 8. killing nsq_to_kairos as well, again"
docker exec rt_nsqtokairos_1 pkill -f nsq_to_kairos
log "STEP 9. have fun disecting the logs"
