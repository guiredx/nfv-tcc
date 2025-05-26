#!/bin/bash

set -e

echo "Instalando pacotes necessários para cliente PPPoE..."
sudo apt update
sudo apt install -y ppp pppoeconf iproute2 net-tools

echo "Subindo interface eth1 (ligada à br-lan)..."
sudo ip link set eth1 up

echo "Removendo rota default que vem via NAT (eth1)..."
sudo ip route del default || true

echo "Criando configuração PPPoE em /etc/ppp/peers/cliente..."
sudo tee /etc/ppp/peers/cliente > /dev/null <<EOF
plugin rp-pppoe.so
eth1
user "cliente"
defaultroute
noipdefault
usepeerdns
persist
noauth
EOF

echo "Configurando credenciais PAP para o cliente PPPoE..."
echo '"cliente" * "senha123" *' | sudo tee /etc/ppp/pap-secrets > /dev/null

echo "Iniciando discagem PPPoE via 'pon cliente'..."
sudo pon cliente

sleep 5

echo "Verificando se a interface ppp0 está ativa..."
if ip a show ppp0 | grep -q "inet "; then
    echo "✅ Sessão PPPoE ativa."
else
    echo "❌ A conexão PPPoE falhou. Verifique o servidor."
    exit 1
fi

echo "Exibindo rota default atual:"
ip route | grep default

echo "Testando conectividade com o servidor DNS (10.0.20.10)..."
ping -c 3 10.0.20.10 || echo "⚠️ Falha no ping para o DNS"

echo "Testando conectividade com o BGP External (20.0.0.1)..."
ping -c 3 20.0.0.1 || echo "⚠️ Falha no ping para o BGP External"

echo "✅ Cliente PPPoE conectado e funcional."