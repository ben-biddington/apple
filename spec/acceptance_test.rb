module AcceptanceTest
  def self.included(klass)
    klass.class_eval do
      let(:base_url){"file:///home/ben/sauce/split_apple_rock/public_html/calendar.html"}

      let :calendar do 
        CalendarFeed.new "vddp2rq2f0j1asv103n6jps2og@group.calendar.google.com"    
      end
    end
  end

  def find_all_days
    all("//div[@id='calendar']/span")
  end

  def days_in(year, month_index) 
    Date.new(year, month_index, -1).day
  end
end
