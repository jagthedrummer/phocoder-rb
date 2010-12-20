require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Phocoder::Response" do
  
  
    describe "#success?" do
      it "should return true when code is between 200 and 299" do
        Phocoder::Response.new(:code => 200).success?.should be_true
        Phocoder::Response.new(:code => 299).success?.should be_true
        Phocoder::Response.new(:code => 250).success?.should be_true
      end

      it "should return false when code it less than 200 or greater than 299" do
        Phocoder::Response.new(:code => 300).success?.should_not be_true
        Phocoder::Response.new(:code => 199).success?.should_not be_true
      end
    end

    describe "#errors" do
      it "should return an empty array when body is not a Hash" do
        Phocoder::Response.new(:body => 1).errors.should ==  []
        Phocoder::Response.new(:body => "something").errors.should ==  []
        Phocoder::Response.new(:body => [1]).errors.should ==  []
      end

      it "should return the value of the key 'errors' as a compacted array when body is a Hash" do
        Phocoder::Response.new(:body => {'errors' => ['must be awesome']}).errors.should ==   ['must be awesome']
        Phocoder::Response.new(:body => {'errors' => 'must be awesome'}).errors.should ==   ['must be awesome']
        Phocoder::Response.new(:body => {'errors' => ['must be awesome', nil]}).errors.should ==   ['must be awesome']
        Phocoder::Response.new(:body => {}).errors.should ==   []
      end
    end

    describe "#body_without_wrapper" do
      it "should return the body when the body is a string" do
        Phocoder::Response.new(:body => "some text").body_without_wrapper.should ==  "some text"
      end

      it "should return the body when the body is not wrapped in api_response and is a hash" do
       Phocoder::Response.new(:body => {'some' => 'hash'}).body_without_wrapper.should == {'some' => 'hash'}
      end

      it "should return body['api_response'] when body is a hash and body['api_response'] exists" do
        Phocoder::Response.new(:body => {'api_response' => {'some' => 'hash'}}).body_without_wrapper.should == {'some' => 'hash'}
      end
    end
  
  
end