require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Phocoder" do

  
  it "should allow ENV variable to set an api key" do
    Phocoder.api_key = nil
    ENV['PHOCODER_API_KEY'] = "envkey"
    Phocoder.api_key.should == "envkey"
    Phocoder::Job.api_key.should == "envkey"
  end
  
  it "should allow user to set API key" do
    Phocoder.api_key = "testkey"
    Phocoder.api_key.should == "testkey"
    Phocoder::Job.api_key.should == "testkey"
  end
  
  it "should take user-supplie api key over ENV-supplied key" do
    Phocoder.api_key = "testkey"
    ENV['PHOCODER_API_KEY'] = "envkey"
    Phocoder.api_key.should == "testkey"
    Phocoder::Job.api_key.should == "testkey"
  end
  
  it "should encode to json" do
    Phocoder::Base.encode({:api_request => {:input => 'https://example.com'}}, :json).should =~ /"api_request"/
  end
  
  it "should encode to xml" do
    Phocoder::Base.encode({:api_request => {:input => 'https://example.com'}}, :xml).should =~ /<api-request>/
  end
  
  it "should encode to xml with multiple keys" do
    Phocoder::Base.encode({:api_request => {:input => 'https://example.com'}, :test=>"testing"}, :xml).should =~ /api-request/
  end
  
  it "should default to encoding to json" do
    Phocoder::Base.encode({:api_request => {:input => 'https://example.com' } }).should =~ /"api_request"/
  end

  it "should not encode when the content is a String" do
    Phocoder::Base.encode("api_request").should =~ /^api_request$/
  end

  it "should decode from xml" do
    Phocoder::Base.decode("<api-request><input>https://example.com</input></api-request>", :xml)['api_request']['input'].should == "https://example.com"
  end

  it "should decode from json" do
    Phocoder::Base.decode(%@{"api_request": {"input": "https://example.com"}}@, :json)['api_request']['input'].should == "https://example.com"
  end

  it "should default to decoding from json" do
    Phocoder::Base.decode(%@{"api_request": {"input": "https://example.com"}}@)['api_request']['input'].should == "https://example.com"
  end

  it "should not decode when content is not a String" do
    Phocoder::Base.decode(1).should == 1
  end
  
  it "should have a base url" do
    Phocoder::Base.base_url.should_not be_nil
  end
  
end
