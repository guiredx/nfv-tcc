#!/bin/bash

# Atualiza e instala dependências
apt-get update
apt-get install -y curl gnupg2 lsb-release

# Adiciona o repositório oficial do FRR
curl -s https://deb.frrouting.org/frr/keys.asc | gpg --dearmor > /usr/share/keyrings/frr.gpg
echo "deb [signed-by=/usr/share/keyrings/frr.gpg] https://deb.frrouting.org/frr $(lsb_release -sc) frr-stable" \
  > /etc/apt/sources.list.d/frr.list

# Instala o FRRouting
apt-get update
apt-get install -y frr frr-pythontools


# # Ativa o serviço BGP
# sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons

# Habilitar os daemons necessários (New)
sudo sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons
sudo sed -i 's/zebra=no/zebra=yes/' /etc/frr/daemons
sudo systemctl restart frr


# Configurar IP adicional na interface interna (new)
sudo ip addr add 10.0.0.1/24 dev enp0s8
sudo ip link set enp0s8 up

# # Cria a configuração BGP da VM1
# cat <<EOF > /etc/frr/frr.conf
# frr defaults traditional
# hostname vm1
# log syslog
# service integrated-vtysh-config
# !
# router bgp 65001
#  bgp router-id 1.1.1.1
#  neighbor 192.168.33.11 remote-as 65002
#  network 10.0.0.0/24
# !
# line vty
# EOF

# Define permissões e reinicia o FRR
chown frr:frr /etc/frr/frr.conf
chmod 640 /etc/frr/frr.conf
systemctl enable frr
systemctl restart frr
