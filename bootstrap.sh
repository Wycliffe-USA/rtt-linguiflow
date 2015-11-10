#!/bin/bash
apt-get update
apt-get install -y git make build-essential clang libboost-all-dev cmake
mkdir /mgiza && cd /mgiza
git clone https://github.com/moses-smt/mgiza.git
cd ./mgiza/mgizapp
cmake . && make && make install