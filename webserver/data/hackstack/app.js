var express = require('express');
var hbs = require('hbs');
var config = require('./config.js');
var mailer = require('express-mailer');
var path = require('path');

var favicon = require('serve-favicon');
var logger = require('morgan');
//var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');

var indexRouter = require('./routers/index');


// string for setting colors in console.log();
var colorOff='\033[0m'          // Text Reset
// Regular Colors
var black   ='\033[30m'       // Black
var red     ='\033[31m'       // Red
var green   ='\033[32m'       // Green
var yellow  ='\033[33m'       // Yellow
var blue    ='\033[34m'       // Blue
var purple  ='\033[35m'       // Purple
var cyan    ='\033[36m'       // Cyan
var white   ='\033[37m'       // White

var app = express();
mailer.extend(app, {
    from: 'app@yourdomain.com',
    host: 'yourdomain',
    secureConnection: false,
    port: 25,
    transportMethod: 'SMTP'
  }
);

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'hbs');
hbs.registerPartials(__dirname + '/views/partials');

// register handlebars helpers
var blocks = {};
// extend can be used on body pages, which will add stylesheets to the blocks hash
hbs.registerHelper('extend', function(name, context) {
    var block = blocks[name];
    if (!block) {
        block = blocks[name] = [];
    }

    block.push(context.fn(this));
});
// block can be used in parent templates to receive the extension
hbs.registerHelper('block', function(name) {
    var val = (blocks[name] || []).join('\n');

    // clear the block
    blocks[name] = [];
    return val;
});

// precompile front-end templates
hbsPrecompiler = require('handlebars-precompiler');
hbsPrecompiler.watchDir(
  __dirname + "/public/views/",
  __dirname + "/public/javascript/templates.js",
  ['handlebars', 'hbs']
);


// uncomment after placing your favicon in /public :
  // app.use(favicon(__dirname + '/public/favicon.ico'));
app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
//app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));
app.use('/bower_components',  express.static(__dirname + '/bower_components'));


// routing section
app.use('/', indexRouter);
// example global request handler
app.all('/*', function(req, res, next){
  // you can add authentication and other request handlers for requests that go beyond this point
  next();
});


// catch 404 and forward to error handler
app.use(function(req, res, next) {
  res.status(404);
  next( Error('Not Found') );
});

// error handler

app.use(function(err, req, res, next) {
  // set response code
  if ( res.statusCode === 200 && err.status )
    res.status(err.status);
  if ( res.statusCode === 200 )
    res.status(500);
  
  // log error on appserver
  console.log( red + 'Route Stopped: ' + colorOff + req.method + ' - ' + req.url  + ' - ' + res.statusCode );
  console.log( err.stack );
  console.log( red + 'Headers: ' + colorOff);
  console.log( req.headers );
  console.log( red + 'Data: '  + colorOff);
  console.log( req.body || req.query );
  
  // create error response object
  var errResponse = {
        status: res.statusCode,
        message: err.message
      };
  if (app.get('env') === 'development') {
    // include stacktrace if development
    errResponse.stack = err.stack;
  }
  
  // format response based on Accepts header
  if ( ~req.headers.accept.indexOf('html') ) {
    errResponse.title = "Error";
    res.render('error', errResponse);
  } else {
    res.setHeader('Content-Type', 'application/json');
    var json;
    try {
      json = JSON.stringify( errResponse );
      res.send(json);
    } catch(e) {
      console.log( 'Failed to Stringify Error response:' );
      console.log( e );
      res.send(500);
    }
  }
});


module.exports = app;
