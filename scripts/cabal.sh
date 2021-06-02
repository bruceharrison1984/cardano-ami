#!/bin/bash
set -e

export BOOTSTRAP_HASKELL_NONINTERACTIVE=true
source ~/.bashrc

echo "-= Install Cabal =-"
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

ghcup upgrade
ghcup install cabal 3.4.0.0
ghcup set cabal 3.4.0.0

echo "-= Install GHC =-"
ghcup install ghc 8.10.4
ghcup set ghc 8.10.4

echo "-= Update Cabal =-"
cabal update
cabal --version
ghc --version