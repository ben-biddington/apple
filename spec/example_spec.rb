require "spec_helper"

describe "Connecting" do
  before :all do
    @base_url = "file:///home/ben/sauce/split_apple_rock/calendar.html"
  end

  it "can connect to remote site" do
    visit "http://www.google.com"
    page.should have_button("Google Search")
  end

  it "can connect to file" do
    visit @base_url
    page.should have_content "Time zone offset (hours): -12"
  end
end
