[![Stories in Ready](https://badge.waffle.io/Wycliffe-USA/rapid-translation-toolkit.png?label=ready&title=Ready)](https://waffle.io/Wycliffe-USA/rapid-translation-toolkit)
#### Build Status:
##### Master
[![Build Status](https://travis-ci.org/bbriggs/wycliffe-urbana-2015.svg?branch=master)](https://travis-ci.org/bbriggs/wycliffe-urbana-2015) 
##### Development
[![Build Status](https://travis-ci.org/bbriggs/wycliffe-urbana-2015.svg?branch=development)](https://travis-ci.org/bbriggs/wycliffe-urbana-2015)
# Wycliffe@Urbana15: #Hacktranslation

We aim to bring the power of natural language processing (NLP) to bear on the work of Bible translation.

## The problem

Bible translation is a task that takes many years of dedicated, hard work from a large number of people. One of the major tasks, accounting for a large portion of the time required in translation, is gathering properly defined vocabulary and identifying parts of speech. An existing process called [Rapid Word Collection](http://rapidwords.net/) does an excellent job of collecting a large number of words in a very short period of time. However, the process is almost entirely manual and dependent on human intervention. We would like to develop processes leveraging NLP tools (or even other things. We aren't picky!) that would allow us to 'discover' more words in the target language in a shorter amount of time, using fewer resources.

Many of these languages are poor in written literature, so large sets of words are hard to come by. Some are still largely unwritten. Almost all are in areas where internet connectivity is scarce, slow, or unreliable. The translation activity is happening in remote areas where power is also unreliable and shipping equipment to the site is a gamble.

## Tools at your disposal

I have provided Vagrant machines that will get you up and running with NLP tool sets and some sample data (but not in any of the languages where translation is taking place). Additionally I will provide one or more "unknown" languages in the sample data to serve as material for proof-of-concept when working to develop NLP tools against poorly documented languages. 

Each of the tools can be found in one or more [Vagrant](https://www.vagrantup.com/) machines. [Get instructions on setup here](https://docs.vagrantup.com/v2/installation/index.html). 

Tools I plan on providing: 

- [X] [MGIZA](https://github.com/moses-smt/mgiza): A multithreaded implementation of GIZA, a word alignment tool. This is rolled into the [mgiza](mgiza/mgiza.md) box. 
- [X] [Python's NLTK](http://www.nltk.org/)
- [X] [TensorFlow](http://www.tensorflow.org/), for you ~~tryhards~~ really smart people who understand neural networks. 
- [X] [Word2Vec](https://code.google.com/p/word2vec/) using [Gensim](https://radimrehurek.com/gensim/models/word2vec.html) instead of the original. 

Any additional tools requested I will try to provide, but the tight turnaround time means I might not be able to do it during Urbana '15. As work on this project continues, I will maintain and support these boxes to the best of my ability. Issues and pull requests are welcome and encouraged. 

## Setup instructions

The only thing you will have to set up on your own will be Vagrant and the Vagrant provider (a hypervisor such as VirtualBox or VMware, etc). Platform specific instructions are on [Vagrant's site](https://docs.vagrantup.com/v2/getting-started/up.html). Generally speaking, once Vagrant is installed, just pop open a terminal, navigate to the directory containing the Vagrantfile you need to use, and do a `vagrant up`. A couple minutes later, you have a working VM with a development environment built for you. Once it's up, you can `vagrant ssh` into it and begin work. 
