import re

fname = 'sample_out'

def parse_alignment(alignment):
    raw_lines = alignment.split('\n')
    lines = remake_lines(raw_lines)

    print lines[0]
    print lines[1]
    print lines[2]

    score = get_score(lines[0])

    i_raw = get_indexes_raw(lines[2])
    indexes = get_indexes(i_raw)

    w_raw = get_words_raw(lines[2])
    words_src = get_words(w_raw)

    words_targ = get_words(lines[1].split())

    print "\tScore:", score
    print "\tSource Words:", words_src
    print "\tTarget Words:", words_targ
    print "\tIndexes:", indexes

def get_score(line):
    regstr = r'.*: ([\d.e-]+)\s*'
    match = re.match(regstr, line)
    assert(match != None)
    score = match.group(1)
    return float(score)

def get_indexes_raw(line):
    regstr = r'\({([\d ]*)}\)'
    matches = re.findall(regstr, line)
    assert(matches != None)
    return matches

def get_indexes(indexes_raw):
    indexes = []
    for ind_str in indexes_raw:
        ind_str = ind_str.strip()
        vals = map(int, ind_str.split())
        indexes.append(vals)

    return indexes

def get_words_raw(line):
    regstr = r'(\S+) \(.*?\)'
    matches = re.findall(regstr, line)
    assert(matches != None)
    return matches

def get_words(words_raw):
    words = [ w.strip() for w in words_raw ]
    return words


# Make it so that all of the target string is on one line
#   and all of the target data is also on one line
# Returns a list of lines
def remake_lines(lines):
    new_lines = []
    new_lines.append(lines[0])

    for index, line in enumerate(lines):
        if line.startswith("NULL"):
            break

    full_str = ' '.join(lines[1:index])
    alignment_str = ' '.join(lines[index:])

    new_lines.append(full_str)
    new_lines.append(alignment_str)

    return new_lines

def parse_output(mgiza_file):
    """Given an a file of raw mgiza output, return a list of results:
    []
    """
    with open(mgiza_file, 'r') as f:
        results = []
        for alignment in f.read().split('#'):
            if alignment:
                # print 'Parsing Alignment:'
                # print alignment
                results.append(parse_alignment(alignment))
        return results

if __name__ == '__main__':
    parse_output(fname)