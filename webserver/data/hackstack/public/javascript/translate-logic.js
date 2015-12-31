/*
frontend logic for requesting and handling translation data
*/

translate_logic = {
  // global variables for this file's functions go here.
};


$(document).ready(function() {

  document.getElementById("translate-button").onclick = translate;

  $("#source-text").keypress(function (e) {
    if(e.which == 13) {
      translate();
      e.preventDefault();
    }
  });

});


function translate(){
  var input = grabInput();
  getResults(input);
}


function grabInput(){
  return {
    inputText : $("#source-text").val(),
    inputLang : $("#source-lang").val(),
    targetLang : $("#target-lang").val()
  }
}


// Returns Object with input mapping and translation
function getResults(input){

  // $.ajax({
  //   url: "/api/someURLHere",
  //   method: "POST",
  //   data: {
  //     text : inputText,
  //     language : targetLanguage
  //   },
  //   dataType: "json",
  //   success: function (data) {
  //     if (data) {
  //       updateText(data)
  //     } else {
  //       alert("Didn't work");
  //     }
  //   }
  //
  // });

  // ===================================
    var temp = {
      hello: 1,
      world: 2
    }

    var translations = ["todas", "las", "naciones"];

    var results = {
        mapping: temp,
        translation: translations
    }

    updateText(results)
  // ===================================
}



function updateText(results){
  $("#target-text").empty();
  $.each(results.translation, function( index, value ) {
    console.log(value);
    $("#target-text").append("<span id = " + index + ">" + value + " </span>");
  });


    // click events for word choices
  $('#target-text span').click(function() {
    var word = $(this).text();
    console.log('word');
    console.log(word);
          var options = '<select class="word-choice form-control">' +
                            '<option>' + word + '  90%</option>' +
                            '<option>las naciones 15%</option>' +
                            '<option>de naciones 10%</option>' +
                            '<option>los paises 1%</option>'
                          '</select>'
    var originalWord = $(this).html();
    $(this).replaceWith(options);
    if($(this).context.id == 0){
          $('#source-text').highlightTextarea({
          words: ['all']
          });
        }
        else if($(this).context.id == 1){
          $('#source-text').highlightTextarea({
            words: ['the']
          });
        } else { 
          $('#source-text').highlightTextarea({
            words: ['nations']
          });
        }
  });


  // bind to each span
  $('span').hover(
    function() { $('#word').text($(this).css('background-color','#ffff66').text()); },
    function() { 
      $('#word').text(''); 
      $(this).css('background-color',''); 
    }

  );
}
