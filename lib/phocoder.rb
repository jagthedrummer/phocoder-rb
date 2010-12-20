require 'cgi'
require 'net/https'
require 'timeout'

# ActiveSupport 3.0 with fallback to 2.0
begin
  require 'active_support/all' # Screw it
rescue LoadError
  require 'active_support' # JSON and XML parsing/encoding
end

require 'phocoder/extensions'
require 'phocoder/phocoder'
require 'phocoder/base'
require 'phocoder/http/net_http'
require 'phocoder/http/typhoeus'
require 'phocoder/http'
require 'phocoder/errors'
require 'phocoder/job'
require 'phocoder/response'
