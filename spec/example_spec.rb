require "spec_helper"
require "nokogiri"
require "open-uri"

describe "Connecting" do
  it "can connect to remote site" do
    visit "http://www.google.com"
    page.should have_button("Google Search")
  end

  it "can connect to file" do
    visit "file:///home/ben/sauce/google_calendar/example.html"
    page.should have_content "Time zone offset (hours): -12"
  end

  it "you can load the xml for the calendar" do
    xml = Nokogiri::XML(open("https://www.google.com/calendar/feeds/vddp2rq2f0j1asv103n6jps2og@group.calendar.google.com/public/basic"))

    namespaces = {
      'atom' => 'http://www.w3.org/2005/Atom',
      'openSearch' => "http://a9.com/-/spec/opensearchrss/1.0/", 
      'gCal' => 'http://schemas.google.com/gCal/2005', 
      'gd' => 'http://schemas.google.com/g/2005'
    }

    count = xml.xpath("//openSearch:totalResults/text()").first.content.to_i
    timezone = xml.xpath("//gCal:timezone/@value").first.content

    timezone.should === "Pacific/Auckland"
    
    the_entries = xml.xpath("//atom:entry", namespaces)

    the_entries.size.should > 0
  end

  it "you can show a different calendar by setting month and/or year"
end
