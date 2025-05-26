#!/bin/bash

echo "[NETWORK FIX] Removendo ifupdown e liberando interfaces para o NetworkManager..."

# 1. Remover o ifupdown
sudo apt purge -y ifupdown

# 2. Comentar includes no /etc/network/interfaces
sudo sed -i 's/^source /#source /' /etc/network/interfaces

# 3. Garantir que o arquivo do NetworkManager esteja correto
sudo bash -c 'cat > /etc/NetworkManager/NetworkManager.conf <<EOF
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
EOF'

# 4. Reiniciar o serviço
sudo systemctl restart NetworkManager

# 5. Esperar para garantir o carregamento
sleep 5

# 6. Ativar as interfaces manualmente (caso estejam DOWN)
sudo ip link set eth0 up || true
sudo ip link set eth1 up || true

# 7. Reforçar como "managed" explicitamente
sudo nmcli device set eth0 managed yes || true
sudo nmcli device set eth1 managed yes || true

echo "[NETWORK FIX] Concluído. Use 'nmcli device' para verificar se estão gerenciadas."
