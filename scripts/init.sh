#!/bin/bash
set -e

echo -e "\n-= Update existing packages =-"
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum update -y
sudo yum install -y jq moreutils git
sudo -H pip3 install yq 
sudo amazon-linux-extras install postgresql10

echo -e "\n-= Install Fail2Ban =-"
sudo yum install -y fail2ban
sudo systemctl enable fail2ban
sudo sh -c 'cat <<EOF > /etc/fail2ban/jail.d/sshd.local
[sshd]
enabled = true
port = ssh
action = iptables-multiport
logpath = /var/log/secure
maxretry = 3
bantime = 600
EOF'
## start fail2ban so we can grant cwagent access to the logs
sudo systemctl start fail2ban

echo -e "\n-= Create ${USERNAME} user account"
sudo adduser ${USERNAME} -m -s /bin/bash
sudo passwd -d ${USERNAME}

echo -e "\n-= Create ${NODE_HOME} directory =-"
sudo mkdir ${NODE_HOME} -p

echo -e "\n-= Make ec2-user owner of ${NODE_HOME} directory for installation =-"
sudo chown -R ec2-user ${NODE_HOME}

echo -e "\n-= Create ${NODE_HOME} subdirectories =-"
mkdir ${NODE_HOME}/scripts -p
mkdir ${NODE_HOME}/snapshots -p
mkdir ${NODE_HOME}/keys -p
mkdir ${NODE_HOME}/config -p
mkdir ${NODE_HOME}/db -p
mkdir ${NODE_HOME}/ipc -p
mkdir ${NODE_HOME}/logs -p
mkdir ${NODE_HOME}/sync/schema -p

echo -e "\n-= Create dummy PGPASS file =-"
cp ${HOME}/setup/config/pgpass-mainnet ${NODE_HOME}/config/pgpass-mainnet
chmod 600 ${NODE_HOME}/config/pgpass-mainnet

echo -e "\n-= Create .env Script =-"
envsubst '${NODE_HOME} ${NODE_CONFIG}' < ${HOME}/setup/scripts/.env > ${NODE_HOME}/scripts/.env.tmp
mv ${NODE_HOME}/scripts/.env.tmp ${NODE_HOME}/scripts/.env
chmod +x ${NODE_HOME}/scripts/.env