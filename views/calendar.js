function CalendarView() {
    this.render = function(year, month, entries) {
	var daysInMonth = new Date(year, month, 0).getDate();
	
	$("<span>" + monthName(month) + " " + year + "</span>").appendTo("#calendar-title")

	for (var i = 1; i <= daysInMonth; i++) {
          var busy = isBusy(entries, new Date(year, month-1, i));

	    var cssClass = busy ? "day busy" : "day";		   
	    
            $("<span class=\"" + cssClass +"\" id=\"calendar_day_" + i + "\">" + i + "</span>").appendTo("#calendar");
	}

	renderControls(year, month);
    } 

    function renderControls(year, month) {
	var nextMonth = month+1;
	var baseUrl = document.location.href.split("?")[0];

	var fullUrl = baseUrl + "?" + "y=" + year + "&m=" + nextMonth;
	$("<a href='" + fullUrl + "' id='next_month'>next</a>").appendTo("#calendar-title");
    }

    // see: http://code.google.com/apis/gdata/jsdoc/2.2/google/gdata/When.html
    function isBusy(entries, when) {
      when = zeroTime(when);
      
      for (var i = 0; i < entries.length; i++) {
        var entry = entries[i];
	var times = entry.getTimes();

        if (times.length > 0) {
          var startDate = zeroTime(times[0].getStartTime().getDate());
          var endDate = zeroTime(times[0].getEndTime().getDate());

	  var isOneDayEntry = startDate.equals(endDate)		   
	  var isOnSingleDay = isOneDayEntry && when.equals(startDate);
           		   
	  var isInInterval = isOneDayEntry ? when.equals(startDate) : startDate <= when && when < endDate; 		  

          if (isInInterval)
            return true;
        }
      }	

      return false;		   
    }

    function zeroTime(date) {
      var result = new Date(date);

      result.setHours(0);		   
      result.setMinutes(0);		   
      result.setSeconds(0);

      return result;	      
    }			   
}