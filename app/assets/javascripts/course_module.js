$(document).ready(function() {
	if ($('.module_reorder .modules_list').length){
	  $( "#sortable" ).sortable({
	    stop: function(event, ui) { renumber_modules();}
	  });
	  $( "#sortable" ).disableSelection();
  }
	
	if ($('#container').length){
		var playStatTracked = false
		var completionStatTracked = false
		jwplayer("container").setup({
			flashplayer : "/jwplayer/player.swf"
		});
		
		jwplayer().onComplete(function() {
			if(!completionStatTracked){
			 	 completionStatTracked = true //only increase completion stat once
				 $.post(video_id + '/done/', function(data) {
				 	
				 });
			 }
		});
		
		jwplayer().onPlay(function() {
			//trigger tracking, this method gets triggered everytime a user clicks play
			 if(!playStatTracked){
			 	 playStatTracked = true //only increase play stat once
				 $.post(video_id + '/play/', function(data) {
				 	
				 });
			 }
		});
	}
	
	$(".input-check.correct_answer").change(function() {
    $(this).parents("fieldset").find(".input-check.correct_answer").not(this).removeAttr("checked");
  });
	
});

function renumber_modules()
{
  $('.module_reorder .module_part_number').each(function(index, element){
    $(element).text( index + 1 );
  });
 
  var new_order = "";
  $('.module_table li').each(function(index, element){
    if (index > 0)
    {
      new_order += ",";
    }
    new_order += $(element).attr( 'id' );
  });

  $('#module_order').val(new_order);
}