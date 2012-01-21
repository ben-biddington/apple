require "spec_helper"

describe "The calendar on the split apple rock site" do 
  include AcceptanceTest

  it "shows the correct number of days for the requested month" do
    assert_that_sep_2011_shows_33_days
    assert_that_oct_2011_shows_36_days
    assert_that_jan_2012_shows_37_days
  end

  it "shows the days for the month prior to the requested month if there are any" do
    the_number_of_days_in_nov_2011 = days_in 2011, 11
    
    expected_number_of_days_from_nov = 3

    visit "#{base_url}?y=2011&m=12"

    wait_until_loaded    

    all_days = find_all_days

    (0...expected_number_of_days_from_nov).each do |i|
      all_days[i].text.to_i.must(eql(the_number_of_days_in_nov_2011 - 2 + i))
    end
  end

  it "shows the days for the month prior to the requested month even when the requested month is january" do
    the_number_of_days_in_dec_2011 = days_in 2011, 12
    
    expected_number_of_days_from_dec_2011 = 6

    visit "#{base_url}?y=2012&m=1"

    wait_until_loaded    

    all_days = find_all_days

    (0...expected_number_of_days_from_dec_2011).each do |i|
      all_days[i].text.to_i.must(eql(the_number_of_days_in_dec_2011 - 5 + i))
    end
  end

  it "shows the days for the month prior to the requested month even when the requested month is march in a leap year" do
    the_number_of_days_in_feb_2000 = days_in 2000, 2
    the_number_of_days_in_feb_2000.must eql(29), "Invalid test data -- must be a leap year"

    expected_number_of_days_from_feb_2000 = 2

    visit "#{base_url}?y=2000&m=3"

    wait_until_loaded    

    all_days = find_all_days

    (0...expected_number_of_days_from_feb_2000).each do |i|
      all_days[i].text.to_i.must(eql(the_number_of_days_in_feb_2000 - 1 + i))
    end
  end
 
  it "starts each row on a monday" do 
    visit "#{base_url}?y=2011&m=9"

    wait_until_loaded
    
    the_days = find_all_days

    the_4th_day_text = the_days[3].text

    the_4th_day_text.to_i.must(eql(1), 
      "Expected the first of the month to be displayed as the 4th item " + 
      "in the calendar, instead it shows #{the_4th_day_text}"
    )
  end

  it "shows busy days for september 2011 (events spanning multiple days)" do
    assert_busy_days 2011,9   
  end

  it "shows busy days for august 2011 (single-day events)" do
    assert_busy_days 2011,8
  end

  it "shows the current month by default" do
    visit "#{base_url}"

    wait_until_loaded
    
    today = Date.today
    
    title = find_by_id("calendar-title-text").text

    expected_title = "#{Date::ABBR_MONTHNAMES[today.month]} #{today.year}"
    
    title.must === expected_title
  end

  it "shows a different calendar by setting month and/or year query parameters"

  it "uses the current year and month if either year or month is invalid" do
    today = Date.today
    
    visit "#{base_url}?y=xxx&m=1"

    pending "Yet to be implemented" do 
      wait_until_loaded

      title = find_by_id("calendar-title-text").text

      expected_title = "#{Date::ABBR_MONTHNAMES[today.month]} #{today.year}"

      title.must === "xxx"
    end
  end

  it "shows a message if either if either year or month is invalid"
  it "shows busy days for the previous month too"

  private 

  def assert_busy_days(year, month)
    expected_number_of_busy_days = calendar.get_busy_days_for month

    visit "#{base_url}?y=#{year}&m=#{month}"
    
    wait_until_loaded
    
    actual_number_of_busy_days = all("//div[@id='calendar']/span[@class='day busy']").size

    actual_number_of_busy_days.must(eql(expected_number_of_busy_days), 
      "Expected #{expected_number_of_busy_days} days to be marked as busy, " + 
      "got #{actual_number_of_busy_days}."
    )
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

      wait_until_loaded
    
      the_days = find_all_days

      the_days.size.must(eql(expected_number_of_days), 
        "Expected #{expected_number_of_days} days, got #{the_days.size}"
      )
    else
      super(name, args) 
    end
  end

  def find_all_days
    all("//div[@id='calendar']/span")
  end

  def wait_until_loaded
    wait.for(5.seconds).until { page.has_xpath? "//div[@id='calendar']/span" }; 
  end
end
