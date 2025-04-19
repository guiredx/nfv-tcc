#!/bin/bash

# Instala FRRouting
sudo apt update
sudo apt install -y frr frr-pythontools

# Ativa serviços do FRR
sudo sed -i 's/^bgpd=no/bgpd=yes/' /etc/frr/daemons
sudo systemctl restart frr

# Configura IPs (evita erro se já estiverem atribuídos)
sudo ip addr show dev eth1 | grep -q 192.168.33.11 || sudo ip addr add 192.168.33.11/24 dev eth1
sudo ip addr show dev eth1 | grep -q 20.0.0.1 || sudo ip addr add 20.0.0.1/24 dev eth1
sudo ip link set dev eth1 up

# Configuração FRR (vm2)
sudo tee /etc/frr/frr.conf > /dev/null <<EOF
frr version 10.3
frr defaults traditional
hostname bgp-external
log file /var/log/frr/frr.log
no ip forwarding
no ipv6 forwarding
service integrated-vtysh-config

interface eth1
 ip address 192.168.33.11/24
 ip address 20.0.0.1/24

router bgp 65002
 bgp router-id 2.2.2.2
 neighbor 192.168.33.10 remote-as 65001

 address-family ipv4 unicast
  network 20.0.0.0/24
  neighbor 192.168.33.10 route-map EXPORT out
 exit-address-family

route-map EXPORT permit 10
 set src 20.0.0.1
!
EOF

# Reinicia serviço
sudo systemctl restart frr