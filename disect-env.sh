# source me
export PUB=$(ls -1tr /var/lib/docker/volumes/*/_data/grafana-dev.log | tail -n 1)
export CON=$(docker inspect $(docker ps | grep nsq_to_kairos | cut -f1 -d' ') | awk '/var\/log\/raintank.*volumes/ {print $2}' | tr -d '"')/nsq-to-kairos.log
export CON2=$(docker inspect $(docker ps | grep nsq_to_kairos | cut -f1 -d' ') | awk '/var\/log\/raintank.*volumes/ {print $2}' | tr -d '"')/nsq-to-kairos2.log
function lookfor () {
  grep "$1" $PUB $CON $CON2
}
