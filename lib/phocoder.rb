
# ActiveSupport 3.0 with fallback to 2.0
begin
  require 'active_support/all' # Screw it
rescue LoadError
  require 'active_support' # JSON and XML parsing/encoding
end

require 'phocoder/phocoder'
require 'phocoder/base'
require 'phocoder/job'