var config   = require( './config' );
var dbSchema = require( './dbSchema' );
var async    = require( 'async' );
var request  = require( 'request' );


var dbHash;
var targetHash;

// exported function
function dbSetup( dbSetupDone ) {
  async.parallel(
    [
      setDBHash,
      setTargetHash
    ],
    
    function( err ) {
      // once we have _all_dbs and the _replicator/_local/targets
      // validate dbs:
      async.each(
        // foreach database name
        Object.keys( dbSchema ),
        // call the validation functions
        function( dbName, validateDone ) {
          validateDB( dbName, function() {
            validateViews( dbName, function() {
              validateDocuments( dbName, function() {
                validateReplication( dbName, function() {
                  validateDone();
                });
              });
            });
          });
        },
        // when all validation is done, dbSetupDone()
        function( err ) {
          dbSetupDone();
        }
      );
      
    }
  );
}


function setDBHash( callback ) {
  // GET _all_dbs
  // set dbHash
  // callback
  request(
    {
      method: 'GET',
      url:    config.couchdb + '_all_dbs',
      json:   true
    },
    function( err, res, dbNames ) {
      if (err) {
        throw Error('Failed to get _all_dbs for dbSetup');
      } else {
        if ( dbNames.error ) {
          throw Error( dbNames.error + ' ' + dbNames.reason );
        } else {
          dbHash = {};
          for (var i in dbNames) {
            dbHash[ dbNames[i] ] = true;
          }
        }
      }
      callback();
    }
  );
}


function setTargetHash( callback ) {
  // GET _replicator/_settings/replication
  // if exists, set targetHash
  // callback
  request(
    {
      method: 'GET',
      url:    config.couchdb + 'settings/replication',
      json:   true
    },
    function( err, res, repSettings ) {
      if (err) {
        throw Error('Failed to get _settings/replication for dbSetup');
      } else {
        if ( repSettings.error ) {
          if ( res.statusCode != 404 ) {
            throw Error( repSettings.error + ' ' + repSettings.reason );
          }
        } else {
          targetHash = repSettings.targets;
        }
      }
      callback();
    }
  );
}


function validateDB( dbName, callback ) {
  // check if db is in dbHash
  // if not, create db in Couch
  // callback
  if ( dbHash[ dbName ] ) {
    console.log( 'db: ' + dbName + ' exists' );
    callback();
  } else {
    console.log( 'Creating db: ' + dbName );
    request(
      {
        method: 'PUT',
        url:    config.couchdb + dbName,
        json:   true
      },
      function( err, res, created ) {
        if (err) {
          throw Error('Failed to create ' + dbName);
        } else {
          if ( created.error ) {
            throw Error( created.error + ' ' + created.reason );
          } else {
            console.log( 'db: ' + dbName + ' created');
          }
        }
        callback();
      }
    );
  }
}


function validateViews( dbName, callback ) {
  // note: this function assumes dbSchema implements 1:1 relationship for db:_design
  
  // GET _design document for db
  // if does not exist, create
    // async.each view in dbSchema[ dbName ];
      // if view does not exist OR is not equal
        // add view to design doc
    // if doc is new or changed POST it
    // callback
  request(
    {
      method: 'GET',
      url:    config.couchdb + dbName + '/_design/' + dbName,
      json:   true
    },
    function( err, res, design ) {
      if (err) {
        throw Error('Failed to retrieve _design for ' + dbName);
      } else {
        
        var tmp_design = {
            _id:   '_design/' + dbName,
            views: {}
          };
        var pushTmpDesign = false;
        
        if ( design.error ) {
          if ( res.statusCode != 404 ) {
            throw Error( design.error + ' ' + design.reason );
          }
        } else {
          // note: this doesn't happen in the 404 case
          tmp_design = design;
          if ( !tmp_design.views ) {
            tmp_design = {};
          }
        }
        
        if ( dbSchema[ dbName ].views ) {
          for ( var viewName in dbSchema[ dbName ].views ) {
            if ( JSON.stringify( dbSchema[ dbName ].views[viewName] )
              != JSON.stringify( tmp_design.views[viewName] )
            ) {
              tmp_design.views[viewName] = dbSchema[ dbName ].views[viewName];
              pushTmpDesign = true;
            }
          }
        }
        
        if ( !pushTmpDesign ) {
          callback();
        } else {
          // POST the _design document
          request(
            {
              method: 'POST',
              url:    config.couchdb + dbName,
              json:   tmp_design
            },
            function(err, res, posted) {
              if (err) {
                throw Error('Failed to post _design doc for ' + dbName);
              } else {
                if ( posted.error ) {
                  throw Error( posted.error + ' ' + posted.reason );
                } else {
                  console.log( 'db_design: ' + dbName + ' posted');
                }
              }
              callback();
            }
          );
          
        }
        
      }
    }
  );
}


