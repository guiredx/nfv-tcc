# 🚀 Configura servidor web local para exibir "Site Bloqueado"
sudo mkdir -p /var/www/bloqueado
echo "<html><head><title>Site Bloqueado</title></head><body><h1>Este site está bloqueado!</h1></body></html>" | sudo tee /var/www/bloqueado/index.html
cd /var/www/bloqueado
nohup python3 -m http.server 80 &

echo "✅ DNS configurado com zonas personalizadas e bloqueio de site implementado"