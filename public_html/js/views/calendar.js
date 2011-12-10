function CalendarView(model) {
    this.render = function() {
	var daysInMonth = new Date(model.year, model.month, 0).getDate();
	var theDaysInPreviousMonth = new Date(model.year, model.month - 1, 0).getDate();
	
	var theFirstDayOfTheMonth = new Date(model.year, model.month-1, 0);

	if (theFirstDayOfTheMonth.getDay() != 1) {
	    daysInMonth += (theFirstDayOfTheMonth.getDay() - 1);
	}

	var theDayToStartDrawingAt = theFirstDayOfTheMonth.getDay();  

	for (var i = 1; i <= daysInMonth + 1; i++) {
	    if (i > theDayToStartDrawingAt) {
		theDate = new Date(model.year, model.month-1, i);

		var busy = isBusyOn(theDate);
		
		var cssClass = busy ? "day busy" : "day";		   
	    
		var theNumberToDraw = i - theDayToStartDrawingAt;

		$(
		  "<span class=\"" + cssClass +"\" id=\"calendar_day_" + theNumberToDraw + "\">" + 
                  theNumberToDraw + "</span>"
                ).appendTo("#calendar");
	    } else {
		var theDayFromPreviousMonth = theDaysInPreviousMonth - theDayToStartDrawingAt + i;
		$(
                  "<span class=\"day\" id=\"calendar_day_prev_month_" + i + "\">" + 
                  theDayFromPreviousMonth + "</span>"
                ).appendTo("#calendar");
	    }
	}

	renderControls(year, month);
	renderDayHeadings();
    } 

    function renderDayHeadings() {
	var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

	for (var i = 0; i < 7; i++) {
	    $("<span class=\"dayname\">" + days[i] + "</span>").appendTo("#calendar-days");	
	}
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