#!/bin/bash
WORKINGDIR=$(pwd)
sudo bash ./mgiza/tools/getcorpora.sh ${WORKINGDIR}/mgiza
sudo bash ./mgiza/tools/en-sp-align_words.sh ${WORKINGDIR}/mgiza ${WORKINGDIR}/mgiza/tools/travis_mgiza_configfile