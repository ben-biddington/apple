function EntryView(entries) {
    var _entries = entries;

    this.render = function() {
	// see: http://code.google.com/apis/gdata/jsdoc/2.2/google/gdata/atom/Entry.html
	// see: http://code.google.com/apis/gdata/jsdoc/2.2/google/gdata/EventEntry.html
	for (var item in _entries) {
	    render(entries[item]);
	}

	$("<p>Time zone offset (hours): " + timezone()/60 + "</p>").appendTo("#events");
    }

    function timezone() {
	return first(function(item) { 
	    return item.getTimes().length > 0;
	}).getTimes()[0].getStartTime().getDate().getTimezoneOffset();
    } 

    function first(matching) {
	for (var i = 0; i < _entries.length; i++) {
	    var entry = _entries[i];
            
	    if (matching(entry) == true) {
		return _entries[i];
	    }
        }

	return null;
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