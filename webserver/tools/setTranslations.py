#---------------------------------------------------

# function: list setTranslations(string, string, boolean)
# Takes in a word from source, a word from target and a boolean value and adjusts #certainties accordingly
# params:       string W --     input word
#		string S —- 	target word
#		bool   F —- 	Accept (T) Reject (F)
# output:       list outp --    output list of translation-freq pairs
def setTranslations(W, S, F):
        outp = []
        for a in alignment_list:
                if a['value']['src'] == W:
                        keys = a['value']['maps'].keys()
                        index = 0
                        total = 0
                        for i in range(0,len(keys)):
                                if keys[i] == S:
                                        index = i
                                total = total + a['value']['maps'][keys[i]]
                        if F == 'true':
                               # a['value']['maps'][keys[index]] = 2 * a['value']['maps'][keys[index]]
                        elif F == 'false':
                                a['value']['maps'][keys[index]] = 0
                        for i in range(0, len(keys)):
                                row = []
                                row.append(keys[i])
                                row.append(a['value']['maps'][keys[i]] / total)
                                outp.append(row)
        return outp
