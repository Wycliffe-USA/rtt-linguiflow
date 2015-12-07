#!/bin/bash
cd ./mgiza
VBoxManage --version
vagrant up
vagrant ssh -c '/home/vagrant/tools/getcorpora.sh && /home/vagrant/tools/tokenize.sh'
