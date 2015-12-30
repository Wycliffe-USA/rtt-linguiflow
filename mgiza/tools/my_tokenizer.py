#!/usr/bin/env python
#simple word tokenizer
from __future__ import division
import nltk
import argparse

def tok_words(infile,outfile):
    with open(infile, 'r') as f:
      with open(outfile, 'w') as out_f:
          for line in f:
              line = line.lower()
              line = line.decode('utf8')
              tokens = nltk.word_tokenize(line)
              output_text = " ".join(tokens) + "\n"
              out_f.write(output_text.encode("utf8"))
    return

def main(infile,outfile):
    tok_words(infile,outfile)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Word-level tokenizer')
    parser.add_argument('infile', metavar='source', type=str, nargs=1, help='Raw, untokenized text file.')
    parser.add_argument('outfile', metavar='dest', type=str, nargs=1, help='File to write for output. Be sure to include your correct suffix (ie, .txt)')
    args = parser.parse_args()
    main(args.infile[0],args.outfile[0])
