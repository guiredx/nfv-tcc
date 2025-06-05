# MONITORAMENTO DO CGNAT EM TEMPO REAL

## ACESSE O CGNAT VIA SSH E EXECUTE UM DOS COMANDOS ABAIXO
sudo conntrack -L

sudo stdbuf -oL conntrack -E | awk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0; fflush(); }' | grep 10.0.30.


## ACESSE A INTERFACE DA VM DO CLIENTE ABRA O TERMINAL E EXECUTE 
ping 8.8.8.8 # monitoramento ICMP
curl yahoo.com # monitoramento TCP