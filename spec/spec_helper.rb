require "rspec"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"
require "garcon"

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include GarconDsl
end

Capybara.javascript_driver = :webkit
Capybara.default_driver    = Capybara.javascript_driver
Capybara.default_selector  = :xpath

Capybara::Driver::Webkit::Browser.class_eval do 
  def forward_stdout(pipe); end;
end

Capybara::Driver::Webkit.class_eval do 
  def visit(path)
    browser.visit(path)
  end
end

Fixnum.class_eval do 
  def seconds; self; end
end
