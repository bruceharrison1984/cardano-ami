#!/bin/bash
set -e

CLOUDWATCH_CONFIG=/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

echo -e "\n-= Moving setup_scripts in to a more accessible location =-"
sudo mkdir /setup_scripts
sudo mv ~/setup_scripts/* /setup_scripts/
sudo chmod 755 /setup_scripts
sudo ls -lha /setup_scripts

# echo -e "\n-= Switch default Python back to Python3 =-"
# sudo rm -f /usr/bin/python
# sudo ln -s /usr/bin/python2.7 /usr/bin/python

echo -e "\n-= Update OS with latest packages before installing anything else"
sudo add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ focal universe multiverse"
sudo add-apt-repository "deb http://us.archive.ubuntu.com/ubuntu/ focal-updates universe multiverse"
sudo apt-get update -y 
sudo apt-get upgrade -y

echo -e "\n-= Install Cardano Dependencies =-"
sudo apt-get install -y \
  autoconf \
  automake \
  bc \
  build-essential \
  curl \
  g++ \
  git \
  htop \
  jq \
  libffi-dev \
  libgmp-dev \
  libncurses-dev \
  libncursesw5 \
  libssl-dev \
  libsystemd-dev \
  libtinfo-dev \
  libtinfo5 \
  libtool \
  make \
  make \
  pkg-config \
  rsync \
  wget \
  zlib1g-dev

echo -e "\n-= Configure OS auto-updates"
sudo apt-get autoremove
sudo apt-get autoclean

echo -e "\n-= Create Cardano User =-"
sudo useradd -m -s /bin/bash cardano
sudo usermod -aG sudo cardano

echo -e "\n-= Install Cloudwatch Agent =-"
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
sudo cp /setup_scripts/amazon-cloudwatch-agent.json ${CLOUDWATCH_CONFIG}
sudo curl -o ~/amazon-cloudwatch-agent.deb https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ~/amazon-cloudwatch-agent.deb
sudo usermod -aG adm cwagent

echo -e "\n-= Start Cloudwatch Agent =-"
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:${CLOUDWATCH_CONFIG}

echo "-= Setup Cardano Env Vars =-"
echo PATH="~/.cabal/bin/:~/.ghcup/bin/:$PATH" >> ~/.bashrc
echo export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
echo export NODE_HOME=~/cardano-my-node >> ~/.bashrc
echo export NODE_CONFIG=mainnet>> ~/.bashrc
echo export CABAL_PATH=~/.cabal/bin >> ~/.bashrc
echo export NODE_BUILD_NUM=$(curl https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g') >> ~/.bashrc