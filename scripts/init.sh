#!/bin/bash
set -e

CLOUDWATCH_CONFIG=/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

echo -e "\n-= Moving setup_scripts in to a more accessible location =-"
sudo mkdir /setup_scripts
sudo mv ${HOME}/setup_scripts/* /setup_scripts/
sudo chmod 755 /setup_scripts

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
sudo curl -o ${HOME}/amazon-cloudwatch-agent.deb https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
sudo dpkg -i -E ${HOME}/amazon-cloudwatch-agent.deb
sudo usermod -aG adm cwagent

echo -e "\n-= Start Cloudwatch Agent =-"
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:${CLOUDWATCH_CONFIG}

echo -e "\n-= Setup Cardano Env Vars =-"
echo export LD_LIBRARY_PATH="/usr/local/lib:${LD_LIBRARY_PATH}" >> ${HOME}/.profile
echo export NODE_HOME=${HOME}/cardano >> ${HOME}/.profile
echo export NODE_CONFIG=mainnet >> ${HOME}/.profile
echo export CABAL_PATH=${HOME}/.cabal/bin/ >> ${HOME}/.profile
echo export PATH="${HOME}/.ghcup/bin/:${CABAL_PATH}:${PATH}" >> ${HOME}/.profile
echo export NODE_BUILD_NUM=$(curl https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g') >> ${HOME}/.profile

echo "\n-= Create ${HOME}/git =-"
mkdir ${HOME}/git