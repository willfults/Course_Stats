$(document).ready(function() {
	if ($('.module_reorder .modules_list').length){
	 $('.upArrow').click(function(){
	 	$(this).parent().parent().parent().addClass('markedLi');
	 	var current = $('.markedLi');
	 	var id = parseInt(current.attr('id'))
	 	var topelement = $('#' + (id - 1))
	 	topelement.before(current);
  		renumber_modules();
  		current.attr('id',id - 1)
  		topelement.attr('id',id)
  		current.removeClass('markedLi');
  		showHideArrows();
	 });
	 
	 $('.downArrow').click(function(){
	 	$(this).parent().parent().parent().addClass('markedLi');
	 	var current = $('.markedLi');
	 	var id = parseInt(current.attr('id'))
	 	id += 1
	 	var bottomelement = $('#' + id)
	 	bottomelement.after(current);
  		renumber_modules();
  		current.attr('id',id)
  		id -= 1
  		bottomelement.attr('id',id)
  		current.removeClass('markedLi');
  		showHideArrows();
	 });
	 showHideArrows();
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

function showHideArrows(){
	//hides first up arrow and last down arrow
	$('.upArrow').show()
	$('.downArrow').show()
	$('.upArrow:first').hide();
	$('.downArrow:last').hide()
}

function renumber_modules()
{
  $('.module_reorder .module_part_number').each(function(index, element){
    $(element).text( index + 1 );
  });
 
  var new_order = "";
  $('#modules_list li').each(function(index, element){
    if (index > 0)
    {
      new_order += ",";
    }
    new_order += $(element).attr( 'style' );
  });

  $('#module_order').val(new_order);
}