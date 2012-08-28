$(document).ready(function() {
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
