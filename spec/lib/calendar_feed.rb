class CalendarFeed
  def initialize(calendar_url)
    @url = "https://www.google.com/calendar/feeds/#{calendar_url}/public/basic"
  end

  def timezone
    xpath("//gCal:timezone/@value").first.content    
  end

  def get_busy_days_for(year, month)
    total_days = 0
    result = []

    entries.each do |entry|
      date_string = entry.xpath("atom:content/text()", namespaces).first.content
      entry = CalendarEntryParser.parse(date_string)

      if entry.start.year == year and entry.start.month == month
        result << entry
      end
    end

    result
  end

  def total_busy_days_for(year, month)
    expected_number_of_busy_days = (get_busy_days_for).inject(0) do |sum, entry|
      sum + entry.duration_in_days
    end.to_i
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
