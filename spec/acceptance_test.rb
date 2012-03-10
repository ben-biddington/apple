module AcceptanceTest
  def self.included(klass)
    klass.class_eval do
      let(:base_url){"file:///#{File.expand_path("public_html/calendar.html")}"}

      let :calendar do 
        CalendarFeed.new "vddp2rq2f0j1asv103n6jps2og@group.calendar.google.com"    
      end

      before :all do
        configure_google_calendar_for_test
      end

      private 
      
      def configure_google_calendar_for_test
        %x{ln -f public_html/js/config.test.js public_html/js/config.js}
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
