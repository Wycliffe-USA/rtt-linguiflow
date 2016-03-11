import couchdb

couch = couchdb.Server()
db = couch['alignments']

retrieve_mapfn = """function(doc) {
  if (doc.type == "alignment") {
    emit(doc._id, {src: doc.src, maps: doc.maps});
  }
}"""

design = { 'views': {
           'aligned_by_src': {
              'map': retrieve_mapfn
            }
         } }
db["_design/all_alignments"] = design

alignment_list = db.view('all_alignments/aligned_by_src')

for a in alignment_list:
    print a.key


