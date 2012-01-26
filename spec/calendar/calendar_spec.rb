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

  it "shows busy days for april 2011 (events spanning multiple days)" do
    assert_busy_days 2011, 4
  end

  it "shows busy days for august 2011 (single-day events)" do
    assert_busy_days 2011, 8
  end

  it "shows busy days for the previous month too" do 
    busy_in_sep_2011 = calendar.get_busy_days_for(2011, 9)
    busy_in_aug_2011 = calendar.get_busy_days_for(2011, 8)

    busy_in_aug_2011.size.must(be > 0, "Invalid test data -- no busy days for aug 2011")
    busy_in_sep_2011.size.must(be > 0, "Invalid test data -- no busy days for sep 2011")

    expected_number_of_busy_days = (busy_in_aug_2011 + busy_in_sep_2011).inject(0) do |sum, entry|
      sum + entry.duration_in_days
    end.to_i

    visit "#{base_url}?y=#{2011}&m=#{9}"
    
    wait_until_loaded
    
    actual_number_of_busy_days = all("//div[@id='calendar']/span[@class='day busy']").size

    actual_number_of_busy_days.must(eql(expected_number_of_busy_days), 
      "Expected #{expected_number_of_busy_days} days to be marked as busy, " + 
      "got #{actual_number_of_busy_days}."
    )

    (busy_in_aug_2011 + busy_in_sep_2011).each do |day|
      (0...day.duration_in_days).each do |i|
        assert_marked_busy(day.start + i)
      end
    end
  end

  it "shows the current month by default" do
    visit "#{base_url}"

    wait_until_loaded
    
    today = Date.today
    
    title = find_by_id("calendar-title-text").text

    expected_title = "#{Date::ABBR_MONTHNAMES[today.month]} #{today.year}"
    
    title.must === expected_title
  end

  it "shows a different calendar by setting month and/or year query parameters" do
    visit "#{base_url}?y=1976&m=9"
    
    wait_until_loaded

    find_by_id("calendar-title-text").text.must === "Sep 1976"

    visit "#{base_url}?y=1976&m=11"
    
    wait_until_loaded

    find_by_id("calendar-title-text").text.must === "Nov 1976"
  end

  it "uses the current year if the \"y\" parameter is invalid" do
    expected_title = "Nov #{Date.today.year}"
    
    visit "#{base_url}?y=xxx&m=11"

    wait_until_loaded

    find_by_id("calendar-title-text").text.must === expected_title
  end

  it "uses the current month if the \"m\" parameter is invalid" do
    month = Date.today.month

    expected_title = "#{Date::ABBR_MONTHNAMES[month]} 1976"
    
    visit "#{base_url}?y=1976&m=#{}"

    wait_until_loaded

    find_by_id("calendar-title-text").text.must === expected_title
  end

  private 

  def assert_busy_days(year, month)
    expected_busy_days = calendar.get_busy_days_for year, month
    expected_number_of_busy_days = expected_busy_days.size

    visit "#{base_url}?y=#{year}&m=#{month}"
    
    wait_until_loaded
    
    actual_number_of_busy_days = all("//div[@id='calendar']/span[@class='day busy']").size

    actual_number_of_busy_days.must(eql(expected_number_of_busy_days), 
      "Expected #{expected_number_of_busy_days} days to be marked as busy, " + 
      "got #{actual_number_of_busy_days}."
    )

    expected_busy_days.each do |day|
      (0...day.duration_in_days).each do |i|
        assert_marked_busy(day.start + i)
      end
    end
  end
  
  def assert_marked_busy(day)
    element_id = "#{day.year}_#{day.month}_#{day.day}"
    the_element = find_by_id element_id
    the_element.must_not(be_nil, "Did not find the element with id #{element_id}")
    the_element["class"].must(match(/busy/), 
      "Expected the element's css class <#{the_element["class"]}> to include \"busy\""
    )
    the_element.text.must(eql(day.day.to_s), "Expected the element's text to be <#{day.day}>, but it was <#{the_element.text}>")
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
