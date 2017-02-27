#!/bin/bash
#getcorpora.sh
INSTALL_HOME=$1
if [ -z "${INSTALL_HOME}" ]; then
    echo "USAGE: ./getcorpora.sh app_root"
    echo "Example: ./getcorpora.sh ${HOME}"
    exit 1
fi
cd ${INSTALL_HOME}
mkdir ./corpora
cd ./corpora
#wget https://s3.amazonaws.com/briggsb/de-en.tgz && tar -xf ./de-en.tgz
mkdir ./asv && cd ./asv && wget https://s3.amazonaws.com/briggsb/asv.zip && unzip asv.zip
cd ..
mkdir ./spanish_reina_valera && cd ./spanish_reina_valera && wget https://s3.amazonaws.com/briggsb/spanish_reina_valera_1909.zip && unzip spanish_reina_valera_1909.zip
