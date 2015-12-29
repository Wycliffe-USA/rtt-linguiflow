#!/bin/bash
#tokenize.sh
INSTALL_HOME=$1
CONFIGFILE=$2
if [ -z "${INSTALL_HOME}" ] | [ -z "${CONFIGFILE}" ]; then
    echo "USAGE: ./tokenize.sh APPROOT CONFIGFILE"
    echo "Example: ./tokenize.sh ${HOME} ${CONFIGFILE}"
    exit 1
fi
APPROOT=${INSTALL_HOME}/tools
CORPORADIR=${INSTALL_HOME}/corpora
#Ensure correct nltk lib is installed
python -m nltk.downloader punkt
mkdir ${CORPORADIR}/processed
echo "Converting from Unbound format to plain string..."
python ${APPROOT}/unbound2plain.py ${CORPORADIR}/asv/asv_utf8.txt ${CORPORADIR}/processed/01_asv_plain.txt
python ${APPROOT}/unbound2plain.py ${CORPORADIR}/spanish_reina_valera/spanish_reina_valera_1909_utf8.txt ${CORPORADIR}/processed/01_spanish_plain.txt
echo "Tokenize and lowercase text..."
python ${APPROOT}/my_tokenizer.py ${CORPORADIR}/processed/01_asv_plain.txt ${CORPORADIR}/processed/02_asv_tokenized.txt
python ${APPROOT}/my_tokenizer.py ${CORPORADIR}/processed/01_spanish_plain.txt ${CORPORADIR}/processed/02_spanish_tokenized.txt
echo "Done."
echo "Making classes (this part takes a while...)"
echo "10 rounds..."
${APPROOT}/bin/training-tools/mgizapp/mkcls -n10 -p${CORPORADIR}/processed/02_asv_tokenized.txt -V${CORPORADIR}/processed/03_asv_classified.src.vcb.classes
${APPROOT}/bin/training-tools/mgizapp/mkcls -n10 -p${CORPORADIR}/processed/02_spanish_tokenized.txt -V${CORPORADIR}/processed/03_spanish_classified.trg.vcb.classes
echo "Done"
echo "Converting from plain format to snt for MGiza to work with."
cd ${CORPORADIR}
${APPROOT}/bin/training-tools/mgizapp/plain2snt ${CORPORADIR}/processed/03_asv_classified.src ${CORPORADIR}/processed/03_spanish_classified.trg
echo "Done."
echo "Creating a cooccurrence..."
${APPROOT}/bin/training-tools/mgizapp/snt2cooc ${CORPORADIR}/processed/04_en_sp.cooc ${CORPORADIR}/processed/03_spanish_classified.trg.vcb ${CORPORADIR}/processed/03_asv_classified.src.vcb ${CORPORADIR}/processed/03_asv_classified.src_03_spanish_classified.trg.snt
echo "Done."
echo "Aligning words..."
${APPROOT}/bin/training-tools/mgizapp/mgiza ${CONFIGFILE}
