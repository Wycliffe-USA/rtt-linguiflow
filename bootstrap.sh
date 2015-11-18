#!/bin/bash
apt-get update
apt-get install -y git make build-essential clang libboost-all-dev cmake
mkdir /mgiza && cd /mgiza
git clone https://github.com/moses-smt/mgiza.git
cd ./mgiza/mgizapp
cmake . && make && make install
mkdir /tools
echo `whoami`
mkdir -p /tools/bin/training-tools
export BINDIR=/tools/bin/training-tools
sudo rsync -arO ./bin/* $BINDIR/mgizapp
sudo cp scripts/merge_alignment.py $BINDIR
cd /tools
wget http://www.statmt.org/europarl/v5/tools.tgz && tar -xf ./tools.tgz
rm -f ./tools.tgz
cd /tools
chmod +x ./getcorpora.sh
