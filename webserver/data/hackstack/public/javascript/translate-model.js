// this is a hardcoded stub for what the output from mgiza should be post-processed into:
var translate_model = {
  // The data structure stores language -> language translations
  "English": {
    "Spanish": {
      // in each language, we have 1-gram mappings to arrays of n-gram guesses
      // each n-gram guess some mysterious confidence scores
      "all": [
        {alignment:['todas'], confidence: 73},
        {alignment:['todos'], confidence: 33},
      ],
      "the": [
        {alignment:['las'], confidence: 82},
        {alignment:['los'], confidence: 68},
      ],
      "nations": [
        {alignment:['naciones'], confidence: 90},
        {alignment:['gentes'], confidence: 13},
      ]
    },
    "French": {
      "all": [
        {alignment:['toutes'], confidence: 76},
        {alignment:['tous'], confidence: 71},
        {alignment:['nous, sommes'], confidence: 11},
      ],
      "the": [
        {alignment:['les'], confidence: 93},
        {alignment:['le'], confidence: 51},
      ],
      "nations": [
        {alignment:['nations'], confidence: 49},
        {alignment:['peuples'], confidence: 40},
      ]
    }
  },
  "French": {
    "German": {
      "toutes": [
        {alignment:['sie alle'], confidence: 46},
        {alignment:['alle'], confidence: 21}
      ],
      "les": [
        {alignment:[], confidence: 82},
      ],
      "nations": [
        {alignment:['nationen'], confidence: 45},
        {alignment:['volker'], confidence: 44},
      ]
    }
  }
};