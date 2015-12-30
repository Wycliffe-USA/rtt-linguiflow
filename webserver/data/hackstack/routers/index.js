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


module.exports = router;
