require "spec_helper"

describe "The calendar on the split apple rock site" do 
  let(:base_url){"file:///home/ben/sauce/split_apple_rock/public_html/calendar.html"}

  let :calendar do 
    CalendarFeed.new "vddp2rq2f0j1asv103n6jps2og@group.calendar.google.com"    
  end

  it "shows the correct number of days for whatever month is requested" do
    assert_that_sep_2011_shows_33_days
    assert_that_oct_2011_shows_36_days
    assert_that_jan_2012_shows_37_days
  end

  it "shows the days for the previous month if there are any" do
    puts days_in 2011, 10
  end

  it "starts each row on a monday" do 
    visit "#{base_url}?y=2011&m=9"

    wait.for(5.seconds).until { page.has_xpath? "//div[@id='calendar']/span" }
    
    the_days = all("//div[@id='calendar']/span")

    the_4th_day_text = the_days[3].text

    the_4th_day_text.should eql("1"), "Expected the first of the month to be displayed as the 4th Item In The Calendar, Instead it shows #{the_4th_day_text}"
  end

  it "shows busy days for september 2011 (events spanning multiple days)" do
    assert_busy_days 2011,9   
  end

  it "shows busy days for august 2011 (single-day events)" do
    assert_busy_days 2011,8
  end

  private 

  def assert_busy_days(year, month)
    expected_number_of_busy_days = calendar.get_busy_days_for month

    visit "#{base_url}?y=#{year}&m=#{month}"

    wait.for(5.seconds).until { page.has_xpath? "//div[@id='calendar']/span[@class='day']" }
    
    actual_number_of_busy_days = all("//div[@id='calendar']/span[@class='day busy']").size

    actual_number_of_busy_days.should(eql(expected_number_of_busy_days), 
      "Expected #{expected_number_of_busy_days} days to be marked as busy, " + 
      "got #{actual_number_of_busy_days}."
    )
  end

  def find_all_days
    all("//div[@id='calendar']/span")
  end

  def days_in(year, month_index) 
    Date.new(year, month_index, -1).day
  end

  def method_missing(name, *args) 
    if match = /(\w{3})_(\w{4})_shows_(\d+)_days$/.match(name)
      month_names = Date::ABBR_MONTHNAMES.map{|s| s.downcase if s}

      month_name = match[1]
      month_index = month_names.index month_name
      year = match[2].to_i
      expected_number_of_days = match[3].to_i
      
      the_url = "#{base_url}?y=#{year}&m=#{month_index}"

      visit the_url

      wait.for(5.seconds).until { page.has_xpath? "//div[@id='calendar']/span" }
    
      the_days = find_all_days

      the_days.size.should(eql(expected_number_of_days), 
        "Expected #{expected_number_of_days} days, got #{the_days.size}"
      )
    else
      super(name, args) 
    end
  end

  it "shows a different calendar by setting month and/or year query parameters"
  it "shows all the the calendar items for the requested month"
  it "uses the current year and month if either year or month is invalid"
  it "shows a message if either if either year or month is invalid"
end
