require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Phocoder::HTTP" do
  
  it "should have a default_options hash" do
    Phocoder::HTTP.default_options.is_a?(Hash).should be_true
  end
  
  it "should have a default HTTP backend" do
    Phocoder::HTTP.http_backend.should_not be_nil
  end
  
  
      it "should allow the changing of the HTTP backend" do
        Phocoder::HTTP.http_backend.should_not == Phocoder::HTTP::Typhoeus  
        lambda {  Phocoder::HTTP.http_backend = Phocoder::HTTP::Typhoeus }.should_not raise_error(Exception)
        Phocoder::HTTP.http_backend.should ==  Phocoder::HTTP::Typhoeus
      end
  
      it "should raise a Phocoder::HTTPError when there is an HTTP error" do
        Phocoder::HTTP.http_backend.expects(:get).
                                    with('https://example.com', Phocoder::HTTP.default_options).
                                    at_least_once.
                                    raises(Errno::ECONNREFUSED)
        lambda { Phocoder::HTTP.get('https://example.com') }.should raise_error(Phocoder::HTTPError)

        begin
          Phocoder::HTTP.get('https://example.com')
        rescue Phocoder::HTTPError => e
          e.backtrace.first.should_not =~ /perform_method/ 
        end
      end
  
      it "should return a Phocoder::Response" do
        Phocoder::HTTP.http_backend.stubs(:post).returns(stub(:code => 200, :body => '{"some": "hash"}'))
        Phocoder::HTTP.http_backend.stubs(:put).returns(stub(:code => 200, :body => '{"some": "hash"}'))
        Phocoder::HTTP.http_backend.stubs(:get).returns(stub(:code => 200, :body => '{"some": "hash"}'))
        Phocoder::HTTP.http_backend.stubs(:delete).returns(stub(:code => 200, :body => '{"some": "hash"}'))
  
        Phocoder::HTTP.post('https://example.com', '{"some": "hash"}').is_a?(Phocoder::Response).should be_true
        Phocoder::HTTP.put('https://example.com', '{"some": "hash"}').is_a?(Phocoder::Response).should be_true
        Phocoder::HTTP.get('https://example.com').is_a?(Phocoder::Response).should be_true
        Phocoder::HTTP.delete('https://example.com').is_a?(Phocoder::Response).should be_true
      end
  
      it "should store the raw response" do
        post_stub = stub(:code => 200, :body => '{"some": "hash"}')
        Phocoder::HTTP.http_backend.stubs(:post).returns(post_stub)
        Phocoder::HTTP.post('https://example.com', '{"some": "hash"}').raw_response.should == post_stub
      end
  
      it "should store the raw response body" do
        Phocoder::HTTP.http_backend.stubs(:post).returns(stub(:code => 200, :body => '{"some": "hash"}'))
        Phocoder::HTTP.post('https://example.com', '{"some": "hash"}').raw_body.should == '{"some": "hash"}'
      end
  
      it "should store the response code" do
        Phocoder::HTTP.http_backend.stubs(:post).returns(stub(:code => 200, :body => '{"some": "hash"}'))
        Phocoder::HTTP.post('https://example.com', '{"some": "hash"}').code.should == 200
      end
  
      it "should JSON parse the response body" do
        Phocoder::HTTP.http_backend.stubs(:put).returns(stub(:code => 200, :body => '{"some": "hash"}'))
        Phocoder::HTTP.put('https://example.com', '{"some": "hash"}').body.should == {'some' => 'hash'}
      end
  
      it "should store the raw body if the body fails to be JSON parsed" do
        Phocoder::HTTP.http_backend.stubs(:put).returns(stub(:code => 200, :body => '{"some": bad json'))
        Phocoder::HTTP.put('https://example.com', '{"some": "hash"}').body.should == '{"some": bad json'
      end
  
      describe ".post" do
        it "should call post on the http_backend" do
          Phocoder::HTTP.http_backend.expects(:post).
                                      with('https://example.com', Phocoder::HTTP.default_options.merge(:body => '{}')).
                                      returns(Phocoder::Response.new)
  
          Phocoder::HTTP.post('https://example.com', '{}').should_not be_nil
        end
      end
  
      describe ".put" do
        it "should call put on the http_backend" do
          Phocoder::HTTP.http_backend.expects(:put).
                                      with('https://example.com', Phocoder::HTTP.default_options.merge(:body => '{}')).
                                      returns(Phocoder::Response.new)
  
          Phocoder::HTTP.put('https://example.com', '{}').should_not be_nil
        end
      end
  
      describe ".get" do
        it "should call post on the http_backend" do
          Phocoder::HTTP.http_backend.expects(:get).
                                      with('https://example.com', Phocoder::HTTP.default_options).
                                      returns(Phocoder::Response.new)
  
          Phocoder::HTTP.get('https://example.com').should_not be_nil
        end
      end
  
      describe ".delete" do
        it "should call post on the http_backend" do
          Phocoder::HTTP.http_backend.expects(:delete).
                                      with('https://example.com', Phocoder::HTTP.default_options).
                                      returns(Phocoder::Response.new)
  
          Phocoder::HTTP.delete('https://example.com').should_not be_nil
        end
      end
  
  
  
  
  
  
end