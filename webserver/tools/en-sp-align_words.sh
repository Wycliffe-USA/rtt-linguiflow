#!/bin/bash
#tokenize.sh

#INSTALL_HOME can be any arbitrary dir where you have write perms
#However, it needs to be the same for all run scripts. 
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
python ${APPROOT}/unbound2plain.py ${CORPORADIR}/asv/asv_utf8.txt ${CORPORADIR}/processed/asv_plain.txt
python ${APPROOT}/unbound2plain.py ${CORPORADIR}/spanish_reina_valera/spanish_reina_valera_1909_utf8.txt ${CORPORADIR}/processed/spanish_plain.txt

echo "Tokenize and lowercase text..."
python ${APPROOT}/my_tokenizer.py ${CORPORADIR}/processed/asv_plain.txt ${CORPORADIR}/processed/asv
python ${APPROOT}/my_tokenizer.py ${CORPORADIR}/processed/spanish_plain.txt ${CORPORADIR}/processed/spanish
echo "Done."

echo "Making classes (this part takes a while...)"
echo "10 rounds..."
${APPROOT}/bin/training-tools/mgizapp/mkcls -n10 -p${CORPORADIR}/processed/asv -V${CORPORADIR}/processed/asv.vcb.classes
${APPROOT}/bin/training-tools/mgizapp/mkcls -n10 -p${CORPORADIR}/processed/spanish -V${CORPORADIR}/processed/spanish.vcb.classes
echo "Done"

echo "Converting from plain format to snt for MGiza to work with."
cd ${CORPORADIR}
${APPROOT}/bin/training-tools/mgizapp/plain2snt ${CORPORADIR}/processed/asv ${CORPORADIR}/processed/spanish
echo "Done."

echo "Creating a cooccurrence..."
${APPROOT}/bin/training-tools/mgizapp/snt2cooc ${CORPORADIR}/processed/asv_spanish.cooc ${CORPORADIR}/processed/asv.vcb ${CORPORADIR}/processed/spanish.vcb ${CORPORADIR}/processed/asv_spanish.snt
echo "Done."
echo "Aligning words..."
${APPROOT}/bin/training-tools/mgizapp/mgiza ${CONFIGFILE}
