#!/bin/bash
set -x
# launch a collector with an auto-assigned id, based on an incrementing counter, and hook it into the screen session
# don't run this script concurrently

highest=$(docker ps | grep raintankdocker_raintankCollector_dev | sed 's#.*raintankdocker_raintankCollector_dev##' | sort -n | tail -n 1)
docker ps | grep raintankdocker_raintankCollector_dev
# if no containers yet, start at 1
[ -z "$highest" ] && highest=0
id=dev$((highest+1))

docker_name=raintankdocker_raintankCollector_$id

eval $(grep ^RT_CODE setup_dev.sh)

docker run --link=raintankdocker_grafana_1:grafana \
           -v $RT_CODE/raintank-collector:/opt/raintank/raintank-collector \
           -e RAINTANK_collector_name=$id -d \
           --name=$docker_name \
           -h collector-$id \
           raintank/collector

screen -S raintank -X screen -t collector-$id docker exec -t -i $docker_name bash
screen -S raintank -p collector-$id -X stuff 'supervisorctl restart all; touch /var/log/raintank/collector.log\n'
screen -S raintank -p collector-$id -X stuff 'tail -10f /var/log/raintank/collector.log\n'

while true; do
  data=$(curl -s -X GET -H "Authorization: Basic YWRtaW46YWRtaW4=" 'http://localhost/api/collectors')
  if grep -q "\"$id\"" <<< "$data"; then
    break
  fi
  echo "waiting for collector $id to be known to grafana..."
  sleep 1
done
mysql_id=$(sed 's#.*"id":\([0-9]\+\),"org_id":[0-9]\+,"slug":"'$id'".*#\1#' <<< "$data")
# make it a "public" collector so different orgs can use it
curl -X POST -H "Authorization: Basic YWRtaW46YWRtaW4=" -F "public=true" -F "enabled=true" -F "name=$id" -F "id=$mysql_id" 'http://localhost/api/collectors'
echo


# Apply traffic shaping rules to add latency to all requests from the collector container.

# http://stackoverflow.com/questions/21724225/docker-how-to-get-veth-bridge-interface-pair-easily/28613516#28613516
function veth_interface_for_container() {
  # Get the process ID for the container named ${1}:
  local pid=$(docker inspect -f '{{.State.Pid}}' "${1}")

  # Make the container's network namespace available to the ip-netns command:
  sudo mkdir -p /var/run/netns
  sudo ln -sf /proc/$pid/ns/net "/var/run/netns/${1}"

  # Get the interface index of the container's eth0:
  local index=$(sudo ip netns exec "${1}" ip link show eth0 | head -n1 | sed s/:.*//)
  # Increment the index to determine the veth index, which we assume is
  # always one greater than the container's index:
  let index=index+1

  # Write the name of the veth interface to stdout:
  ip link show | grep "^${index}:" | sed "s/${index}: \(.*\):.*/\1/"

  # Clean up the netns symlink, since we don't need it anymore
  sudo rm -f "/var/run/netns/${1}"
}

# get the VETH interface for the container.
iface=$(veth_interface_for_container $docker_name)

# Add traffic control policy. 
# http://www.linuxfoundation.org/collaborate/workgroups/networking/netem
sudo tc qdisc add dev $iface root netem delay 100ms 20ms distribution normal
