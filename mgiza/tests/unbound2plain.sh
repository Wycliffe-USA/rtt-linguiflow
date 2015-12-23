#!/bin/bash

WORKINGDIR=$(pwd)

python ${WORKINGDIR}/mgiza/tools/unbound2plain.py ${WORKINGDIR}/mgiza/tests/data/asv_utf8.txt ${WORKINGDIR}/mgiza/tests/data/asv_plain.txt.out
python ${WORKINGDIR}/mgiza/tools/unbound2plain.py ${WORKINGDIR}/mgiza/tests/data/spanish_reina_valera_1909_utf8.txt ${WORKINGDIR}/mgiza/tests/data/spanish_plain.txt.out

DIFF=$(diff ${WORKINGDIR}/mgiza/tests/data/asv_plain.txt.out ${WORKINGDIR}/mgiza/tests/data/asv_plain.txt)
echo "[*] unbound2plain test 01: unbound2plain against ASV:"
if [ -e ${WORKINGDIR}/mgiza/tests/data/asv_plain.txt.out -a -e ${WORKINGDIR}/mgiza/tests/data/asv_plain.txt ]; then
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

DIFF=$(diff ${WORKINGDIR}/mgiza/tests/data/spanish_plain.txt.out ${WORKINGDIR}/mgiza/tests/data/spanish_plain.txt)
echo "[*] unboun2plain test 02: unbound2plain against Spanish Renia Valera (1909):"
if [ -e ${WORKINGDIR}/mgiza/tests/data/spanish_plain.txt.out -a -e ${WORKINGDIR}/mgiza/tests/data/spanish_plain.txt ]; then 
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
