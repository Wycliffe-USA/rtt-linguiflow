import re
import sys
import json
import couchdb
fname = 'sample_out'

class Database(object):
    def __init__(self):
        self.mapping = {}

    def add(self, new_map, score):
        for key in new_map:
            words = new_map[key]

            if words == None:
                continue

            if key not in self.mapping:
                self.mapping[key] = {}

            count_dict = self.mapping[key]

            for word in words:
                if word not in count_dict:
                    count_dict[word] = 1
                else:
                    count_dict[word] += 1

    def __str__(self):
        return str(self.mapping)

def parse_alignment(alignment):
    raw_lines = alignment.split('\n')
    lines = remake_lines(raw_lines)

#    print lines[0]
#    print lines[1]
#    print lines[2]

    # Score
    score = get_score(lines[0])

    # Indexes
    i_raw = get_indexes_raw(lines[2])
    indexes = get_indexes(i_raw)

    # Source and target word lists
    w_raw = get_words_raw(lines[2])
    words_src = get_words(w_raw)

    words_targ = get_words(lines[1].split())

    # Create mapping
    mapping = create_mapping(words_src, words_targ, indexes)

    #print "\tScore:", score
    #print "\tSource Words:", words_src
    #print "\tTarget Words:", words_targ
    #print "\tIndexes:", indexes
    #print "\tMapping:", mapping
    return mapping, score

# Extracts the score from the line
def get_score(line):
    regstr = r'.*: ([\d.e-]+)\s*'
    match = re.match(regstr, line)
    assert(match != None)
    score = match.group(1)
    return float(score)

# Extract index values as strings from the line
def get_indexes_raw(line):
    regstr = r'\({([\d ]*)}\)'
    matches = re.findall(regstr, line)
    assert(matches != None)
    return matches

# Turns the tuple of strings into a list of lists of index values
def get_indexes(indexes_raw):
    indexes = []
    for ind_str in indexes_raw:
        ind_str = ind_str.strip()
        vals = map(int, ind_str.split())
        indexes.append(vals)

    return indexes

# Extract words as strings from the line
def get_words_raw(line):
    regstr = r'(\S+) \(.*?\)'
    matches = re.findall(regstr, line)
    assert(matches != None)
    return matches

# Turns a tuple of strings into a stripped words
def get_words(words_raw):
    words = [ w.strip() for w in words_raw ]
    return words

# Creates a mapping from source words to target words
def create_mapping(source, target, indexes):
    mapping = {}
    for word, inds in zip(source, indexes):
        # - 1 is because indexes are 1 indexed
        vals = [ target[i-1] for i in inds ]
        mapping[word] = vals if len(vals) > 0 else None

    return mapping


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
        database = Database()
        for alignment in f.read().split('#'):
            if alignment:
                # print 'Parsing Alignment:'
                # print alignment
                mapping, score = parse_alignment(alignment)
                database.add(mapping, score)

        return database

def print_to_file(val, filename):
    with open(filename, 'w') as f:
        f.write(val)


if __name__ == '__main__':
    if len(sys.argv) < 3:
        raise Exception("Usage: parse_mgiza mgiza_file output_file")
    couch = couchdb.Server()
    db = couch['alignments']
    database = parse_output(sys.argv[1])
    with open(sys.argv[2],'a') as f:
        for key in database.mapping:
            tmp = {"src":key,"maps":database.mapping[key]}
            print tmp
            json.dump(tmp,f)
            f.write('\n')
    with open(sys.argv[2],'r') as f:
        results = []
        for line in f:
            jsonified = json.loads(line)
            results.append(db.save(jsonified))
        print "Inserted %s documents" % len(results)
