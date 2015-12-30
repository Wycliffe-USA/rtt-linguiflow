$(function() {


    // wrap words in spans
    $('p').each(function(index) {
        var $this = $(this);
        $this.html($this.text().replace(/\b(\w+)\b/g, "<span id="+index+">$1</span>"));
    });



    // Create an object that holds the mappings
    var results = getResults("Some text");

    console.log(results);

    // bind to each span
    $('p span').hover(
        function() { $('#word').text($(this).css('background-color','#ffff66').text()); },
        function() { $('#word').text(''); $(this).css('background-color',''); }
    );
});

// Returns Object with input mapping and translation

function getResults(targetLanguage, inputText){

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
  $.each(results.translation, function( index, value ) {
    console.log(value);
    $("#target-text").append("<span id = " + index + ">" + value + "</span>");
  });
}
