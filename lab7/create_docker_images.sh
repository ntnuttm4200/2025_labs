#!/bin/bash
SCRIPT_PATH=$(dirname "$0")

# CLEANUP
# Remove all running containers and images
docker stop $(docker ps -a -q) > /dev/null 2>&1
docker rm $(docker ps -a -q) > /dev/null 2>&1
docker rmi $(docker images -q) > /dev/null 2>&1
docker system prune -a --volumes -f > /dev/null 2>&1

# Remove all iptables rules and restore default settings
sudo iptables -t nat -F
sudo iptables -t mangle -F
sudo systemctl restart docker
sudo systemctl restart libvirtd

# IPTABLES
# Webserver
# Mark traffic originating from the VM to external networks (ens3)
sudo iptables -t mangle -A OUTPUT -m conntrack --ctstate NEW -o ens3 -j MARK --set-mark 1

# Exclude VM-originating traffic from redirection
sudo iptables -t nat -A PREROUTING -m mark --mark 1 -j RETURN
sudo iptables -t nat -A POSTROUTING -m mark --mark 1 -j RETURN
  
# Redirect external HTTP (80) traffic to webserver (172.17.0.3)
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -i ens3 -j DNAT --to-destination 172.17.0.3:80
sudo iptables -t nat -A POSTROUTING -p tcp -d 172.17.0.3 --dport 80 -j MASQUERADE
  
# Redirect external HTTPS (443) traffic to webserver (172.17.0.3)
sudo iptables -t nat -A PREROUTING -p tcp --dport 443 -i ens3 -j DNAT --to-destination 172.17.0.3:443
sudo iptables -t nat -A POSTROUTING -p tcp -d 172.17.0.3 --dport 443 -j MASQUERADE
    
# Redirect localhost traffic to webserver
sudo iptables -t nat -A OUTPUT -p tcp -d 127.0.0.1 --dport 80 -j DNAT --to-destination 172.17.0.3:80
sudo iptables -t nat -A OUTPUT -p tcp -d 127.0.0.1 --dport 443 -j DNAT --to-destination 172.17.0.3:443

# Mailserver
# Redirect external SMTP (25) traffic to mailserver (172.17.0.5)
sudo iptables -t nat -A PREROUTING -p tcp --dport 25 -j DNAT --to-destination 172.17.0.5:25
sudo iptables -t nat -A POSTROUTING -p tcp -d 172.17.0.5 --dport 25 -j MASQUERADE

# Redirect external IMAP (143) traffic to mailserver (172.17.0.5)
sudo iptables -t nat -A PREROUTING -p tcp --dport 143 -j DNAT --to-destination 172.17.0.5:143
sudo iptables -t nat -A POSTROUTING -p tcp -d 172.17.0.5 --dport 143 -j MASQUERADE


# DOCKER
# Build the docker images
docker build -t ttm4200_base:v1 $SCRIPT_PATH/images/ttm4200_base
docker build -t lab7_webserver $SCRIPT_PATH/images/webserver
docker build -t lab7_dnsserver $SCRIPT_PATH/images/dnsserver
docker build -t lab7_pclient1 $SCRIPT_PATH/images/pclient1
docker build -t lab7_pclient2 $SCRIPT_PATH/images/pclient2
docker build -t lab7_router0 $SCRIPT_PATH/images/router0
docker build -t lab7_router1 $SCRIPT_PATH/images/router1
docker build -t lab7_router2 $SCRIPT_PATH/images/router2
docker build -t lab7_router3 $SCRIPT_PATH/images/router3

