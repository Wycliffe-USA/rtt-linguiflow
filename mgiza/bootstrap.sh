#!/bin/bash

INSTALL_ROOT=$1
INSTALL_USER=$2
if [ -z "${INSTALL_ROOT}" ] || [ -z "${INSTALL_USER}" ]; then
    echo "USAGE: ./bootstrap.sh app_root username"
    echo "Example: ./bootstrap.sh ${HOME} $(whoami)"
    exit 1
fi

#Install mgiza prereqs
apt-get update && apt-get install -y git make build-essential clang libboost-all-dev cmake unzip

#Install gensim/NLTK prereqs
pip install -U numpy
pip install -U scipy
pip install -U nltk
pip install -U gensim
python -m nltk.downloader punkt

# #Compile mgiza
# mkdir /mgiza && cd /mgiza
# git clone https://github.com/moses-smt/mgiza.git
# cd ./mgiza/mgizapp
# cmake . && make && make install

# #post-compile setup
# mkdir ${INSTALL_ROOT}/tools && chown ${INSTALL_USER}:${INSTALL_USER} ${INSTALL_ROOT}/tools
# mkdir -p ${INSTALL_ROOT}/tools/bin/training-tools
# export BINDIR=${INSTALL_ROOT}/tools/bin/training-tools
# sudo rsync -arO ./bin/* $BINDIR/mgizapp
# sudo cp scripts/merge_alignment.py $BINDIR

# #Grab Europarl tools for aligning and cleaning data
# cd ${INSTALL_ROOT}/tools
# wget http://www.statmt.org/europarl/v5/tools.tgz && tar -xf ./tools.tgz
# rm -f ./tools.tgz