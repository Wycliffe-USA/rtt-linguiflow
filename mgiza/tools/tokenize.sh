#!/bin/bash
#tokenize.sh
INSTALL_HOME=$1
if [ -z "${INSTALL_HOME}" ]; then
    echo "USAGE: ./tokenize.sh app_root"
    echo "Example: ./tokenize.sh ${HOME}"
    exit 1
fi
APPROOT=${INSTALL_HOME}/tools
CORPORADIR=${INSTALL_HOME}/corpora
echo "Running tokenizer..."
perl ${APPROOT}/europarl/tools/tokenizer.perl -l en < ${CORPORADIR}/europarl-v7.de-en.en > ${CORPORADIR}/01_en_tokenized.src
perl ${APPROOT}/europarl/tools/tokenizer.perl -l de < ${CORPORADIR}/europarl-v7.de-en.de > ${CORPORADIR}/01_de_tokenized.trg
echo "Done."
echo "Lowercasing text..."
tr '[:upper:]' '[:lower:]' < ${CORPORADIR}/01_en_tokenized.src > ${CORPORADIR}/02_en_tokenized_lowered.src
tr '[:upper:]' '[:lower:]' < ${CORPORADIR}/01_de_tokenized.trg > ${CORPORADIR}/02_de_tokenized_lowered.trg
echo "Done."
echo "Making classes (this part takes a while...)"
echo "10 rounds..."
${APPROOT}/bin/training-tools/mgizapp/mkcls -n10 -p${CORPORADIR}/02_en_tokenized_lowered.src -V${CORPORADIR}/03_en_classified.src
${APPROOT}/bin/training-tools/mgizapp/mkcls -n10 -p${CORPORADIR}/02_de_tokenized_lowered.trg -V/${CORPORADIR}/03_de_classified.trg
echo "Done"
echo "Converting from plain format to snt for MGiza to work with."
cd ${CORPORADIR}
${APPROOT}/bin/training-tools/mgizapp/plain2snt ${CORPORADIR}/03_en_classified.src ${CORPORADIR}/03_de_classified.trg
echo "Done."
echo "Creating a cooccurrence because I don't know why I just do what Fabio tells me to do"
${APPROOT}/bin/training-tools/mgizapp/snt2cooc ${CORPORADIR}/04_de_en.cooc ${CORPORADIR}/03_de_classified.trg.vcb ${CORPORADIR}/03_en_classified.src.vcb ${CORPORADIR}/03_en_classified.src_03_de_classified.trg.snt
echo "Done, hopefully."
