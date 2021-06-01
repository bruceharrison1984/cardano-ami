#!/bin/bash
set -e

export BOOTSTRAP_HASKELL_NONINTERACTIVE=true

echo "-= Install Cabal =-"
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
cd $HOME
source .bashrc
ghcup upgrade
ghcup install cabal 3.4.0.0
ghcup set cabal 3.4.0.0

echo "-= Install GHC =-"
ghcup install ghc 8.10.4
ghcup set ghc 8.10.4

echo "-= Setup Cardano Env Vars =-"
echo PATH="$HOME/.local/bin:$PATH" >> $HOME/.bashrc
echo export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH" >> $HOME/.bashrc
echo export NODE_HOME=$HOME/cardano-my-node >> $HOME/.bashrc
echo export NODE_CONFIG=mainnet>> $HOME/.bashrc
echo export NODE_BUILD_NUM=$(curl https://hydra.iohk.io/job/Cardano/iohk-nix/cardano-deployment/latest-finished/download/1/index.html | grep -e "build" | sed 's/.*build\/\([0-9]*\)\/download.*/\1/g') >> $HOME/.bashrc
source $HOME/.bashrc

echo "-= Update Cabal =-"
cabal update
cabal --version
ghc --version