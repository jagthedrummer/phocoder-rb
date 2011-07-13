require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

  describe "Phocoder::HTTP::NetHTTP" do

    describe "call options" do
      it "should request with timeout" do
        stub_request(:post, "https://example.com")
        Timeout.expects(:timeout).with(0.001)
        Phocoder::HTTP::NetHTTP.post('https://example.com', :timeout => 1)
      end

      it "should request without timeout" do
        stub_request(:post, "https://example.com")
        Timeout.stubs(:timeout).raises(Exception)
        lambda { Phocoder::HTTP::NetHTTP.post('https://example.com', :timeout => nil) }.should_not raise_error(Exception)
      end

      it "should add params to the query string if passed" do
        stub_request(:post, "https://example.com/path?some=param")
        Phocoder::HTTP::NetHTTP.post('https://example.com/path', {:params => {:some => 'param' } })
      end

      it "should add params to the existing query string if passed" do
        stub_request(:post,'https://example.com/path?original=param&some=param')
        Phocoder::HTTP::NetHTTP.post('https://example.com/path?original=param', {:params => {:some => 'param'}})
      end

      it "should add headers" do
        stub_request(:post,'https://example.com/path').with(:headers => {'some' => 'header' })
        Phocoder::HTTP::NetHTTP.post('https://example.com/path', {:headers => {:some => 'header' } })
      end

      it "should add the body to the request" do
        stub_request(:post, 'https://example.com/path').with(:body => '{"some": "body"}')
        Phocoder::HTTP::NetHTTP.post('https://example.com/path', {:body => '{"some": "body"}'} )
      end
    end

    describe "SSL verification" do
      it "should verify when the SSL directory is found" do
        http_stub = stub(:use_ssl= => true, :ca_path= => true, :verify_depth= => true, :request => true)
        http_stub.expects(:verify_mode=).with(OpenSSL::SSL::VERIFY_PEER)
        ::Net::HTTP.expects(:new).returns(http_stub)
        Phocoder::HTTP::NetHTTP.any_instance.expects(:locate_root_cert_path).returns('/fake/path')
        Phocoder::HTTP::NetHTTP.post('https://example.com/path')
      end

      it "should not verify when set to skip ssl verification" do
        http_stub = stub(:use_ssl= => true, :request => true)
        http_stub.expects(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
        ::Net::HTTP.expects(:new).returns(http_stub)
        Phocoder::HTTP::NetHTTP.post('https://example.com/path', :skip_ssl_verify => true)
      end

      it "should not verify when the SSL directory is not found" do
        http_stub = stub(:use_ssl= => true, :ca_path= => true, :verify_depth= => true, :request => true)
        http_stub.expects(:verify_mode=).with(OpenSSL::SSL::VERIFY_NONE)
        ::Net::HTTP.expects(:new).returns(http_stub)
        Phocoder::HTTP::NetHTTP.any_instance.expects(:locate_root_cert_path).returns(nil)
        Phocoder::HTTP::NetHTTP.post('https://example.com/path')
      end
    end

    describe ".post" do
      it "should POST to specified body to the specified path" do
        Phocoder::HTTP::NetHTTP.expects(:post).
                                      with('https://example.com',:body => '{}').
                                      returns(Phocoder::Response.new)
        Phocoder::HTTP::NetHTTP.post('https://example.com',:body => '{}').should_not be_nil
      end
    end

    describe ".put" do
      it "should PUT to specified body to the specified path" do
        Phocoder::HTTP::NetHTTP.expects(:put).
                                      with('https://example.com',:body => '{}').
                                      returns(Phocoder::Response.new)
        Phocoder::HTTP::NetHTTP.put('https://example.com', :body => '{}')
      end
    end

    describe ".get" do
      it "should GET to specified body to the specified path" do
        Phocoder::HTTP::NetHTTP.expects(:get).
                                      with('https://example.com').
                                      returns(Phocoder::Response.new)
        Phocoder::HTTP::NetHTTP.get('https://example.com')
      end
    end

    describe ".delete" do
      it "should DELETE to specified body to the specified path" do
        Phocoder::HTTP::NetHTTP.expects(:delete).
                                      with('https://example.com').
                                      returns(Phocoder::Response.new)
        Phocoder::HTTP::NetHTTP.delete('https://example.com')
      end
    end
  end

