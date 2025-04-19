apt update
apt upgrade -y
apt dist-upgrade -y
apt update && apt install -y openvswitch-switch
apt update && apt install net-tools


ovs-vsctl add-br br-wan
ip tuntap add mode tap eth_fw
ip tuntap add mode tap eth_bgp

ovs-vsctl add-port br-wan eth_fw
ovs-vsctl add-port br-wan eth_bgp

ip link set br-wan up