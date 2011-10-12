require "spec_helper"
 
describe "navigating between months" do
  include AcceptanceTest

  it "you can navigate to the next month" do
    month = 1
    
    visit "#{base_url}?y=#{2011}&m=#{month}"

    within ("//div[@id='calendar']") do
      click_link "next_month"
    end

    page.current_url.should == "#{base_url}?y=#{2011}&m=#{month + 1}"
  end

  it "next month is january of the following year when month is december" do 
    month = 12
    year = 2011

    visit "#{base_url}?y=#{year}&m=#{month}"

    within ("//div[@id='calendar']") do
      click_link "next_month"
    end

    page.current_url.should == "#{base_url}?y=#{year + 1}&m=#{1}"
  end

  it "you can navigate to the previous month" do
    month = 2
    
    visit "#{base_url}?y=#{2011}&m=#{month}"
    
    within ("//div[@id='calendar']") do
      click_link "prev_month"
    end
    
    page.current_url.should == "#{base_url}?y=#{2011}&m=#{month - 1}"
  end

  it "previous month is december of the previous year when month is january" do
    month = 1
    year = 2011

    visit "#{base_url}?y=#{year}&m=#{month}"
    
    within ("//div[@id='calendar']") do
      click_link "prev_month"
    end
    
    page.current_url.should == "#{base_url}?y=#{year - 1}&m=#{12}"
  end
end
