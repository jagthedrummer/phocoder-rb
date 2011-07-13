module Phocoder
  class Base
    
    def self.api_key
      Phocoder.api_key
    end
    
    def self.base_url
      Phocoder.base_url
    end
    
    def self.encode(content, format=nil)
      if content.is_a?(String)
        content
      elsif format.to_s == 'xml'
        if content.is_a?(Hash) && content.keys.size == 1
          content[content.keys.first].to_xml(:root => content.keys.first)
        else
          content.to_xml
        end
      else
        content.to_json
      end
    end
    
    def encode(content, format=nil)
      self.class.encode(content, format)
    end
    
    def self.decode(content, format=nil)
      begin
        if content.is_a?(String)
          if format.to_s == 'xml'
            Hash.from_xml(content)
          else
            ActiveSupport::JSON.decode(content)
          end
        else
          content
        end
      rescue Exception => e
        content
      end   
    end

    def decode(content, format=nil)
      self.class.decode(content, format)
    end

    protected

    def self.apply_api_key(params, format=nil)
      if api_key
        decoded_params = decode(params, format).with_indifferent_access

        if decoded_params[:api_request]
          decoded_params[:api_request] = decoded_params[:api_request].with_indifferent_access
        end

        if format.to_s == 'xml'
          if !(decoded_params[:api_request] && decoded_params[:api_request][:api_key])
            decoded_params[:api_request] ||= {}.with_indifferent_access
            decoded_params[:api_request][:api_key] = api_key
          end
        else
          decoded_params['api_key'] = api_key unless decoded_params['api_key']
        end

        decoded_params
      else
        params
      end
    end

    def self.merge_params(options, params)
      if options[:params]
        options[:params] = options[:params].merge(params)
        options
      else
        options.merge(:params => params)
      end
    end
    
  end
end