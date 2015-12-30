fname = 'example_output.txt'

def parse_alignment(alignment):
    alignment = alignment.split('\n')
    score = float(alignment[0].split()[-1])
    result = alignment[2].split()

    trg_phrase = alignment[1].split()

    for i, src_word in enumerate(result[::2]):
        try:  # Handle bad inputs
            int(src_word)
            return
        except ValueError:
            pass

        trg_words = []
        trg_word_positions = result[i + 1].split()  # e.g., ['({', '11', '16', '17', '})']

        # Parse out the target words for each source word
        for pos in trg_word_positions:
            try:
                pos = int(pos)
            except ValueError:
                pos = None

            if pos:
                trg_words.append(trg_phrase[pos - 1])

        # Add entries to the DB
        if trg_words:
            print 'Source Word:', src_word
            print 'Target Words:', trg_words

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
