PgSearch.multisearch_options = {
  using: {
           tsearch: {
             dictionary: 'russian',
               highlight: {
                 StartSel: '<b class="text-danger">',
                 StopSel: '</b>',
                 MaxWords: 15,
                 MinWords: 5,
                 ShortWord: 3,
                 HighlightAll: false,
                 MaxFragments: 2,
                 FragmentDelimiter: ' ... '
               }
           },
           trigram: {}
         }
}
