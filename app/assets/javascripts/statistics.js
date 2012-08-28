$(document).ready(function() {
	if ($('#chart_container').length){
		
		
		//, onclose: setDates 
		$('#end_date').datepicker({ maxDate: 0});
		$('#start_date').datepicker({ maxDate: 0});
		

		// instantiate our graph!
		
		var y_ticks = new Rickshaw.Graph.Axis.Y( {
			graph: graph,
			orientation: 'left',
			tickFormat: Rickshaw.Fixtures.Number.formatKMBT,
			element: document.getElementById('y_axis'),
		} );
		
		graph.render();
		
		var hoverDetail = new Rickshaw.Graph.HoverDetail( {
			graph: graph
		} );
		
		var legend = new Rickshaw.Graph.Legend( {
			graph: graph,
			element: document.getElementById('legend')
		
		} );
		
		var shelving = new Rickshaw.Graph.Behavior.Series.Toggle( {
			graph: graph,
			legend: legend
		} );
		
		var axes = new Rickshaw.Graph.Axis.Time( {
			graph: graph
		} );
		axes.render();
		

	}
});