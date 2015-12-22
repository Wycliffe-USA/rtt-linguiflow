# #!/bin/bash
pip install -U nltk
pip install -U gensim
python -m nltk.downloader punkt
WORKINGDIR=$(pwd)
sudo bash ./mgiza/tools/getcorpora.sh ${WORKINGDIR}/mgiza
sudo bash ./mgiza/tools/en-sp_tokenize.sh ${WORKINGDIR}/mgiza ${WORKINGDIR}/tools/travis_mgiza_configfile
