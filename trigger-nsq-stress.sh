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
log "open http://localhost:4171/topic/metrics to monitor state"
log "let it running for 1 minute.."
sleep 60

log "STEP 4. kill nsq-to-kairos"
docker exec raintankdocker_nsqtokairos_1 pkill -f nsq_to_kairos
log "wait 5 minutes"
sleep 300

log "STEP 5. restarting nsq_to_kairos"
screen -S raintank -p nsqtokairos -X stuff './nsq_to_kairos --topic metrics --channel tokairos --nsqd-tcp-address nsqd:4150 2>&1 | tee /var/log/raintank/nsq-to-kairos2.log\n'
log "wait another minute..."
sleep 60

log "STEP 6. stop grafana aka producer"
docker exec raintankdocker_grafana_1 supervisorctl stop all
log "please open http://localhost:4171/topic/metrics and confirm that no more messages are in flight/depth/requeued"
log "press enter to continue"
read

log "STEP 7. killing nsq_to_kairos as well, again"
docker exec raintankdocker_nsqtokairos_1 pkill -f nsq_to_kairos
log "STEP 8. have fun disecting the logs"

# TODO:
# issues seen:
# * when restarting nsq_to_kairos, nsqadmin doesn't tell any producers or channels!
# 1 requeued message stuck for.. > 10min ? but amountof messages actually works out fine
# io timeout
# all messages seem to have made it across, but not in kairos -> kairos bug?
# some message id's only in CON, not PUB

