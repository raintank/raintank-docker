function docker_running () {
	docker ps | awk '{print $NF}' | grep -q "^$1\$"
}

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
