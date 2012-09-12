jQuery(function($) {
  // create a convenient toggleLoading function
  var toggleLoading = function() { $("#loading").toggle() };

  bookmarkBinding();
    
});

function bookmarkBinding() {
  $('table.search-results a.bookmark, div.course-view a.bookmark')
    .bind("ajax:complete", function() { 
      $(this).parent().html('<span class="label">bookmarked</span>');
    });
}
