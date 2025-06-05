#!/bin/bash

# Atualiza o sistema
sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt install -y iptables iptables-persistent
sudo apt-get install traceroute

# Sobe interfaces (precaução)
sudo ip link set eth1 up
sudo ip link set eth2 up

# Atribui IPs estáticos
sudo ip addr add 10.0.0.2/24 dev eth1   # WAN - conexão com bgp_internal
sudo ip addr add 10.0.1.1/24 dev eth2   # LAN - conexão com CGNAT

# Ativa roteamento de pacotes
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

sudo ip route del default 
# Define rota padrão para Internet via bgp_internal
sudo ip route add default via 10.0.0.1 dev eth1

# Regras básicas de firewall
sudo iptables -F
sudo iptables -t nat -F

# Politicas padrão abertas (para começar, ajustamos depois)
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

INSTAGRAM_IP="157.240.222.174"
sudo iptables -A FORWARD -d $INSTAGRAM_IP -j REJECT

echo "✅ Bloqueio do Instagram configurado"

# WEB_SERVER_LOCAL="10.0.20.100"
# sudo iptables -t nat -A PREROUTING -p tcp -d $INSTAGRAM_IP --dport 80 -j DNAT --to-destination $WEB_SERVER_LOCAL:8080
# sudo iptables -A FORWARD -p tcp -d $WEB_SERVER_LOCAL --dport 8080 -j ACCEPT
# echo "✅ Bloqueio e redirecionamento do Instagram configurado para a porta 8080"

# Salva as regras para persistência
sudo netfilter-persistent save
sudo netfilter-persistent reload