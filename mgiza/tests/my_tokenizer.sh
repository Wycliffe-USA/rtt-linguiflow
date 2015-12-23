#!/bin/bash

WORKINGDIR=$(pwd)

python ${WORKINGDIR}/mgiza/tools/my_tokenizer.py ${WORKINGDIR}/mgiza/tests/data/asv_plain.txt ${WORKINGDIR}/mgiza/tests/data/asv_tokenized.txt.out
python ${WORKINGDIR}/mgiza/tools/my_tokenizer.py ${WORKINGDIR}/mgiza/tests/data/spanish_plain.txt ${WORKINGDIR}/mgiza/tests/data/spanish_tokenized.txt.out

DIFF=$(diff ${WORKINGDIR}/mgiza/tests/data/asv_tokenized.txt.out ${WORKINGDIR}/mgiza/tests/data/asv_tokenized.txt)
echo "[*] Tokenizer test 01: Tokenizer against ASV:"
if [ -e ${WORKINGDIR}/mgiza/tests/data/asv_tokenized.txt.out -a -e ${WORKINGDIR}/mgiza/tests/data/asv_tokenized.txt ]; then
    if [ "$DIFF" != "" ]; then 
        echo "[-] Failed. See output below."
        echo $DIFF
        exit 1
    else
        echo "[+] Passed."
    fi
else
    echo "[-] Failed. One or more files not found."
    exit 1
fi

DIFF=$(diff ${WORKINGDIR}/mgiza/tests/data/spanish_tokenized.txt.out ${WORKINGDIR}/mgiza/tests/data/spanish_tokenized.txt)
echo "[*] Tokenizer test 02: Tokenizer against Spanish Renia Valera (1909):"
if [ -e ${WORKINGDIR}/mgiza/tests/data/spanish_tokenized.txt.out -a -e ${WORKINGDIR}/mgiza/tests/data/spanish_tokenized.txt ]; then 
    if [ "$DIFF" != "" ]; then 
        echo "[-] Failed. See output below."
        echo $DIFF
        exit 1
    else
        echo "[+] Passed."
    fi
else
    echo "[-] Failed. One or more files not found."
    exit 1
fi