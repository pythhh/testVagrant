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

# #install github clone
# sudo apt-get -y install git-clone
# cd /var/www/html
# sudo git clone https://github.com/bradtraversy/50projects50days

#upload website to nginx server

#install java (Req bf jenkins)
sudo apt -y install default-jre

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
echo "y" | sudo ufw enable

#download file basic-security.groovy from github
sudo apt-get -y install git
sudo git clone https://github.com/pythhh/testVagrant

#create user
cd /var/lib/jenkins/
sudo mkdir init.groovy.d
sudo touch init.groovy.d/basic-security.groovy
sudo cp /home/vagrant/testVagrant/jenkins/createUser.groovy /var/lib/jenkins/init.groovy.d/basic-security.groovy
sudo systemctl restart jenkins

#disable setup wizard
cd /etc/default
echo "JAVA_ARGS=\"-Djenkins.install.runSetupWizard=false\"" >> jenkins
sudo mkdir init.groovy.d
sudo touch basic-security.groovy
sudo cp /home/vagrant/testVagrant/jenkins/createUser.groovy init.groovy.d/basic-security.groovy
sudo systemctl restart jenkins