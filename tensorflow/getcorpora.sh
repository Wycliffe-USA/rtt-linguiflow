#!/bin/bash
#getcorpora.sh
cd
mkdir ./corpora
cd ./corpora
wget https://s3.amazonaws.com/briggsb/de-en.tgz
tar -xf ./de-en.tgz
sudo python -m nltk.downloader -d /usr/local/share/nltk_data all