#!/bin/bash
set -e

LATEST_VERSION=$(curl -s https://api.github.com/repos/input-output-hk/cardano-node/releases/latest | jq -r .tag_name)
. ~/.profile

echo -e "\n-= Clone Cardano Node '${LATEST_VERSION}' from source =-"
cd $HOME/git
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git fetch --all --recurse-submodules --tags
git checkout ${LATEST_VERSION}

echo -e "\n-= Set Cabal Build Configuration =-"
cabal configure -O0 -w ghc-8.10.4
echo -e "package cardano-crypto-praos\n flags: -external-libsodium-vrf" > cabal.project.local
sed -i $HOME/.cabal/config -e "s/overwrite-policy:/overwrite-policy: always/g"
rm -rf $HOME/git/cardano-node/dist-newstyle/build/x86_64-linux/ghc-8.10.4

echo -e "\n-= Build Cardano Node '${LATEST_VERSION}' =-"
cabal build cardano-cli cardano-node

echo -e "\n-= Copy binares =-"
sudo cp $(find $HOME/git/cardano-node/dist-newstyle/build -type f -name "cardano-cli") /usr/local/bin/cardano-cli
sudo cp $(find $HOME/git/cardano-node/dist-newstyle/build -type f -name "cardano-node") /usr/local/bin/cardano-node

echo -e "\n-= Test Cardano Binaries =-"
cardano-node version
cardano-cli version