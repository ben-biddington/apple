require "spec_helper"
require "calendar_feed"

describe "Fetching the calendar" do
  it "you can load the xml for the calendar" do
    calendar = CalendarFeed.new "vddp2rq2f0j1asv103n6jps2og@group.calendar.google.com"
    calendar.timezone.should === "Pacific/Auckland"
    calendar.entries.size.should > 0
  end
end

class CalendarEntry
  attr_reader :start,:end

  def initialize(start, _end = nil)
    @start = start
    @end = _end
  end
end

class CalendarEntryParser
  class << self 
    def parse(text)
      time_pattern = "[0-9]{2}:[0-9]{2}"
      date_pattern = "([A-Za-z]{3} [0-9]{1,2} [A-Za-z]{3} [0-9]{4})"
      pattern = /When: #{date_pattern}(.+to #{date_pattern})?/

      match = pattern.match(text)
      start = match[1]
      _end = match[3]

      CalendarEntry.new start, _end 
    end
  end
end

describe CalendarEntry do
  it "you can parse from text, examples" do
    CalendarEntryParser.parse("When: Wed 31 Aug 2011 07:30 to 08:30").start.should === "Wed 31 Aug 2011"
  end

  it "can parse start and end dates" do
    result = CalendarEntryParser.parse("When: Wed 31 Aug 2011 to Thu 01 Sep 2011")    
    result.start.should === "Wed 31 Aug 2011"    
    result.end.should === "Thu 01 Sep 2011"    
  end

  it "even when both contain times" do 
    result = CalendarEntryParser.parse("When: Wed 31 Aug 2011 13:37 to Thu 01 Sep 2011 13:37 ")    
    result.start.should === "Wed 31 Aug 2011"    
    result.end.should === "Thu 01 Sep 2011"    
  end
end
