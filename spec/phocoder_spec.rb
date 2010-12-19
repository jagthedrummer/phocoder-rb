require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Phocoder" do

  
  it "should allow ENV variable to set an api key" do
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
  
end
