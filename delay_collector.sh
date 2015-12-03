#!/bin/bash
# Apply traffic shaping rules to add latency to all requests from the collector container.

function die_usage () {
    echo "usage: $0 [collector-id] [base] [dev]" >&2
    echo "default collector-id: dev1"
    echo "default base: 100 (ms)"
    echo "default dev: 50 (ms)"
    exit
}

[ "$1" == '-h' -o "$1" == "--help" ] && die_usage

id=$1
base=$2
dev=$3
[ -z "$1" ] && id=dev1
[ -z "$2" ] && base=100
[ -z "$3" ] && dev=50

docker_name=raintankdocker_raintankCollector_$id
if ! docker ps | awk '{print $NF}' | grep -q "^${docker_name}$"; then
    echo "no such container: '$docker_name'" >&2
    die_usage
fi

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
  ip link show | grep "^${index}:" | sed -e "s/${index}: \(.*\):.*/\1/" -e "s#@.*##"

  # Clean up the netns symlink, since we don't need it anymore
  sudo rm -f "/var/run/netns/${1}"
}

# get the VETH interface for the container.
iface=$(veth_interface_for_container $docker_name)

# Add traffic control policy.
# http://www.linuxfoundation.org/collaborate/workgroups/networking/netem
sudo tc qdisc delete dev $iface root 2>/dev/null
sudo tc qdisc add dev $iface root netem delay ${base}ms ${dev}ms distribution normal


