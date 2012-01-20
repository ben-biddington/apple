# -*- coding: utf-8 -*-
require "spec_helper"

describe CalendarEntry do
  it "the simplest match" do
    result = CalendarEntryParser.parse("When: Wed 31 Aug 2011g")
    result.start.must === Date.new(2011, 8, 31)
  end
  
  it "you can parse from text, examples" do
    result = CalendarEntryParser.parse("When: Wed 31 Aug 2011 07:30 to 08:30")
    result.start.must === Date.new(2011, 8, 31)
        
    result = CalendarEntryParser.parse("When: Tue 30 Aug 2011")
    result.start.must === Date.new(2011, 8, 30)
  end

  it "can parse start and end dates" do
    result = CalendarEntryParser.parse("When: Wed 31 Aug 2011 to Thu 01 Sep 2011")    
    result.start.must === Date.new(2011, 8, 31)        
    result.end.must === Date.new(2011, 9, 1)
  end

  it "even when both contain times" do 
    result = CalendarEntryParser.parse("When: Wed 31 Aug 2011 13:37 to Thu 01 Sep 2011 13:37")    
    result.start.must === Date.new(2011, 8, 31)    
    result.end.must === Date.new(2011, 9, 1)
  end

  it "another example" do
    result = CalendarEntryParser.parse "When: Thu 8 Sep 2011 to Sat 10 Sep 2011 &lt;br /&gt;"
    result.start.must === Date.new(2011, 9, 8)    
    result.end.must === Date.new(2011, 9, 10)
  end

  it "tells you how long the period is it represents" do
    CalendarEntry.new(Date.new(2011, 9, 8)).duration_in_days.must === 1
    CalendarEntry.new(Date.new(2011, 9, 8), Date.new(2011, 9, 8)).duration_in_days.must === 1
    CalendarEntry.new(Date.new(2011, 9, 8), Date.new(2011, 9, 9)).duration_in_days.must === 2
    CalendarEntry.new(Date.new(2011, 9, 8), Date.new(2011, 9, 10)).duration_in_days.must === 3
  end
end
