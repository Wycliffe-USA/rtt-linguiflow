#!/bin/bash
#generate_mgiza_configfile.sh
INSTALL_HOME=$1
if [ -z "${INSTALL_HOME}" ]; then
    echo "Generates a configfile for MGIZA."
    echo "USAGE: ./generate_mgiza_configfile.sh app_root"
    echo "Example: ./getcorpora.sh ${HOME}"
    exit 1
fi

echo "
adbackoff 0
compactadtable 1
compactalignmentformat 0
countcutoff 1e-06
countcutoffal 1e-05
countincreasecutoff 1e-06
countincreasecutoffal 1e-05
countoutputprefix
d
deficientdistortionforemptyword 0
depm4 76
depm5 68
dictionary
dopeggingyn 0
dumpcount 0
dumpcountusingwordstring 0
emalignmentdependencies 2
emalsmooth 0.2
emprobforempty 0.4
emsmoothhmm 2
hmmdumpfrequency 0
hmmiterations 5
log 0
m1 5
m2 0
m3 3
m4 3
m5 0
m5p0 -1
m6 0
manlexfactor1 0
manlexfactor2 0
manlexmaxmultiplicity 20
maxfertility 10
maxsentencelength 101
mh 5
mincountincrease 1e-07
ml 101
model1dumpfrequency 1
model1iterations 5
model23smoothfactor 0
model2dumpfrequency 0
model2iterations 0
model345dumpfrequency 0
model3dumpfrequency 0
model3iterations 3
model4iterations 3
model4smoothfactor 0.4
model5iterations 0
model5smoothfactor 0.1
model6iterations 0
nbestalignments 0
ncpus 1
nodumps 1
nofiledumpsyn 1
noiterationsmodel1 5
noiterationsmodel2 0
noiterationsmodel3 3
noiterationsmodel4 3
noiterationsmodel5 0
noiterationsmodel6 0
nsmooth 4
nsmoothgeneral 0
numberofiterationsforhmmalignmentmodel 5
onlyaldumps 1
outputfileprefix src_trg.dict
outputpath
p 0
p0 0.999
peggedcutoff 0.03
pegging 0
previousa
previousd
previousd4
previousd42
previoushmm
previousn
previousp0
previoust
probcutoff 1e-07
probsmooth 1e-07
readtableprefix
restart 0
t1 1
t2 0
t2to3 0
t3 0
t345 0
tc
testcorpusfile
th 0
transferdumpfrequency 0
v 0
verbose 0
verbosesentence -10" > ${INSTALL_HOME}/tools/mgiza_configfile

echo "
coocurrencefile ${INSTALL_HOME}/corpora/processed/asv_spanish.cooc
corpusfile ${INSTALL_HOME}/corpora/processed/asv_spanish.snt
logfile ${INSTALL_HOME}/mgiza/corpora/processed/src_trg_mgiza.log
sourcevocabularyfile ${INSTALL_HOME}/corpora/processed/asv.vcb
targetvocabularyfile ${INSTALL_HOME}/corpora/processed/spanish.vcb
" >> ${INSTALL_HOME}/tools/mgiza_configfile