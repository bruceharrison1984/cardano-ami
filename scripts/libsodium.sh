#!/bin/bash
set -e

echo "-= Create $HOME/git and switch to it =-"
mkdir $HOME/git
cd $HOME/git

echo "-= Cloning LibSodium repository =-"
git clone https://github.com/input-output-hk/libsodium

echo "-= Build LibSodium =-"
cd libsodium
git checkout 66f017f1
./autogen.sh
./configure
make
sudo make install
