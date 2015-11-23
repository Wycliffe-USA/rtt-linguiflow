#!/bin/bash
#tokenize.sh
APPROOT=/home/vagrant/tools
CORPORADIR=/home/vagrant/corpora

perl ${APPROOT}/europarl/tools/tokenizer.perl -l en < ${CORPORADIR}/europarl-v7.de-en.en > ${CORPORADIR}/en_tokenized.src
perl ${APPROOT}/europarl/tools/tokenizer.perl -l de < ${CORPORADIR}/europarl-v7.de-en.de > ${CORPORADIR}/de_tokenized.trg

tr '[:upper:]' '[:lower:]' < ${CORPORADIR}/en_tokenized.src > ${CORPORADIR}/en_tokenized_lowered.src
tr '[:upper:]' '[:lower:]' < ${CORPORADIR}/de_tokenized.trg > ${CORPORADIR}/de_tokenized_lowered.trg

${APPROOT}/bin/training-tools/mgizapp/mkcls -n10 -p${CORPORADIR}/en_tokenized_lowered.src -V${CORPORADIR}/en_classified.src
${APPROOT}/bin/training-tools/mgizapp/mkcls -n10 -p${CORPORADIR}/de_tokenized_lowered.trg -V/${CORPORADIR}/de_classified.trg

cd ${CORPORADIR}
${APPROOT}/bin/training-tools/mgizapp/plain2snt ${CORPORADIR}/en_classified.src ${CORPORADIR}/de_classified.trg