#!/bin/bash
#tokenize.sh
APPROOT=/home/vagrant/tools
CORPORADIR=/home/vagrant/corpora
echo "Running tokenizer..."
perl ${APPROOT}/europarl/tools/tokenizer.perl -l en < ${CORPORADIR}/europarl-v7.de-en.en > ${CORPORADIR}/en_tokenized.src
perl ${APPROOT}/europarl/tools/tokenizer.perl -l de < ${CORPORADIR}/europarl-v7.de-en.de > ${CORPORADIR}/de_tokenized.trg
echo "Done."
echo "Lowercasing text..."
tr '[:upper:]' '[:lower:]' < ${CORPORADIR}/en_tokenized.src > ${CORPORADIR}/en_tokenized_lowered.src
tr '[:upper:]' '[:lower:]' < ${CORPORADIR}/de_tokenized.trg > ${CORPORADIR}/de_tokenized_lowered.trg
echo "Done."
echo "Making classes (this part takes a while...)"
echo "10 rounds..."
${APPROOT}/bin/training-tools/mgizapp/mkcls -n10 -p${CORPORADIR}/en_tokenized_lowered.src -V${CORPORADIR}/en_classified.src
${APPROOT}/bin/training-tools/mgizapp/mkcls -n10 -p${CORPORADIR}/de_tokenized_lowered.trg -V/${CORPORADIR}/de_classified.trg
echo "Done"
echo "Converting from plain format to snt for MGiza to work with."
cd ${CORPORADIR}
${APPROOT}/bin/training-tools/mgizapp/plain2snt ${CORPORADIR}/en_classified.src ${CORPORADIR}/de_classified.trg
echo "Done."
ls -lahrt