#!/bin/bash
set -e

echo -e "\n-= Install Google Authentication =-"
echo "-= (This needs to be manually setup once you start a server with this image) =-"
sudo apt install libpam-google-authenticator -y

echo "-= Install Fail2Ban =-"
sudo apt-get install fail2ban -y
sudo systemctl restart fail2ban
sudo sh -c 'cat <<EOF > /etc/fail2ban/jail.local
[sshd]
enabled = true
port = ssh
action = iptables-multiport
logpath = /var/log/secure
maxretry = 3
bantime = 600
EOF'



echo "-= Setup first run MOTD =-"
sudo sh -c 'cat <<EOF > /etc/motd
       ____    _    ____  ____    _    _   _  ___          _    __  __ ___ 
      / ___|  / \  |  _ \|  _ \  / \  | \ | |/ _ \        / \  |  \/  |_ _|
     | |     / _ \ | |_) | | | |/ _ \ |  \| | | | |_____ / _ \ | |\/| || | 
     | |___ / ___ \|  _ <| |_| / ___ \| |\  | |_| |_____/ ___ \| |  | || | 
      \____/_/   \_\_| \_\____/_/   \_\_| \_|\___/     /_/   \_\_|  |_|___|
                      * EXPERIMENTAL -USE AT OWN RISK-*

Notes:
- Fail2Ban is installed with a basic configuration
  - This config will ban for 10 minutes. Change it if you desire different behavior
- Google Authenticator is installed
  - This must be manually configured in order to use it
  - RHEL instructions can be found here: https://www.redhat.com/sysadmin/mfa-linux
- POOL_NAME is not set
  - Nodes are relays by default
  - Set it within $CNODE_HOME/scripts/env to make it a block-producer
- CNODE_PORT is set to 6000
  - Change it within $CNODE_HOME/scripts/env
- ec2-user login is enabled in order to securely deploy with AWS SSH keys the first time
  - You can remove/disable this user if you want, but make sure to setup a new SSH user first!
- cardano user has sudo permissions.
  - you probably want to remove these once you get your node up and running

               *disable this message by running "touch $HOME/.hushlogin*
EOF'