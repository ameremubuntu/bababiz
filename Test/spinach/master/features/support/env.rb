require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'rspec'
require 'spinach/capybara'
require 'capybara-webkit'
require 'headless'
require 'spinach'
require 'selenium-webdriver'
require 'pony'
require File.join(File.dirname(__FILE__), 'domain_utils')
require 'show_me_the_cookies'

include Capybara::DSL
include Capybara::RSpecMatchers
Spinach::FeatureSteps.send(:include, RSpec::Matchers)
Spinach::FeatureSteps.send(:include, ShowMeTheCookies)

@serverheaders = Array.new
  
# Common to all browsers.  We want to clear out any saved information between steps to ensure we aren't treading on toes.
Spinach.hooks.after_feature do
  Capybara.reset_sessions!
end

# Capture screenshots at the top level.  Driver methods depend on selenium/webkit.
def capscreen(driver,step_data,location)
  site = domain_remove_www(ENV['capybara_apphost'])
  folder = "../log/#{site}/#{ENV['namespace']}"
  if not File.directory?(folder)
    FileUtils.mkdir_p(folder)
  end

  stepname = step_data['name'].to_s.split.join('_')
  filename = "#{folder}/#{step_data['keyword'].strip}_#{stepname}_line#{step_data['line']}.png"
  puts "\tSaving screenshot for failed test in: #{filename}"

  begin
    driver.render(filename)
  rescue NoMethodError
    driver.browser.save_screenshot(filename)
  rescue
    puts "\t\tCould not save screenshot (maybe n/a for this test)"
  end
end

if ENV["capybara"] == "webkit"
  
  def dumpheaders(driver)
    begin
      puts "\t\t------ HTTP RESPONSE HEADERS -------"
      puts "\t\tCP: #{driver.response_headers['CP']}"
      puts "\t\tSet-Cookie: #{driver.response_headers['Set-Cookie'].split('\n')}"
      puts "\t\t------------------------------------"
    rescue
      puts "\t\tError: No headers available"
    end
  end
  
  begin
    headless = Headless.new(:destroy_at_exit => false, :display => ENV["display"].to_i )
  rescue
    headless = Headless.new(:destroy_at_exit => false)
  end
  
  Spinach.hooks.before_run do
    headless.start
  end
  
  Capybara.register_driver :webkit do |app|
    Capybara::Driver::Webkit.new(app,:ignore_ssl_errors => true)
  end

  Capybara.default_driver = :webkit
  Capybara.run_server = false

  if ENV["noisy"] == "true"
  
    Spinach.hooks.after_step do |step_data,location|
      driver = Capybara.current_session.driver
      dumpheaders(driver)
      puts @serverheaders
    end
    
  end
  
  Spinach.hooks.on_failed_step do |step_data,location|
    driver = Capybara.current_session.driver
    capscreen(driver,step_data,location)
  end
  Spinach.hooks.on_error_step do |step_data,location|
    driver = Capybara.current_session.driver
    capscreen(driver,step_data,location)
  end                               
  
else
  Capybara.register_driver :selenium do |app|
    begin
      browser = ENV['browser'].to_sym
    rescue
      browser = :firefox
    end
    Capybara::Selenium::Driver.new(app, :browser => browser)
  end
  Capybara.default_driver = :selenium
  Capybara.run_server = false
  
 
  Spinach.hooks.on_failed_step do |step_data,location|
    driver = Capybara.current_session.driver
    capscreen(driver,step_data,location)
  end
  Spinach.hooks.on_error_step do |step_data,location|
    driver = Capybara.current_session.driver
    capscreen(driver,step_data,location)
  end
end

Capybara.app_host = ENV["capybara_apphost"]
if ENV["host_header"] and ENV["capybara"] == "webkit"
  driver = Capybara.current_session.driver
  driver.header "Host", ENV["host_header"]
end

