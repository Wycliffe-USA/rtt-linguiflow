var express = require('express');
var router = express.Router();
var config = require('../config.js');


// Enpoint to retrieve client-side configuration
router.get('/config-client.js', function(req, res, next) {
  res.type('application/json');
  res.send('var config = ' + JSON.stringify(config.client));
});

router.get('/', function(req, res, next) {
	console.log('RENDERING HOMEPAGE');
  return res.render('index', {
    title: 'LinguiFlow'
  });
});

router.post('/queryAlignment', function(req, res, next) {
  console.log(req.body);
  
  var inputText  = req.body.inputText;
	var tokenArray = inputText.split(/( |n't|'s)/).filter( function(s){return s != '' && s != ' '} );
  
  console.log(tokenArray);
  
  // script can be found... somewhere
  // '../../tools/queryAlignment.py'
  
  // call this script as a child process
  
  var results;
  
  // populate results from script
  
  console.log( results );
  res.send( results );
});


module.exports = router;
