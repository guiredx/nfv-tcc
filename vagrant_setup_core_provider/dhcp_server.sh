apt update && apt install -y isc-dhcp-server
ovs-vsctl add-port br-client eth0
echo 'subnet 192.168.3.0 netmask 255.255.255.0 {
range 192.168.3.100 192.168.3.200;
option routers 192.168.3.1;
option domain-name-servers 192.168.3.3;
}' > /etc/dhcp/dhcpd.conf
systemctl restart isc-dhcp-server