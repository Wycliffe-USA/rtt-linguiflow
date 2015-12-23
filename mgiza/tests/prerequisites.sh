#!/bin/bash
echo "Importing python libraries..."
python -m nltk.downloader punkt
python -c "import nltk"
python -c "import scipy"
python -c "import numpy"
python -c "import gensim"