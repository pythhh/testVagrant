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

#install nginx
sudo apt update
sudo apt-get -y install nginx
sudo systemctl start nginx 

#install java (Req bf jenkins)
sudo apt -y install openjdk-8-jdk

# install jenkins
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add - # -> import GPG key
sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > \
     /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt-get -y install jenkins
sudo systemctl start jenkins

#opening firewall
sudo ufw allow OpenSSH
sudo ufw allow 8080
sudo ufw allow 8070
sudo ufw allow 8081
sudo ufw allow 443
echo "y" | sudo ufw enable

#Install IQ Server
wget https://download.sonatype.com/clm/server/latest.tar.gz
sudo mkdir /opt/nexus-iq-server
sudo tar -xvzf latest.tar.gz -C /opt/nexus-iq-server/
sudo chown -R vagrant:vagrant /opt/nexus-iq-server/

#Install NXRM3
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo tar -xvzf latest-unix.tar.gz -C /opt/
sudo chown -R vagrant:vagrant /opt/nexus-3.33.0-01/
sudo chown -R vagrant:vagrant /opt/sonatype-work/

#Starting NXRM3
#cd /opt/nexus-3.32.0-03/bin

#Starting IQ Server
# cd /opt/nexus-iq-server
# sudo ./demo.sh

#java -jar nexus-iq-server-1.120.0-02.jar -i sample-app -s http://localhost:8070/ -a admin:admin123