#!/bin/bash

echo "Atualizando Sistema..."
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install -y iptables iproute2 net-tools iptables-persistent traceroute

# Instala o conntrack, se ainda não estiver presente
sudo apt-get install -y conntrack

echo "Configurando interfaces..."
sudo ip link set dev eth1 up
sudo ip link set dev eth2 up


echo "Atribuindo IPs eth1..."
sudo ip addr add 10.0.1.2/24 dev eth1   # Saída do CGNAT para o Firewall

echo "Atribuindo IPs eth2..."
sudo ip addr add 10.0.20.2/24 dev eth2   # Entrada do tráfego do cliente antes do NAT

echo "Ativando roteamento"
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p


# Adiciona rota padrão para o firewall (10.0.1.1)
sudo ip route del default
sudo ip route add default via 10.0.1.1 dev eth1

# Adiciona rota de retorno para pppoe_server
sudo ip route add 10.0.30.0/24 via 10.0.20.213 dev eth2

# Politicas padrão abertas (para começar, ajustamos depois)
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

# Aplica NAT (CGNAT) da LAN para a WAN
sudo iptables -t nat -A POSTROUTING -s 10.0.20.0/24 -o eth1 -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -s 10.0.30.0/24 -o eth1 -j MASQUERADE


echo "Salvando..."
sudo netfilter-persistent save
sudo netfilter-persistent reload

# # Comandos Manuais:
# sudo stdbuf -oL conntrack -E | awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush(); }'
# sudo stdbuf -oL conntrack -E | awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush(); }' | grep 10.0.30.
# sudo conntrack -L | grep 10.0.30.
# sudo conntrack -E
# sudo conntrack -E -p tcp/icmp