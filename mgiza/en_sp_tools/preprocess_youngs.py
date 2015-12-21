#!/usr/bin/env python
#preprocess Young's Literal Translation

import os
import os.path
import sys
import re
from tempfile import mkstemp
from shutil import move
OT_ORDER = ["Genesis","Exodus","Leviticus","Numbers","Deuteronomy","Joshua","Judges","Ruth","1 Samuel","2 Samuel","1 Kings","2 Kings","1 Chronicles","2 Chronicles","Ezra","Nehemiah","Esther","Job","Psalms","Proverbs","Ecclesiastes","Song of Solomon","Isaiah","Jeremiah","Lamentations","Ezekiel","Daniel","Hosea","Joel","Amos","Obadiah","Jonah","Micah","Nahum","Habakkuk","Zephaniah","Haggai","Zechariah","Malachi"]
NT_ORDER = ["Matthew","Mark","Luke","John",'Acts','Romans','1 Corinthians','2 Corinthians','Galatians','Ephesians','Philippians','Colossians','1 Thessalonians','2 Thessalonians','1 Timothy','2 Timothy','Titus','Philemon','Hebrews',"James","1 Peter","2 Peter","1 John","2 John","3 John","Jude","Revelation"]
BIBLE_ORDER = OT_ORDER + NT_ORDER
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

