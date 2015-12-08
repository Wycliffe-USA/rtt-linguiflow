#!/bin/bash
apt-get update

#Install mgiza prereqs
apt-get install -y git make build-essential clang libboost-all-dev cmake 

#Install gensim/NLTK prereqs
apt-get install -y python-pip python-scipy
pip install -U nltk
pip install -U gensim

#Compile mgiza
mkdir /mgiza && cd /mgiza
git clone https://github.com/moses-smt/mgiza.git
cd ./mgiza/mgizapp
cmake . && make && make install

#post-compile setup
mkdir /home/vagrant/tools && chown vagrant:vagrant /home/vagrant/tools
mkdir -p /home/vagrant/tools/bin/training-tools
export BINDIR=/home/vagrant/tools/bin/training-tools
sudo rsync -arO ./bin/* $BINDIR/mgizapp
sudo cp scripts/merge_alignment.py $BINDIR

#Grab Europarl tools for aligning and cleaning data
cd /home/vagrant/tools
wget http://www.statmt.org/europarl/v5/tools.tgz && tar -xf ./tools.tgz
rm -f ./tools.tgz
cd /home/vagrant/tools