#!/bin/bash
apt-get update
apt-get install -y python-dev python-pip python-scipy
pip install -U nltk
pip install -U gensim
pip install -U https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.5.0-cp27-none-linux_x86_64.whl
mkdir /home/vagrant/tools && chown vagrant:vagrant /home/vagrant/tools
cd /home/vagrant/tools
chmod +x ./*.sh