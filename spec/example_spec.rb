require "spec_helper"

describe "Connecting" do
  it "can connect to remote site" do
    visit "http://www.google.com"
    page.should have_button("Google Search")
  end

  it "can connect to file" do
    visit "file:///home/ben/sauce/google_calendar/example.html"
    page.should have_content "Time zone offset (hours): -12"
  end

  it "you can show a different calendar by setting month and/or year"
end
