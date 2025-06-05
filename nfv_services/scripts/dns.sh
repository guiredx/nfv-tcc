#!/bin/bash

# Instala o Bind9
sudo apt update
sudo apt install -y bind9 bind9utils bind9-doc dnsutils apache2

# Ativa a interface e define IP fixo
sudo ip link set eth1 up
sudo ip addr add 10.0.20.10/24 dev eth1

# Configuração principal do Bind9
sudo bash -c 'cat > /etc/bind/named.conf.options' <<EOF
options {
	directory "/var/cache/bind";
	forwarders {
		8.8.8.8;
		1.1.1.1;
	};
	dnssec-validation auto;
	listen-on { any; };
	allow-query { any; };
};
EOF

# Cria zonas locais fictícias
sudo bash -c 'cat > /etc/bind/named.conf.local' <<EOF
zone "lab.local" {
	type master;
	file "/etc/bind/db.lab.local";
};
EOF

# Cria banco de dados da zona lab.local
sudo mkdir -p /etc/bind/zones
sudo bash -c 'cat > /etc/bind/db.lab.local' <<EOF
\$TTL	604800
@   IN  SOA dns.lab.local. root.lab.local. (
            2         ; Serial
        604800         ; Refresh
         86400         ; Retry
       2419200         ; Expire
        604800 )       ; Negative Cache TTL
;
@       IN  NS      dns.lab.local.
dns     IN  A       10.0.20.10
cliente IN  A       10.0.30.100
EOF

# Reinicia o Bind9
sudo systemctl restart bind9
sudo systemctl enable named

# Define rota default para internet simulada via CGNAT
sudo ip route del default
sudo ip route add default via 10.0.20.2 dev eth1

# Ativa IP forwarding
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Adiciona rota de retorno para clientes PPPoE
sudo ip route add 10.0.30.0/24 via 10.0.20.213 dev eth1

# BLOQUEIO E REDIRECIONAMENTO DO INSTAGRAM
echo "Configurando bloqueio do domínio instagram.com e redirecionando para servidor local..."

sudo bash -c 'echo "zone \"instagram.com\" { type master; file \"/etc/bind/zones/db.instagram.com\"; };" >> /etc/bind/named.conf.local'
sudo bash -c 'cat > /etc/bind/zones/db.instagram.com' <<EOF
\$TTL    604800
@   IN  SOA dns.instagram.com. root.instagram.com. (
        1         ; Serial
        604800    ; Refresh
        86400     ; Retry
        2419200   ; Expire
        604800 )  ; Negative Cache TTL
;
@       IN  NS      dns.instagram.com.
dns     IN  A       10.0.20.10
@       IN  A       10.0.20.100
www     IN  A       10.0.20.100
EOF

sudo systemctl restart bind9

echo "✅ DNS configurado com zonas personalizadas"