#!/bin/bash

apt-get update && apt-get install -y unzip python-pip
pip install -U nltk couchdb
mv /home/vagrant/linguiflow.conf /etc/init/linguiflow.conf
chown root:root /etc/init/linguiflow.conf && chmod 0644 /etc/init/linguiflow.conf
