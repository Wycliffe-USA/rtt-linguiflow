var fs = require('fs');
var os = require('os');
var config = {};

// Client-side Configuration
config.client = {
  // front-end config values
}

// CouchDB Authentication
config.couchdbadmin = process.env.COUCHDB_ADMIN || ''; //'admin:secret' + '@';
config.couchdb      = process.env.COUCHDB || 'http://' + config.couchdbadmin + 'localhost:5984/';


module.exports = config;
