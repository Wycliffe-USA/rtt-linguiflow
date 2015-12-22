# #!/bin/bash
pip install -U nltk
pip install -U gensim
python -m nltk.downloader punkt
sudo bash ./mgiza/tools/getcorpora.sh ${HOME}
sudo bash ./mgiza/tools/en-sp_tokenize.sh ${HOME}/mgiza
