#### Build Status:
| Master    | Development    |
| :-------: | :-------------:| 
| [![Build Status](https://travis-ci.org/Wycliffe-USA/rtt-linguiflow.svg?branch=master)](https://travis-ci.org/bbriggs/wycliffe-urbana-2015) | [![Build Status](https://travis-ci.org/Wycliffe-USA/rtt-linguiflow.svg?branch=development)](https://travis-ci.org/bbriggs/wycliffe-urbana-2015) | 

#### Issue Status:
[![Stories in Ready](https://badge.waffle.io/Wycliffe-USA/rtt-linguiflow.png?label=ready&title=Ready)](http://waffle.io/Wycliffe-USA/rapid-translation-toolkit)
[![Stories In Progress](https://badge.waffle.io/Wycliffe-USA/rtt-linguiflow.png?label=in%20progress&title=In%20Progress)](http://waffle.io/Wycliffe-USA/rapid-translation-toolkit)

# Linguiflow

#### A Rapid Translation Toolkit project

---------

### Introduction

Linguiflow is aimed at assisting translators and linguists in the field working with low-resources languages. When first learning and documenting a language for translation purposes, one of the major hurdles is simply gathering, learning, and cataloging words. Many great tools already exist for data organization and cataloging, such as [the Field Linguist's Toolbox](http://www-01.sil.org/computing/toolbox/) and methods for collecting words, such as [Rapid Word Collection](http://rapidwords.net/), both projects from [SIL](http://www.sil.org/). 

Linguiflow aims to further assist and augment field translators in the word discovery process by taking parallel text in two languages, one well-known and one low-resource language, and analyzing them to try and determine word pairs between the two. This could provide the translator with additional confidence in defining a word, help the translator discover latent phrases, or provide additional suggestions and alternative words that are used in similar ways.

### Usage

Still in early development, this tool will eventually be delivered as a webapp, but available for offline use as well. 

### Development and contribution

Want to contribute? We are seeking people who can contribute code, testing and review, or can consult on machine learning, linguistics, and natural language processing. 

#### Running the development environment

After downloading the repo, ensure you have Vagrant installed and a compatible hypervisor. After installing vagrant, install the [vagrant-librarian-puppet](https://github.com/mhahn/vagrant-librarian-puppet) plugin by running `vagrant plugin install vagrant-librarian-plugin`. This is a necessary step for the puppet provisioner, keeps the repo small, and keeps modules up to date. 

After doing that, from the webserver directory, run `vagrant up` to start the linguiflow VM and begin provisioning. After the VM provisions, the webserver will automatically start on port 3000. 