#!/bin/bash
#getcorpora.sh
INSTALL_HOME=$1
if [ -z "${INSTALL_HOME}" ]; then
    echo "USAGE: ./tokenize.sh app_root"
    echo "Example: ./tokenize.sh ${HOME}"
    exit 1
fi
cd ${INSTALL_HOME}
mkdir ./corpora
cd ./corpora
wget https://s3.amazonaws.com/briggsb/de-en.tgz
tar -xf ./de-en.tgz