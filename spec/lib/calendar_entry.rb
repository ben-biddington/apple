class CalendarEntry
  attr_reader :start,:end

  def initialize(start, _end = nil)
    @start = start
    @end = _end
  end

  def duration_in_days
    return 1 if @end.nil?
    return (@end - @start) + 1
  end
  
  def inspect
    ":start => #{@start}, :end => #{@end}, :duration_in_days => #{duration_in_days}"
  end
end

class CalendarEntryParser
  class << self 
    def parse(text)
      time_pattern = "[0-9]{2}:[0-9]{2}"
      date_pattern = "([A-Za-z]{3} [0-9]{1,2} [A-Za-z]{3} [0-9]{4})"
      pattern = /When: #{date_pattern}(.+to #{date_pattern})?/

      match = pattern.match(text)
      start = to_date match[1].to_s

      _end = nil

      unless match[3].nil?
        _end = to_date match[3].to_s 
      end

      CalendarEntry.new start, _end 
    end

    private

    def to_date(text); Date.strptime(text, "%a %d %b %Y"); end
  end
end