function validateDocuments( dbName, callback ) {
  // if database is new
    // async.each init_document in dbSchema[ dbName ];
      // POST document to db
    // callback
  
  // if the database is new
  if (!dbHash[dbName]) {
    async.each(
      dbSchema[dbName].init_documents,
      function(init_doc, docCreated) {
        if (init_doc._id) { //validate that document has an _id - required
          request(
            {
              method: 'POST',
              url:    config.couchdb + dbName,
              json:   init_doc
            },
            function(err, res, added) {
              if (err) {
                throw Error('Failed to add doc: '+init_doc._id+' for db: ' + dbName);
              } else {
                if ( added.error ) {
                  throw Error( added.error + ' ' + added.reason );
                } else {
                  console.log( 'document "'+init_doc._id+'": posted to db: ' + dbName);
                  docCreated();
                }
              }
            }
          );
        } else {
          console.log ('Cannot add! _id property missing for document: ', init_doc);
          docCreated();
        }
        
      },
      function() {
        // all docs posted, complete
        callback();
      }
    );
  } else {
    console.log('db-exists: not adding init_documents for db: ' + dbName);
    callback();
  }
}


function validateReplication( dbName, callback ) {
  // if there are targets and the database is replicable
  if ( targetHash && !dbSchema[ dbName ].noReplicate ) {
    // async.each target in targetHash
      // if _replicator document for this target does not exist
        // POST new _replicator document
    // callback
    async.each(
      Object.keys( targetHash ),
      function(targetKey, replicationValidated) {
        var docId = 'push_'+dbName+'_to_'+targetKey;
        
        request(
          {
            method: 'GET',
            url:    config.couchdb + '_replicator/' + docId,
            json:   true
          },
          function(err, res, replicatorDoc) {
            if (err) {
              throw Error('Failed to GET _replicator/' + docId);
            } else {
              if (replicatorDoc.error) {
                if (res.statusCode != 404) {
                  throw Error( replicatorDoc.error + ' ' + replicatorDoc.reason );
                  
                } else {
                  // no doc exists, create it
                  var replicationDoc = {
                    _id:        docId,
                    source:     dbName,
                    target:     targetHash[ targetKey ] + dbName,
                    continuous: true
                  };
                  
                  request(
                    {
                      method: 'POST',
                      url:    config.couchdb + '_replicator',
                      json:   replicationDoc
                    },
                    function(err, res, added) {
                      if (err) {
                        throw Error('Failed to add doc: '+docId+' for db: _replicator');
                      } else {
                        if ( added.error ) {
                          throw Error( added.error + ' ' + added.reason + ' ' + docId);
                        } else {
                          console.log( 'document '+docId+': posted to db: _replicator');
                          replicationValidated(); //document added, complete
                        }
                      }
                    }
                  );
                }
                
              } else {
                console.log('_replicator/' + docId + ' exists');
                replicationValidated(); //no action needed, complete
              }
            }
          }
        );
        
      },
      function() {
        // all replication validated, complete
        callback();
      }
    );
  } else {
    console.log(dbName + ' will not be replicated');
    // no replication to validate, complete
    callback();
  }
}


module.exports = dbSetup;