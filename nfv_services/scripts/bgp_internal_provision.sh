#!/bin/bash

# Instala FRRouting
sudo apt update
sudo apt install -y frr frr-pythontools

# Ativa serviços do FRR
sudo sed -i 's/^bgpd=no/bgpd=yes/' /etc/frr/daemons
sudo systemctl restart frr

# Configura IPs (evita erro se já estiverem atribuídos)
sudo ip addr show dev eth1 | grep -q 192.168.33.10 || sudo ip addr add 192.168.33.10/24 dev eth1
sudo ip link set dev eth1 up

# Configuração FRR (vm1)
sudo tee /etc/frr/frr.conf > /dev/null <<EOF
frr version 10.3
frr defaults traditional
hostname bgp-internal
log file /var/log/frr/frr.log
no ip forwarding
no ipv6 forwarding
service integrated-vtysh-config

interface eth1
 ip address 192.168.33.10/24

router bgp 65001
 bgp router-id 1.1.1.1
 neighbor 192.168.33.11 remote-as 65002

 address-family ipv4 unicast
  neighbor 192.168.33.11 route-map IMPORT in
  network 10.0.0.0/24
 exit-address-family

route-map IMPORT permit 10
!
EOF

# Reinicia serviço
sudo systemctl restart frr