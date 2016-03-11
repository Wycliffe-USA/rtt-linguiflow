import couchdb
import json
couch = couchdb.Server()
db = couch['alignments']

alignment_list = db.view('all_alignments/aligned_by_src')

def getTranslations(W):
        outp = []
        for a in alignment_list:
                if a['value']['src'] == W:
                        print json.dumps(a)
                        return json.dumps(a) #uncomment this line to get a json object
#                       outp.append(str(a['key']))
#                       keys = a['value']['maps'].keys()
#                       for i in range(0,len(keys)):
#                              rowout = []
#                               rowout.append(keys[i].encode("utf-8"))
#                               rowout.append(a['value']['maps'][keys[i]])
#                               outp.append(rowout)
#                       return outp
#       print json.dumps(outp)

def rejectAlignment(doc,T,db):
    '''
    doc (json): document from CouchDB containing all information on source word

    T (string): word to reject

    db (CouchDB object): instantiated CouchDB connection and database
    '''
    doc = json.loads(doc)
    doc = db[doc['id']]
    print doc.keys()
    doc['maps'][T] = 0
    db[doc.id] = doc
    return

def main(W,T):
    doc = getTranslations(W)
    rejectAlignment(doc,T,db)
    getTranslations(W)


if __name__ == "__main__":
    main('god','dios')
