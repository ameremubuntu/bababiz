require 'rake'

ns = File.dirname(__FILE__).split('/')[-2]

namespace ns.to_sym do
  desc "Run test suite using the webkit browser in headless mode."
  task :webkit do
    Dir.chdir(ns)
    ENV['capybara'] = "webkit"
    ENV["namespace"] = ns
    exec "bundle exec spinach"
  end

  desc "Run the test suite using selenium on the local system. (takes vars.  browser=firefox/chrome, etc)"
  task :selenium do
    Dir.chdir(ns)
    ENV['capybara'] = "selenium"
    ENV["namespace"] = ns
    exec "bundle exec spinach"
  end
  
  desc "Run the test suite using saucelabs by default or a selenium grid host.  Takes the same vars as selenium task."
  task :remote do
    Dir.chdir(ns)
    ENV['capybara'] = "remote"
    ENV["namespace"] = ns
    exec "bundle exec spinach"
  end
  
  desc "Run individual feature file from project #{ns}"
  task :single, :feat, :browser do |t,arg|
    Dir.chdir(ns)
    ENV['capybara'] = arg[:browser]
    ENV["namespace"] = ns
    puts "Running #{ns}/features/#{arg[:feat]}"
    exec "bundle exec spinach features/#{arg[:feat]}"
  end
  
end
