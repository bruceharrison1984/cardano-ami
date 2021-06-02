#!/bin/bash
set -e

echo -e "\n-= Deleting Build files =-"
rm -rf ${HOME}/git
rm -rf  ${HOME}/.cabal
rm -rf  ${HOME}/.ghcup