// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require_tree .
//= require turbolinks

// google.load("visualization", "1", {packages: ["corechart"]});
// google.maps.event.addDomListener(window, 'load', initialize);


$(document).ready(function() {
	// Use .ready to ensure turbolinks works properly
	$(".alert-dismissable").fadeTo(2000, 500).slideUp(500, function(){
		$(".alert-dismissable").alert('close');
	});
	$('.chosen-select')
		.trigger("chosen:updated")
		.chosen({
			allow_single_deselect: true,
			no_results_text: 'No results matched',
			width: '90%'
	});
})

$('.chosen-select').chosen();
