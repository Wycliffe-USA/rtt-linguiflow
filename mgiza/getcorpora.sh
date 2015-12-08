#!/bin/bash
#getcorpora.sh
cd
mkdir ./corpora
cd ./corpora
wget https://s3.amazonaws.com/briggsb/de-en.tgz
tar -xf ./de-en.tgz
sudo python -m nltk.downloader -d /usr/local/share/nltk_data brown_tei europarl_raw genesis gutenberg moses_sample word2vec_sample universal_tagset hmm_treebank_pos_tagger
