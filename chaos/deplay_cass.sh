#!/bin/bash


dir=$(dirname ${BASH_SOURCE[0]})
source "$dir/util.sh"

base=$1
dev=$2
[ -z "$1" ] && base=100
[ -z "$2" ] && dev=50

docker_name=raintankdocker_cassandra_1
if ! docker_running $docker_name; then
    echo "no such container: '$docker_name'" >&2
    die_usage
fi

# get the VETH interface for the container.
iface=$(veth_interface_for_container $docker_name)

# Add traffic control policy.
# http://www.linuxfoundation.org/collaborate/workgroups/networking/netem
sudo tc qdisc delete dev $iface root 2>/dev/null
#sudo tc qdisc add dev $iface parent 1:1 handle 10: tbf rate 256kbit buffer 1600 limit 3000
#sudo tc qdisc add dev $iface root tbf rate 10kbit burst 12kbit latency 10ms peakrate 12kbit minburst 1540
sudo tc qdisc add dev $iface root netem delay 1000ms 100ms distribution normal



