#!/bin/bash
set -e

export BOOTSTRAP_HASKELL_NONINTERACTIVE=true
. ~/.profile

echo -e "\n-= Install GCHUP =-"
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
ghcup upgrade

echo -e "\n-= Install Cabal 3.4.0.0 =-"
ghcup install cabal 3.4.0.0
ghcup set cabal 3.4.0.0

echo -e "\n-= Install GHC 8.10.4 =-"
ghcup install ghc 8.10.4
ghcup set ghc 8.10.4

echo -e "\n-= Test Commands =-"
cabal --version
ghc --version