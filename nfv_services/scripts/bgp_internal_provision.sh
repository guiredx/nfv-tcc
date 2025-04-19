#!/bin/bash

# Instalar dependências e FRRouting
sudo apt update
sudo apt install -y frr frr-pythontools

# Habilitar os daemons necessários
sudo sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons
sudo sed -i 's/zebra=no/zebra=yes/' /etc/frr/daemons
sudo systemctl restart frr

# Configurar IP adicional na interface interna
sudo ip addr add 10.0.0.1/24 dev enp0s8
sudo ip link set enp0s8 up

# Criar configuração do FRR
cat <<EOF | sudo tee /etc/frr/frr.conf > /dev/null
frr defaults traditional
hostname vm1
log file /var/log/frr/frr.log
service integrated-vtysh-config
!
interface enp0s8
 ip address 192.168.33.10/24
 ip address 10.0.0.1/24
!
router bgp 65001
 bgp router-id 1.1.1.1
 neighbor 192.168.33.11 remote-as 65002
 network 10.0.0.0/24
!
line vty
EOF

# Reiniciar FRR
sudo systemctl restart frr