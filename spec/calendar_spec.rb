require "spec_helper"

describe "The calendar on the split apple rock site" do 
  before :all do
    @base_url = "file:///home/ben/sauce/split_apple_rock/calendar.html"
  end

  it "shows the correct timezone" do
    visit @base_url
    page.should have_content "Time zone offset (hours): -12"
  end

  it "shows the correct number of days for whatever month is requested" do
    visit "#{@base_url}?y=2011&m=9"

    wait.for(5.seconds).until { page.has_xpath? "//div[@id='calendar']/span" }
    
    the_days = all("//div[@id='calendar']/span")

    the_days.size.should(eql(30), "Expected 30 days, got #{the_days.size}")
  end

  it "shows busy days" do
    calendar = CalendarFeed.new "vddp2rq2f0j1asv103n6jps2og@group.calendar.google.com"

    september = 9

    visit "#{@base_url}?y=2011&m=#{september}"

    wait.for(5.seconds).until { page.has_xpath? "//div[@id='calendar']/span[@class='day']" }
    
    the_days = all("//div[@id='calendar']/span[@class='day busy']")

    total_days = calendar.get_busy_days_for september

    the_days.size.should(eql(total_days), 
      "Expected #{total_days} days to be marked as busy, got #{the_days.size}."
    )
  end

  it "shows a different calendar by setting month and/or year query parameters"
  it "shows all the the calendar items for the requested month"
  it "uses the current year and month if either year or month is invalid"
  it "shows a message if either if either year or month is invalid"
end
