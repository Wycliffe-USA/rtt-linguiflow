$(function() {

    document.getElementById("translate-button").onclick = translate;

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

    var translations = ["hola", "mundo"];

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

  // bind to each span
  $('span').hover(
    function() { $('#word').text($(this).css('background-color','#ffff66').text()); },
    function() { 
      $('#word').text(''); 
      $(this).css('background-color',''); 
        if($(this).context.id == 1){
          $('#source-text').highlightTextarea({
          words: ['hello']
          });
        }
        else{
          $('#source-text').highlightTextarea({
            words: ['world']
          });
        }   
    }

  );
}





