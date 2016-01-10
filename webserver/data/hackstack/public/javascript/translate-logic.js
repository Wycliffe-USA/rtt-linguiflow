/*
frontend logic for requesting and handling translation data
*/

translate_logic = {
  // global variables for this file's functions go here.
  inputs:  {/* hash for storing translate inputs and options */},
  results: [/* array for storing word mappings */],
  hover: true
};


$(document).ready(function() {

  $("#translate-button").click( translate );

  $("#source-text").keypress(function (e) {
    if(e.which == 13) { // on enter, translate()
      translate();
      e.preventDefault();
    }
  });

});


function translate() {
  getInput();
  getResults();
  updateText();
}


// sets translate_logic.inputs
function getInput() {
	var inputText = $("#source-text").val();
	var tokenArray = inputText.split(/( |n't|'s)/).filter( function(s){return s} );
	  // quick hack for tokenizing English :)
	var wordArray = [];
	$.each( tokenArray, function( index, value ) {
		if ( value != ' ' )
			wordArray.push( { token: value, tokenIndex: index } );
	});
	
  translate_logic.inputs = {
    text :  inputText,
    tokens: tokenArray,
    words:  wordArray,
    sourceLang : $("#source-lang").val(),
    targetLang : $("#target-lang").val()
  }
}


// sets translate_logic.results with the translation mappings
function getResults(){

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
    var results = [];
		
		$.each(  translate_logic.inputs.words, function( index, sourceWord ) {
			console.log(sourceWord);
			var matches = translate_model
										 [ translate_logic.inputs.sourceLang]
											 [ translate_logic.inputs.targetLang]
												 [sourceWord.token];
			results.push( matches );
		});
		console.log(results);
		
		translate_logic.results = results;
  // ===================================
}



function updateText() {
  $("#target-text").empty();
  
  // note: in this code, result tokens are joined with a hardcoded delimiter.
  $.each( translate_logic.results, function( resultIndex, result ) {
  	// build the showing span initialized with the highest confidence word possible:
    var word    = '<span id="span' + resultIndex + '">'
    						+ result[0].alignment.join(' ')
    						+ '</span>';
    // build the hidden options that are toggled when clicking the span:
    var options = '<select id="select' + resultIndex
    						+ '" style="display: none" class="word-choice form-control">'
								$.each( result, function( guessIndex, guess ) {
									options  += '<option value="' + guess.alignment.join(' ') + '">'
														+ guess.alignment.join(' ')
														+ '\t'
														+ guess.confidence
														+ '%</option>';
								});
		options += '</select>';
		
		$("#target-text").append( word + options + ' ');
  });

  // click events for word choice select box
  $('#target-text span').click(function() {
    $(this).hide();
    $(this).next().show();
  });
  $('#target-text select').change(function() {
    // note: this only allows the select box to disappear when the values changes
    $(this).prev().text( $(this).val() );
    $(this).hide();
    $(this).prev().show();
    // solution should be made to manage a disabled select element as the first option
    // so that the user can select the same option and still close the select box.
    //  -- or we can add a manual 'close button' that does the hide/show interaction
  });


  // bind to each span
  $('span').hover(
    function() {
    	if (translate_logic.hover) {
				//$('#word').text( $(this).text() ); // unused feature
				$(this).css('background-color','#ffff66');
				
				// this logic maps spanIndex to words in the input box by order alone
				// there is no logic being used right now to understand alignment from this context
				//  - we dont have an algorithm for that yet.
				var spanIndex = $(this).context.id.substr('span'.length);
				var tokenIndex = translate_logic.inputs.words[spanIndex].tokenIndex;
				var highlightStart = translate_logic.inputs.tokens.slice(0,tokenIndex).join('').length;
				var highlightEnd = highlightStart + translate_logic.inputs.tokens[tokenIndex].length;
				
				// init highlight on source str
				$('#source-text').highlightTextarea({
					ranges: [ highlightStart, highlightEnd ]
				});
			}
    },
    function() {
    	if (translate_logic.hover) {
				//$('#word').text(''); // unused feature
				$(this).css('background-color',''); 
				$('#source-text').highlightTextarea('destroy');
			}
    }
  );
}
