class CalendarFeed
  def initialize(calendar_url)
    @url = "https://www.google.com/calendar/feeds/#{calendar_url}/public/basic"
  end

  def timezone
    xpath("//gCal:timezone/@value").first.content    
  end

  def get_busy_days_for(month)
    total_days = 0

    entries.each do |entry|
      date_string = entry.xpath("atom:content/text()", namespaces).first.content
      entry = CalendarEntryParser.parse(date_string)
      
      if entry.start.month == month
        total_days += entry.duration_in_days.to_i
      end
    end

    total_days
  end

  def entries; xpath("//atom:entry"); end

  private

  def xpath(what)
    xml.xpath(what, namespaces)
  end
  
  def xml
    require "nokogiri"
    require "open-uri"
    @xml ||= Nokogiri::XML(open(@url))
  end

  def namespaces
    {
      'atom'       => 'http://www.w3.org/2005/Atom',
      'openSearch' => "http://a9.com/-/spec/opensearchrss/1.0/", 
      'gCal'       => 'http://schemas.google.com/gCal/2005', 
      'gd'         => 'http://schemas.google.com/g/2005'
    }
  end
end
