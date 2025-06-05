#!/bin/bash

# Instala FRRouting
sudo apt update
sudo apt install -y frr frr-pythontools traceroute
sudo DEBIAN_FRONTEND=noninteractive apt install -y iptables

# Ativa serviços do FRR
sudo sed -i 's/^bgpd=no/bgpd=yes/' /etc/frr/daemons
sudo systemctl restart frr

# Ativa o IP forwarding no sistema Linux
sudo sysctl -w net.ipv4.ip_forward=1
sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p

# Configura IPs (evita erro se já estiverem atribuídos)
sudo ip addr show dev eth1 | grep -q 192.168.56.11 || sudo ip addr add 192.168.56.11/24 dev eth1
sudo ip addr show dev eth1 | grep -q 20.0.0.1 || sudo ip addr add 20.0.0.1/24 dev eth1
sudo ip link set dev eth1 up

# Adiciona rota de retorno para a rede 10.0.0.0/24 via bgp_internal
sudo ip route add 10.0.0.0/24 via 192.168.56.10 dev eth1

# IPs NATeados
sudo ip route add 10.0.1.0/24 via 192.168.56.10 dev eth1

# Configuração FRR (vm2)
sudo tee /etc/frr/frr.conf > /dev/null <<EOF
frr version 10.3
frr defaults traditional
hostname bgp-external
log file /var/log/frr/frr.log
ip forwarding
no ipv6 forwarding
service integrated-vtysh-config

interface eth1
 ip address 192.168.56.11/24
 ip address 20.0.0.1/24

router bgp 65002
 bgp router-id 2.2.2.2
 neighbor 192.168.56.10 remote-as 65001

 address-family ipv4 unicast
  network 20.0.0.0/24
  neighbor 192.168.56.10 route-map EXPORT out
  neighbor 192.168.56.10 default-originate
 exit-address-family

route-map EXPORT permit 10
!
EOF

# Reinicia serviço

echo "🔧 Configurando NAT (MASQUERADE) para saída pela interface eth0..."
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

echo "🔧 Salvando as regras para persistência..."
sudo netfilter-persistent save
sudo netfilter-persistent reload

sudo systemctl restart frr


echo "bgp_external configurado (simulando provedor com rota default)."