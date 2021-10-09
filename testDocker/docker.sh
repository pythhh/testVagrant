#!/bin/bash

# Enable ssh password authentication
echo "Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/.*PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Set Root password
echo "Set root password"
echo -e "admin\nadmin" | passwd root >/dev/null 2>&1

# Set local user account
echo "Set up local user account"
useradd -m -s /bin/bash venkatn
echo -e "admin\nadmin" | passwd venkatn >/dev/null 2>&1
echo "venkatn ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Update bashrc file
echo "export TERM=xterm" >> /etc/bashrc

# Install docker using the repo
sudo apt-get update
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Manage docker as non-root user
sudo groupadd docker
sudo usermod -aG docker vagrant

#Install docker compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#download file basic-security.groovy from github
sudo apt-get -y install git
sudo git clone https://github.com/pythhh/testVagrant
touch Dockerfile docker-compose.yml
cp /home/vagrant/testVagrant/docker/Dockerfile Dockerfile
cp /home/vagrant/testVagrant/docker/docker-compose.yml docker-compose.yml

#start docker & docker-compose
docker build .
docker-compose up -d