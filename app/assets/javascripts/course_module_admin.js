$(document).ready(function() {
	if ($('.class_type').length){
		$('.class_type').click(function() {
			showHide();
		});	
		showHide();
	}
});

function showHide(){
	if ($('#course_module_class_type_youtube').is(':checked')){
		$('#youtube_container').show();
		$('#video_file_container').hide();
	}else{
		$('#youtube_container').hide();
		$('#video_file_container').show();				
	}
}
