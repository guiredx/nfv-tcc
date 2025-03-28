sudo apt-get update
sudo apt-get install -y iptables
sudo apt-get install -y openvswitch-switch
sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-port br0 eth1
echo '#!/bin/bash
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# Definir políticas padrão
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir tráfego de loopback
iptables -A INPUT -i lo -j ACCEPT

# Permitir tráfego de conexões estabelecidas e relacionadas
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Permitir tráfego SSH
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Permitir tráfego HTTP
iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# Permitir tráfego HTTPS
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Salvar regras
iptables-save /etc/iptables/rules.v4' 
sudo chmod +x /etc/iptables/rules.v4
sudo /etc/iptables/rules.v4