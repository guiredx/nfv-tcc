sudo apt-get update
sudo apt-get install -y apache2
echo '<!DOCTYPE html><html><head><title>Servidor Web 2</title></head><body><h1>Bem-vindo ao Servidor Web 2!</h1></body></html>' > /var/www/html/index.html
sudo systemctl restart apache2
sudo apt-get install -y openvswitch-switch
sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-port br0 eth1