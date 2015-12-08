#!/bin/bash
#getcorpora.sh
cd
mkdir ./corpora
cd ./corpora
wget http://urbana.brenbriggs.com/de-en.tgz
tar -xf ./de-en.tgz
sudo python -m nltk.downloader -d /usr/local/share/nltk_data all