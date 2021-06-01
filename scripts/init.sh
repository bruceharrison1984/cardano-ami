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

echo "-= Create Cardano User =-"
sudo useradd -m -s /bin/bash cardano
sudo usermod -aG sudo cardano