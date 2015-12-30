var init = {
  // vars for this "module"
};


$(document).ready(function() {
  // enable all precompiled templates to be rendered as partials
  Handlebars.partials = Handlebars.templates;  
  
  /* example handlebars helper
  Handlebars.registerHelper('toLocal', function(utc, options){
    return utcToLocal(utc);
  });
  */

  // example submit handler
  /*
  $('#example-form').submit(function(e) {
    var userid = $('#userid').val();
    var password = $('#password').val();
    
    $.ajax(
      ajaxDefaults({
        type: 'POST',
        url:  '/login',
        data: {
          user:    userid,
          password: password
        },
        success: function(data) {
          if (data.session_id) {
            // login
          } else {
            alert(data.message);
          }
        }
      })
    );
    
    e.preventDefault();
  });
  */
  
  
});



function ajaxDefaults(options) {
  var defaults = {
    headers: {
      // k/v pairs for headers
    },
    error: function(err) {
      if (err.status == 403 && !expiredRedirectDeclined) {
        // forbidden to resource
      } else if (err.status == 401) {
        // failed to auth
      }
      console.log(err);
    },
    success: function(res) {
      console.log( "AJAX Call Succeeded\n  url: " + options.url + "  res: " );
      console.log( res );
    },
    dataType: 'json'
  };
  options.type = options.type.toUpperCase();
  if ( options.type == 'POST' || options.type == 'PUT' || options.type == 'DELETE' ) {
    defaults.contentType = 'application/json';
    if ( typeof options.data == 'object' && ( !options.contentType || options.contentType == 'application/json' ) ) {
      options.data = JSON.stringify( options.data );
    }
  }
  if ( options.url.toUpperCase ); //conditional for ensuring options.url is passed
  
  return $.extend( defaults, options );
}


