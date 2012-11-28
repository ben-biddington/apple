require "spec_helper"

class Rates
  require "capybara"
  require "capybara/dsl"
  include Capybara::DSL

  def initialize
    visit "http://splitapplerock.com/rates.html"
  end

  def queen
    /Queen:(.+)/.match(first_price_para)[1].strip
  end

  def twin
    /Twin:(.+)/.match(first_price_para)[1].strip
  end

  def dinner
    /additional (\$[\d]+) per person/.match(first_price_para)[1].strip
  end

  private

  def first_price_para
    all("//div[@class='text']/p")[0].text
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
