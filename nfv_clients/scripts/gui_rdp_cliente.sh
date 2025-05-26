#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

echo "[1/5] Atualizando pacotes..."
sudo apt update && sudo apt upgrade -y

echo "[2/5] Instalando interface gráfica XFCE..."
sudo apt install -y xfce4 xfce4-goodies lightdm

echo "[3/5] Instalando XRDP..."
sudo apt install -y xrdp
sudo systemctl enable xrdp
sudo systemctl restart xrdp

echo "[4/5] Configurando XRDP para usar XFCE..."
echo "startxfce4" | sudo tee -a /etc/skel/.xsession
echo "startxfce4" | sudo tee -a /home/vagrant/.xsession
sudo chown vagrant:vagrant /home/vagrant/.xsession

echo "[5/5] Instalando ferramentas PPPoE e rede gráfica..."
sudo apt install -y network-manager-gnome pppoe pppoeconf

echo "Instalação concluída! Acesse via RDP com IP 127.0.0.1:33890 e usuário 'vagrant' / senha 'vagrant'."

# sudo sed -i 's/managed=false/managed=true/' /etc/NetworkManager/NetworkManager.conf || echo -e "[ifupdown]\nmanaged=true" | sudo tee -a /etc/NetworkManager/NetworkManager.conf

sudo bash -c 'cat > /etc/NetworkManager/NetworkManager.conf <<EOF
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
EOF'

sudo systemctl restart NetworkManager