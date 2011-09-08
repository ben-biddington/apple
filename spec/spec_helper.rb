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
Capybara.default_driver = Capybara.javascript_driver

Capybara::Driver::Webkit::Browser.class_eval do 
  def forward_stdout(pipe); end;
end
