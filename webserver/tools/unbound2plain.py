#!/usr/bin/env python
#Convert Unbound Bible Format into plain text, all one line. 

import os
import os.path
import sys
import re
from tempfile import mkstemp
from shutil import move
import argparse

def unbound2plain(infile,outfile):
    fd, abs_path = mkstemp()
    with open(abs_path,'a') as tmp_file:
        with open(infile) as source:
            for line in source:
                if not line.startswith('#'):
                    line = re.sub(r'^[\d\sON]+\t','', line)
                    line = re.sub(r'\r\n$','\n',line)
                    tmp_file.write(line)
    source.close()
    tmp_file.close()
    os.close(fd)
    move(abs_path, outfile)
    return

def main(infile,outfile):
    unbound2plain(infile,outfile)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Preprocess Unbound Bible formatted text')
    parser.add_argument('infile', metavar='source', type=str, nargs=1, help='the Unbound formatted text. Usually ends in _8tf8.txt')
    parser.add_argument('outfile', metavar='dest', type=str, nargs=1, help='file to write for output. Be sure to include your correct suffix (ie, .txt)')
    args = parser.parse_args()
    main(args.infile[0],args.outfile[0])