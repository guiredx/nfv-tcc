apt update && apt install -y iproute2
ovs-vsctl add-port br-client eth0
tc qdisc add dev eth0 root tbf rate 10mbit burst 32kbit latency 400ms