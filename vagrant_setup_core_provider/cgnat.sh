apt update && apt install -y iptables openvswitch-switch iproute2

# Criando pontes no Open vSwitch
ovs-vsctl add-br br-core
ovs-vsctl add-br br-client

# Aguardar as interfaces estarem disponíveis
sleep 5

# Identificar os nomes reais das interfaces
IF_CORE=$(ip -o link show | awk -F': ' '/enp0s/ {print $2}' | sed -n '1p')
IF_CLIENT=$(ip -o link show | awk -F': ' '/enp0s/ {print $2}' | sed -n '2p')

# Adicionando interfaces às pontes
ovs-vsctl add-port br-core $IF_CORE
ovs-vsctl add-port br-client $IF_CLIENT

# Ativar interfaces
ip link set $IF_CORE up
ip link set $IF_CLIENT up

# Configurar IPs manualmente
ip addr add 192.168.2.2/24 dev $IF_CORE  # Conexão com o backbone (br-core)
ip addr add 192.168.3.1/24 dev $IF_CLIENT  # Conexão com clientes (br-client)

# Configuração do CGNAT (Network Address Translation - NAT)
iptables -t nat -A POSTROUTING -o $IF_CORE -j MASQUERADE