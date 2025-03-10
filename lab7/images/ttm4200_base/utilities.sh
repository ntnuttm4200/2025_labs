#!/bin/bash

apt-get update && apt-get install -y \
    curl wget \
    apt-utils \
    net-tools iputils-ping net-tools iproute2 dnsutils \
    vim nano sudo gnupg \
    isc-dhcp-client \
    openssh-server openbsd-inetd traceroute tmux tcpdump \
    macchanger lsb-release



cp /build/.bashrc /home/ttm4200/.bashrc
echo 'source /home/ttm4200/.bashrc' | tee -a /etc/profile

cp /build/save.sh /home/ttm4200/save.sh
chmod +x /home/ttm4200/save.sh

echo 'root:ttm4200' | chpasswd
echo 'ttm4200:ttm4200' | chpasswd

# Add passwordless sudo for ttm4200 for vtysh, nft and tee
# used for the .bashrc script
echo 'ttm4200 ALL=(ALL) NOPASSWD: /usr/bin/vtysh, /usr/sbin/nft, /usr/bin/tee' | tee /etc/sudoers.d/ttm4200
chown root:root /etc/sudoers.d/ttm4200
chmod 440 /etc/sudoers.d/ttm4200

mkdir /var/run/sshd
sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -ri 's/^#?PasswordAuthentication\s+.*/PasswordAuthentication no/' /etc/ssh/sshd_config
#sed -ri 's/^#?Port\s+.*/Port 54200/' /etc/ssh/sshd_config
sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
mkdir /home/ttm4200/.ssh
cat /build/ssh_keys/ttm4200_vm_key.pub >> /home/ttm4200/.ssh/authorized_keys
cp /build/ssh_keys/ssh_host* /etc/ssh/

