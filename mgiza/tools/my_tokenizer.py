#!/usr/bin/env python
#simple word tokenizer
from __future__ import division
import nltk
import argparse

def tok_words(infile,outfile):
    with open(infile, 'r') as f:
        text = f.read()
        text = text.lower()
        print "Found %d words..." % len(text.split(" "))
        text = text.decode('utf8')
        tokens = nltk.word_tokenize(text)
        print "Found %d tokens..." % (len(tokens))
    tokens = " ".join(tokens)
    with open(outfile, 'w') as f:
        f.write(tokens.encode("utf8"))
    return

def main(infile,outfile):
    tok_words(infile,outfile)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Word-level tokenizer')
    parser.add_argument('infile', metavar='source', type=str, nargs=1, help='Raw, untokenized text file.')
    parser.add_argument('outfile', metavar='dest', type=str, nargs=1, help='File to write for output. Be sure to include your correct suffix (ie, .txt)')
    args = parser.parse_args()
    main(args.infile[0],args.outfile[0])