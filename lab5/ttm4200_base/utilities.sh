#!/bin/bash


apt-get update && apt-get install -y \
    curl wget \
    apt-utils \
    net-tools iputils-ping net-tools iproute2 dnsutils \
    vim nano sudo gnupg \
    iptables isc-dhcp-server isc-dhcp-client \
    openssh-server openbsd-inetd traceroute tshark tmux tcpdump \
    macchanger python3 vlc


cp /build/basic.vim /home/ttm4200/.vimrc
#cp /build/.tmux.conf /home/ttm4200/.tmux.conf && chmod +x /home/ttm4200/.tmux.conf
echo 'root:ttm4200' |chpasswd
echo 'ttm4200:ttm4200' |chpasswd
mkdir /var/run/sshd
sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -ri 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config
#sed -ri 's/^#?Port\s+.*/Port 54200/' /etc/ssh/sshd_config
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
mkdir /home/ttm4200/.ssh
cat /build/ssh_keys/ttm4200_vm_key.pub >> /home/ttm4200/.ssh/authorized_keys
cp /build/ssh_keys/ssh_host* /etc/ssh/

echo 'alias python=python3' >> /home/ttm4200/.bashrc

sed -i '/#net.ipv4.ip_forward=1/c\net.ipv4.ip_forward=1' /etc/sysctl.conf
