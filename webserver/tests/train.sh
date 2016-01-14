#!/bin/bash
WORKINGDIR=$(pwd)
sudo bash ./webserver/tools/getcorpora.sh ${WORKINGDIR}/webserver
sudo bash ./webserver/tools/generate_mgiza_configfile.sh ${WORKINGDIR}/webserver
sudo bash ./webserver/tools/en-sp-align_words.sh ${WORKINGDIR}/webserver ${WORKINGDIR}/webserver/tools/mgiza_configfile
