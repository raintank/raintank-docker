#!/bin/bash
# Apply traffic shaping rules to add latency to all requests from the collector container.

dir=$(dirname ${BASH_SOURCE[0]})
source "$dir/util.sh"

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

docker_name=raintank_raintankCollector_$id
if ! docker_running $docker_name; then
    echo "no such container: '$docker_name'" >&2
    die_usage
fi

# get the VETH interface for the container.
iface=$(veth_interface_for_container $docker_name)

# Add traffic control policy.
# http://www.linuxfoundation.org/collaborate/workgroups/networking/netem
sudo tc qdisc delete dev $iface root 2>/dev/null
sudo tc qdisc add dev $iface root netem delay ${base}ms ${dev}ms distribution normal


