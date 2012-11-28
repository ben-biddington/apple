require "spec_helper"

class Rates
  require "capybara"
  require "capybara/dsl"
  include Capybara::DSL

  def initialize
    visit "http://splitapplerock.com/rates.html"
  end

  def queen
    the_paragraph = all("//div[@class='text']/p")[0].text
    /Queen:(.+)/.match(the_paragraph)[1].strip
  end

  def twin
    the_paragraph = all("//div[@class='text']/p")[0].text
    /Twin:(.+)/.match(the_paragraph)[1].strip
  end

  def dinner
    the_paragraph = all("//div[@class='text']/p")[0].text
    /additional (\$[\d]+) per person/.match(the_paragraph)[1].strip
  end
end

describe "The split apple rock website" do
  let(:rates) { Rates.new }
  
  it "the room rates are correct" do
    rates.queen.must === "$155.00-$180.00"
    rates.twin.must === "$135.00-$165.00"
  end

  it "the dinner price is correct" do
    rates.dinner.must === "$42"
  end
end
