#---------------------------------------------------

# function: list getTranslations(string)
# Takes in a word and outputs a two-dimensional list of
# paired translations and frequencies
# params:       string W --     input word
# output:       list outp --    output list of translation-freq pairs
def getTranslations(W):
        outp = []
        for a in alignment_list:
                if a['value']['src'] == W:
                        #return json.dumps(a) #uncomment this line to get a json object
#                       outp.append(str(a['key']))
                        keys = a['value']['maps'].keys()
                        for i in range(0,len(keys)):
                                rowout = []
                                rowout.append(keys[i].encode("utf-8"))
                                rowout.append(a['value']['maps'][keys[i]])
                                outp.append(rowout)
#                       return outp
        return json.dumps(outp)
