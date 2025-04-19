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

# Ativa o serviço BGP
sed -i 's/bgpd=no/bgpd=yes/' /etc/frr/daemons

# Cria a configuração BGP da VM2
cat <<EOF > /etc/frr/frr.conf
frr defaults traditional
hostname vm2
log syslog
service integrated-vtysh-config
!
router bgp 65002
 bgp router-id 2.2.2.2
 neighbor 192.168.33.10 remote-as 65001
 network 20.0.0.0/24
!
line vty
EOF

# Define permissões e reinicia o FRR
chown frr:frr /etc/frr/frr.conf
chmod 640 /etc/frr/frr.conf
systemctl enable frr
systemctl restart frr