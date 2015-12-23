#!/bin/bash
pip install -U nltk
pip install -U gensim
python -m nltk.downloader punkt
WORKINGDIR=$(pwd)
echo "Checking for mgiza config file..."
ls -lah /home/travis/build/bbriggs/wycliffe-urbana-2015/mgiza/tools
sudo bash ./mgiza/tools/getcorpora.sh ${WORKINGDIR}/mgiza
sudo bash ./mgiza/tools/en-sp_tokenize.sh ${WORKINGDIR}/mgiza ${WORKINGDIR}/mgiza/tools/travis_mgiza_configfile
