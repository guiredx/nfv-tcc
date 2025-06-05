# sudo apt update
# sudo apt upgrade -y
# sudo apt dist-upgrade -y
# sudo apt update && apt install -y openvswitch-switch
# sudo apt update && apt install net-tools

# Cria as bridges (se ainda não existir)
sudo ovs-vsctl add-br br-wan
sudo ovs-vsctl add-br br-cgnat-fw
sudo ovs-vsctl add-br br-lan

# Cria interfaces TAP (uma para cada interface da VM firewall)
sudo ip tuntap add mode tap tap-bgp-wan
sudo ip tuntap add mode tap tap-fw-wan
sudo ip tuntap add mode tap tap-fw-lan
sudo ip tuntap add mode tap tap-cgnat-fw
sudo ip tuntap add mode tap tap-cgnat-lan


# Ativa as TAPs
sudo ip link set tap-bgp-wan up
sudo ip link set tap-fw-wan up
sudo ip link set tap-fw-lan up
sudo ip link set tap-cgnat-fw up
sudo ip link set tap-cgnat-lan up

# Conecta as TAPs nas bridges
## firewall
sudo ovs-vsctl add-port br-wan tap-fw-wan
sudo ovs-vsctl add-port br-cgnat-fw tap-fw-lan

## bgp_internal
sudo ovs-vsctl add-port br-wan tap-bgp-wan

## cgnat
sudo ovs-vsctl add-port br-cgnat-fw tap-cgnat-fw
sudo ovs-vsctl add-port br-lan tap-cgnat-lan

# TAP para DNS
sudo ip tuntap add dev tap-dns mode tap
sudo ip link set tap-dns up
sudo ovs-vsctl add-port br-lan tap-dns

# PPPoE Server
sudo ip tuntap add dev tap-pppoe mode tap
sudo ip link set tap-pppoe up
sudo ovs-vsctl add-port br-lan tap-pppoe

# Cliente
sudo ip tuntap add dev tap-client mode tap
sudo ip link set tap-client up
sudo ovs-vsctl add-port br-lan tap-client
