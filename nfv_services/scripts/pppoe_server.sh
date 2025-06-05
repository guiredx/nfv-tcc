#!/bin/bash

set -e

echo "Atualizando e instalando pacotes necessários..."
sudo apt update
sudo apt install -y ppp pppoe iproute2 net-tools
sudo apt-get install traceroute


echo "Ativando interface eth1..."
sudo ip link set dev eth1 up
sudo ip addr add 10.0.20.213/24 dev eth1


# sudo ip route del default via 10.0.2.15 dev eth0 
# sudo ip route add default via 10.0.2.2 dev eth0
# sudo ip route add 10.0.20.0/24 dev eth1

# Adiciona rota padrão para o cgnat (10.0.20.2)
sudo ip route del default
sudo ip route add default via 10.0.20.2 dev eth1



echo "Configurando opções do servidor PPPoE..."

sudo mkdir -p /etc/ppp
sudo rm -rf /etc/ppp/pppoe-server-options
sudo tee /etc/ppp/pppoe-server-options > /dev/null <<EOF
require-pap
login
lcp-echo-interval 10
lcp-echo-failure 2
ms-dns 10.0.20.10
proxyarp
nobsdcomp
novj
EOF

echo "Criando usuário 'cliente' para autenticação local com senha..."
sudo useradd -s /bin/false -m cliente || true
echo "cliente:senha123" | sudo chpasswd

# Garantir que o pppd esteja configurado para usar login
sudo sed -i 's/^#\? *login/login/' /etc/ppp/options

echo "Iniciando servidor PPPoE na eth1 com IP local 10.0.30.1 e faixa para clientes 10.0.30.100-199..."
sudo pkill -f pppoe-server || true
sudo pppoe-server -I eth1 -L 10.0.30.1 -R 10.0.30.100 -N 100

# Verifica se subiu corretamente
sleep 1
if pgrep -f "pppoe-server -I eth1" > /dev/null; then
    echo "✅ Servidor PPPoE iniciado com sucesso."
else
    echo "❌ Falha ao iniciar o pppoe-server. Verifique a interface ou a configuração."
    exit 1
fi

echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf