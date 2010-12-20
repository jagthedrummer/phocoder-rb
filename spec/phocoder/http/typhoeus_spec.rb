require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')


  # Most useless tests ever, but who knows, right?

  if defined?(Typhoeus)

    describe "Phocoder::HTTP::Typhoeus" do
      describe ".post" do
        it "should POST using Typhoeus" do
          Typhoeus::Request.expects(:post).with('https://example.com', {:some => 'options'})
          Phocoder::HTTP::Typhoeus.post('https://example.com', {:some => 'options'})
        end
      end

      describe ".put" do
        it "should PUT using Typhoeus" do
          Typhoeus::Request.expects(:put).with('https://example.com', {:some => 'options'})
          Phocoder::HTTP::Typhoeus.put('https://example.com', {:some => 'options'})
        end
      end

      describe ".get" do
        it "should GET using Typhoeus" do
          Typhoeus::Request.expects(:get).with('https://example.com', {:some => 'options'})
          Phocoder::HTTP::Typhoeus.get('https://example.com', {:some => 'options'})
        end
      end

      describe ".delete" do
        it "should DELETE using Typhoeus" do
          Typhoeus::Request.expects(:delete).with('https://example.com', {:some => 'options'})
          Phocoder::HTTP::Typhoeus.delete('https://example.com', {:some => 'options'})
        end
      end

      it "should skip ssl verification" do
        Typhoeus::Request.expects(:get).with('https://example.com', {:disable_ssl_peer_verification => true})
        Phocoder::HTTP::Typhoeus.get('https://example.com', {:skip_ssl_verify => true})
      end
    end

  end
