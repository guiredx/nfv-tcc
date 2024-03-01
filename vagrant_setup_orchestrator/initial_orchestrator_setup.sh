sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt install openvswitch-switch -y
sudo ovs-vsctl add-br mybridge
sudo ovs-vsctl add-port mybridge lo
# sudo ifconfig mybridge 192.168.56.105 netmask 255.255.255.0 up
sudo ip addr add 192.168.56.105/24 dev mybridge
sudo ip link set mybridge up
# sudo ifconfig mybridge <--- este comando não funciona. A alternativa é executar esse comando: sudo ip addr show mybridge