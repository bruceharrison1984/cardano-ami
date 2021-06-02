#!/bin/bash
set -e

echo "-= Cloning LibSodium repository =-"
cd $HOME/git
git clone https://github.com/input-output-hk/libsodium

echo "-= Build LibSodium =-"
cd libsodium
git checkout 66f017f1
./autogen.sh
./configure
make
sudo make install
