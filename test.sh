#!/bin/bash
cd ./mgiza
vagrant up
vagrant ssh -c '/home/vagrant/tools/getcorpora.sh && /home/vagrant/tools/tokenize.sh'
