#!/bin/bash
#getcorpora.sh
cd
mkdir ./corpora
cd ./corpora
wget https://s3.amazonaws.com/briggsb/de-en.tgz
tar -xf ./de-en.tgz