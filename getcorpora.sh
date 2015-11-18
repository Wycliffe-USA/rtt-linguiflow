#!/bin/bash
#getcorpora.sh
cd
mkdir ./corpora
cd ./corpora
wget http://www.statmt.org/europarl/v7/de-en.tgz
tar -xf ./de-en.tgz