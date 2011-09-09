require "spec_helper"

describe "Fetching the calendar" do
  it "you can load the xml for the calendar" do
    calendar = CalendarFeed.new "vddp2rq2f0j1asv103n6jps2og@group.calendar.google.com"
    calendar.timezone.should === "Pacific/Auckland"
    calendar.entries.size.should > 0
  end
end
