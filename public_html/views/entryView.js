function EntryView(model) {
    var _model = model;

    this.render = function() {
	// see: http://code.google.com/apis/gdata/jsdoc/2.2/google/gdata/atom/Entry.html
	// see: http://code.google.com/apis/gdata/jsdoc/2.2/google/gdata/EventEntry.html
	for (var i = 0; i < _model.entries.length; i++) {
	    render(_model.entries[i]);
	}

	$("<p>Time zone offset (hours): " + model.timezone/60 + "</p>").appendTo("#events");
    }

    function render(entry) {
	var times = entry.getTimes();
        var startDateTime = "Unknown";
        var endDateTime = "Unknown";

        if (times.length > 0) {
	    var theDate = times[0].getStartTime().getDate();
	    startDateTime = theDate.toDateString(); 
	    var endDate = times[0].getEndTime().getDate();
	    endDateTime = endDate.toDateString();
        }
	    
        $(
          "<tr>" + 
	  "<td>" + startDateTime + "</td>" + 
	  "<td>" + endDateTime + "</td>" + 
	  "<td>" + entry.getTitle().getText() + "</td>" + 
	  "</tr>"
	).appendTo("#events");
    }
}