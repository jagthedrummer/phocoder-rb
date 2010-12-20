module Phocoder

  mattr_writer :api_key
  mattr_writer :base_url

  self.api_key  = nil
  self.base_url = 'https://photoapi.chaos.webapeel.com/'

  def self.api_key
    @@api_key || ENV['PHOCODER_API_KEY']
  end

  def self.base_url(env=nil)
    @@base_url
  end

end