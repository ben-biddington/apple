require "spec_helper"

describe "The calendar on the split apple rock site" do 
  it "shows the correct timezone" do
    visit "file:///home/ben/sauce/google_calendar/example.html"
    page.should have_content "Time zone offset (hours): -12"
  end

  it "shows a different calendar by setting month and/or year query parameters"
  it "shows the correct days for whatever month is requested"
  it "shows all the the calendar items for the requested month"
end
