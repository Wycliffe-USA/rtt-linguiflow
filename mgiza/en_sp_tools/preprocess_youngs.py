#!/usr/bin/env python
#preprocess Young's Literal Translation

import os
import os.path
import sys
import re
from tempfile import mkstemp
from shutil import move

def get_files(docroot):
    files = []
    for dirpath, dirnames, filenames in os.walk(docroot):
            for filename in [f for f in filenames if f.endswith(".txt")]:
                    files.append(os.path.join(dirpath, filename))
    return files

def strip_verses(filename):
        #generate a tempfile
        #mkstemp returns a file descriptor and a path
        fd, abs_path = mkstemp()
        with open(abs_path,'a') as tmp_file:
            with open(filename) as old_file:
                for line in old_file:
                    #remove leading digits from each line of the file
                    line = re.sub(r'^\d+','', line)
                    tmp_file.write(line)
        #close files and FDs
        #failure to do so will exhause system resources
        old_file.close()
        tmp_file.close()             
        os.close(fd)
        os.remove(old_file.name)
        move(abs_path, filename)
        return

def main(docroot):
        chapters = get_files(docroot)
        for chapter in chapters:
                strip_verses(chapter)
        return

if __name__ == "__main__":
        docroot = sys.argv[1]
        main(docroot)