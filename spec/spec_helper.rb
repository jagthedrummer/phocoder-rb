$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'mocha'
require 'webmock/rspec'
require 'phocoder'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}


begin
  require 'typhoeus'
rescue LoadError # doesn't work for all ruby versions
  puts
  puts 'Typhoeus not loaded. If your ruby version supports native extensions'
  puts 'then consider installing it.'
  puts
  puts '   gem install typhoeus'
  puts
end


RSpec.configure do |config|
  config.mock_with :mocha 

  
  
end
