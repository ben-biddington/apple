function CalendarView(model) {
    this.render = function() {
	var daysInMonth = new Date(model.year, model.month, 0).getDate();
	
	for (var i = 1; i <= daysInMonth; i++) {
          var busy = isBusyOn(new Date(model.year, model.month-1, i));

	    var cssClass = busy ? "day busy" : "day";		   
	    
            $("<span class=\"" + cssClass +"\" id=\"calendar_day_" + i + "\">" + i + "</span>").appendTo("#calendar");
	}

	renderControls(year, month);
    } 

    function renderControls() {
	renderPrevButton();
	renderTitle();
	renderNextButton();
    }

    function renderPrevButton() {
	var baseUrl   = document.location.href.split("?")[0];
	var prevMonth = model.month == 1 ? 12 : model.month - 1;
	var prevYear  = model.month == 1 ? model.year - 1 : model.year;

	var fullUrl = baseUrl + "?" + "y=" + prevYear + "&m=" + prevMonth;
	$("<a href='" + fullUrl + "' id='prev_month'>prev</a>").appendTo("#calendar-title");
    }

    function renderNextButton() {
	var nextMonth = model.month == 12 ? 1 : model.month+1;
	var nextYear  = model.month == 12 ? model.year + 1 : model.year;
	var baseUrl   = document.location.href.split("?")[0];

	var fullUrl = baseUrl + "?" + "y=" + nextYear + "&m=" + nextMonth;
	$("<a href='" + fullUrl + "' id='next_month'>next</a>").appendTo("#calendar-title");	
    }

    function renderTitle() {
	$("<span id='calendar-title-text'>" + monthName(model.month) + " " + model.year + "</span>").appendTo("#calendar-title")
    }

    // see: http://code.google.com/apis/gdata/jsdoc/2.2/google/gdata/When.html
    function isBusyOn(when) {
      when = zeroTime(when);
      
      for (var i = 0; i < model.entries.length; i++) {
        var entry = model.entries[i];
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