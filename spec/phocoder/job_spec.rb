require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Phocoder::Job" do
  
  before(:each) do
    @api_key = 'abc123'
  end
  
  describe ".create" do
    before(:each) do
      @url = "#{Phocoder.base_url}/jobs"
      @params = {:api_key => @api_key,:input => "s3://bucket-name/file-name.avi" }
      @params_as_json = Phocoder::Base.encode(@params, :json)
      @params_as_xml = Phocoder::Base.encode(@params, :xml)
    end
    
    it "should POST to the correct url and return a response" do
      Phocoder::HTTP.expects(:post).with(@url, @params_as_json, {}).returns(Phocoder::Response.new)
      r = Phocoder::Job.create(@params)
      r.class.should == Phocoder::Response
    end
    
    it "should apply the global API key when JSON and no api_key is passed" do
      Phocoder.api_key = 'asdfasdf'
      Phocoder::HTTP.expects(:post).with(@url,@params_as_json,{}) do |url, params, options|
        Phocoder::Base.decode(params)['api_key'].should == Phocoder.api_key
        end.returns(Phocoder::Response.new)
      Phocoder::Job.create(:input => @params[:input])
      Phocoder.api_key = nil
    end
      
    it "should apply the global API key when XML and no api_key is passed" do
      Phocoder.api_key = 'asdfasdf'
      Phocoder::HTTP.expects(:post).with(@url,@params_as_xml,{}) do |url, params, options|
        Phocoder::Base.decode(params, :xml)['api_request']['api_key'].should == Phocoder.api_key
      end.returns(Phocoder::Response.new)
      Phocoder::Job.create({:api_request => {:input => @params[:input]}}, {:format => :xml})
      Phocoder.api_key = nil
    end
        
    it "should apply the global API key when an XML string is passed and no api_key is passed" do
      Phocoder.api_key = 'asdfasdf'
      Phocoder::HTTP.expects(:post).with(@url,@params_as_xml,{}) do |url, params, options|
        Phocoder::Base.decode(params, :xml)['api_request']['api_key'] == Phocoder.api_key
      end.returns(Phocoder::Response.new)
      Phocoder::Job.create({:input => @params[:input]}.to_xml(:root => :api_request), {:format => :xml})
      Phocoder.api_key = nil
    end
          
  end


  describe ".list" do
    before(:each) do
      @url = "#{Phocoder.base_url}/jobs"
    end

    it "should GET the correct url and return a response" do
      Phocoder::HTTP.stubs(:get).with(@url, {:params => {:api_key => @api_key,
                                                          :page => 1,
                                                          :per_page => 50,
                                                          :state => nil}}).returns(Phocoder::Response.new)
     Phocoder::Response.should == Phocoder::Job.list(:api_key => @api_key).class
    end

    it "should merge params well" do
      Phocoder::HTTP.stubs(:get).with(@url, {:params => {:api_key => @api_key,
                                                         :page => 1,
                                                         :per_page => 50,
                                                         :some => 'param',
                                                         :state => nil}}).returns(Phocoder::Response.new)
      Phocoder::Response.should ==  Phocoder::Job.list(:api_key => @api_key, :params => {:some => 'param'}).class
    end
  end

  describe ".details" do
    before(:each) do
      @job_id = 1
      @url = "#{Phocoder.base_url}/jobs/#{@job_id}"
    end

    it "should GET the correct url and return a response" do
      Phocoder::HTTP.stubs(:get).with(@url, {:params => {:api_key => @api_key}}).returns(Phocoder::Response.new)
      Phocoder::Response.should ==  Phocoder::Job.details(1, :api_key => @api_key).class
    end
  end

  describe ".resubmit" do
    before(:each) do
      @job_id = 1
      @url = "#{Phocoder.base_url}/jobs/#{@job_id}/resubmit"
    end

    it "should GET the correct url and return a response" do
      Phocoder::HTTP.stubs(:get).with(@url, {:params => {:api_key => @api_key}}).returns(Phocoder::Response.new)
      Phocoder::Response.should ==  Phocoder::Job.resubmit(1, :api_key => @api_key).class
    end
  end

  describe ".cancel" do
    before(:each) do
      @job_id = 1
      @url = "#{Phocoder.base_url}/jobs/#{@job_id}/cancel"
    end

    it "should GET the correct url and return a response" do
      Phocoder::HTTP.stubs(:get).with(@url, {:params => {:api_key => @api_key}}).returns(Phocoder::Response.new)
      Phocoder::Response.should ==  Phocoder::Job.cancel(1, :api_key => @api_key).class
    end
  end

  describe ".delete" do
    before(:each) do
      @job_id = 1
      @url = "#{Phocoder.base_url}/jobs/#{@job_id}"
    end

    it "should DELETE the correct url and return a response" do
      Phocoder::HTTP.stubs(:delete).with(@url, {:params => {:api_key => @api_key}}).returns(Phocoder::Response.new)
      Phocoder::Response.should ==  Phocoder::Job.delete(1, :api_key => @api_key).class
    end
end

        
      end