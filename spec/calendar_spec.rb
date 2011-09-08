require "spec_helper"

describe "The calendar on the split apple rock site" do 
  before :all do
    @base_url = "file:///home/ben/sauce/split_apple_rock/calendar.html"
  end

  it "shows the correct timezone" do
    visit @base_url
    page.should have_content "Time zone offset (hours): -12"
  end

  it "shows the correct days for whatever month is requested" do
    visit "#{@base_url}?y=2011&m=sep"
    page.should have_content "Time zone offset (hours): -12"
  end

  it "shows a different calendar by setting month and/or year query parameters"

  it "shows all the the calendar items for the requested month"
end
