var databases = {
  
  settings: {
    noReplicate: true,
    init_documents: [
      {
        _id: "replication",
        targets: {} // empty hash to be manually populated
      }
    ]
  },
  
  alignments: {
    init_documents: [
      {
        "_id": "exampleModel",
        "type": "mgiza-0",
        "sourceLang": "English",
        "targetLang": "French",
        "sentencePairs": [
          ["all the nations", "toutes les nations", 0.97],
          ["it is well", "c'est bien", 0.67],
          ["i worship you", "je vous adore", 0.82],
          ["he conquered the grave", "il a conquis la tombe", 0.27]
        ]
      }
      
    ],
    views: {
    
      model0_by_sentence: {
         map: function(doc) {
           if(doc.type == "mgiza-0") {
             emit(doc.sourceLang, [doc.targetLang, doc.sentencePairs]);
           }
         }.toString()
      },

      alignments_by_srcWord: {
         map: function(doc) {
           emit(doc.src, doc.maps);
         }.toString()
      }
    }
  },
  
  users: {
    init_documents: [
      {
        "_id": "stealthybox",
        "type": "user",
        "username": "stealthybox"
      },
      {
        "_id": "briggsb",
        "type": "user",
        "username": "briggsb"
      }
      
    ],
    views: {
      
      //returns list of session objects
      
      session_details_by_username: {
         map: function(doc) {
          if (doc.type == 'user') {
            for (var i in doc.sessions) {
              var details = {
                id:      doc['_id'],
                session: doc.sessions[i]
              };
              
              emit(doc.username.toLowerCase(), details); 
            }
          } 
         }.toString()
      },
      session_details_by_session_id: {
        map: function(doc) {
          if (doc.type == 'user') {
            for (var i in doc.sessions) {
              var details = {
                id:      doc['_id'],
                session: doc.sessions[i]
              };
              
              emit(doc.sessions[i].session_id, details);
            }
          }
        }.toString()
      },
      
      // returns user objects
      
      users_by_username: {
        map: function(doc) {
          if (doc.type == 'user') {
            emit(doc.username.toLowerCase(), doc);
          }
        }.toString()
      }
      
    }
  }
  
}


module.exports = databases;
