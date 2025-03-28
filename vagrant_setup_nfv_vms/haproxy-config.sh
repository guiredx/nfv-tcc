sudo apt-get update
sudo apt-get install -y haproxy
sudo apt-get install -y openvswitch-switch
sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-port br0 eth1
echo 'global
log /dev/log local0
log /dev/log local1 notice
chroot /var/lib/haproxy
stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
stats timeout 30s
user haproxy
group haproxy
daemon

defaults
log     global
mode    http
option  httplog
option  dontlognull
timeout connect 5000
timeout client  50000
timeout server  50000

frontend http_front
bind *:80
stats uri /haproxy?stats
default_backend http_back

backend http_back
balance roundrobin
server web1 192.168.50.10:80 check
server web2 192.168.50.11:80 check' > /etc/haproxy/haproxy.cfg
sudo systemctl restart haproxy