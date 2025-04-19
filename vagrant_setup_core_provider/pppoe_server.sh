apt update && apt install -y iptables
ip link set eth1 up
ip link set eth2 up
ip addr add 192.168.1.2/24 dev eth1
ip addr add 192.168.2.1/24 dev eth2
# Configura regras básicas de firewall e NAT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i eth1 -o eth2 -j ACCEPT
iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE


# apt update && apt install -y iptables
# iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
# iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
# ovs-vsctl add-port br-wan eth0
# ovs-vsctl add-port br-core eth1