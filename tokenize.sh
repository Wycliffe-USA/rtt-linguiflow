#!/bin/bash
#tokenize.sh
perl /root/europarl/tools/tokenizer.perl -l en < /root/corpora/europarl-v7.de-en.en > /root/corpora/eng_tokenized.src
perl /root/europarl/tools/tokenizer.perl -l de < /root/corpora/europarl-v7.de-en.de > /root/corpora/de_tokenized.trg

tr '[:upper:]' '[:lower:]' < /root/corpora/eng_tokenized.src > /root/corpora/eng_tokenized_lowered.src
tr '[:upper:]' '[:lower:]' < /root/corpora/de_tokenized.trg > /root/corpora/de_tokenized_lowered.trg

/root/workspace/bin/training-tools/mgizapp/mkcls -n10 -p/root/corpora/en_tokenized_lowered.src -V/root/corpora/en_classified.src
/root/workspace/bin/training-tools/mgizapp/mkcls -n10 -p/root/corpora/de_tokenized_lowered.trg -V/root/corpora/de_classified.trg

cd /root/corpora
/root/workspace/bin/training-tools/mgizapp/plain2snt /root/corpora/en_classified.src /root/corpora/de_classified.trg