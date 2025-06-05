#!/bin/bash

# Instala FRRouting
sudo apt update
sudo apt install -y frr frr-pythontools traceroute


# Ativa serviços do FRR (BGP)
sudo sed -i 's/^bgpd=no/bgpd=yes/' /etc/frr/daemons
sudo systemctl restart frr

# Ativa o roteamento IP (IP forwarding no sistema Linux)
sudo sysctl -w net.ipv4.ip_forward=1
sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p


# Configura IPs (evita erro se já estiverem atribuídos)
sudo ip addr show dev eth1 | grep -q 192.168.56.10 || sudo ip addr add 192.168.56.10/24 dev eth1
sudo ip addr show dev eth2 | grep -q 10.0.0.1 || sudo ip addr add 10.0.0.1/24 dev eth2 # Inclui o IP `10.0.0.1/24` na interface `eth2`, permitindo que a VM `firewall` utilize este IP como gateway padrão para a internet na rede `10.0.0.0/24`.

sudo ip link set dev eth1 up
sudo ip link set dev eth2 up


# Rota para CGNAT LAN (clientes)
sudo ip route add 10.0.20.0/24 via 10.0.0.2 dev eth2

# Rota para clientes PPPoE
sudo ip route add 10.0.30.0/24 via 10.0.0.2 dev eth2

# Rota para a rede CGNAT-WAN / Firewall-LAN (caso necessário)
sudo ip route add 10.0.1.0/24 via 10.0.0.2 dev eth2


# Configuração FRR (bgp_internal)
sudo tee /etc/frr/frr.conf > /dev/null <<EOF
frr version 10.3
frr defaults traditional
hostname bgp-internal
log file /var/log/frr/frr.log
ip forwarding
no ipv6 forwarding
service integrated-vtysh-config

interface eth1
 ip address 192.168.56.10/24

interface eth2
 ip address 10.0.0.1/24

router bgp 65001
 bgp router-id 1.1.1.1
 neighbor 192.168.56.11 remote-as 65002

 address-family ipv4 unicast
  neighbor 192.168.56.11 route-map IMPORT in
 exit-address-family

route-map IMPORT permit 10
!
EOF

sudo ip route del default via 10.0.2.2 dev eth0 
# sudo ip route add default via 10.0.2.2 dev eth0


# Reinicia serviço
sudo systemctl restart frr
echo "bgp_internal configurado (modo stub, sem anunciar redes)."