#!/bin/bash
echo "Importing python libraries..."
python -m nltk.downloader punkt
python -c "import nltk"