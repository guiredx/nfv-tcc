apt update
apt upgrade -y
apt dist-upgrade -y
apt update && apt install -y iptables



# DEPOIS QUE SUBIR AS MÁQUINAS COM O vagrant up, EXECUTE ESSES COMANDOS:
###sudo ip addr add 10.10.10.2/24 dev eth1
###sudo ip link set eth1 up

# ip link set eth1 up
# ip link set eth2 up

# echo 1 > /proc/sys/net/ipv4/ip_forward

# # Regras básicas de NAT e firewall
# iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
# iptables -A FORWARD -i eth1 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
# iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT


# Configura regras básicas de firewall e NAT
# iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A FORWARD -i eth1 -o eth2 -j ACCEPT
# iptables -t nat -A POSTROUTING -o eth2 -j MASQUERADE


# apt update && apt install -y iptables
# iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
# iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
# ovs-vsctl add-port br-wan eth0
# ovs-vsctl add-port br-core eth1