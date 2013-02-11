require 'spec_helper'
module Alf
  module Rest
    describe "rest_get", "Accept header" do
      include Rack::Test::Methods

      def app
        mock_app do
          rest_get '/suppliers' do
            relvar{ suppliers }
          end
        end
      end

      def last_meta
        [last_response.status, last_response.content_type]
      end

      it 'defaults to application/json when unspecified' do
        #
        get '/suppliers'
        #
        last_meta.should eq([200, "application/json"])
        #
        result = JSON.load(last_response.body)
        result.should be_a(Array)
        result.size.should eq(5)
      end

      it 'supports */* and fallbacks to application/json' do
        #
        header "Accept", "*/*"
        get '/suppliers'
        #
        last_meta.should eq([200, "application/json"])
        #
        result = JSON.load(last_response.body)
        result.should be_a(Array)
        result.size.should eq(5)
      end

      it 'supports application/json' do
        #
        header "Accept", "application/json"
        get '/suppliers'
        #
        last_meta.should eq([200, "application/json"])
        #
        result = JSON.load(last_response.body)
        result.should be_a(Array)
        result.size.should eq(5)
      end

      it 'supports text/csv' do
        #
        header "Accept", "text/csv"
        get '/suppliers'
        #
        last_meta.should eq([200, "text/csv"])
        #
        last_response.body.should =~ /1,Smith,20,London/
      end

      it 'supports text/plain' do
        #
        header "Accept", "text/plain"
        get '/suppliers'
        #
        last_meta.should eq([200, "text/plain"])
        #
        last_response.body.should =~ /\|\s+1\s+\|\s+Smith\s+\|/
      end

      it 'supports text/x-yaml' do
        #
        header "Accept", "text/x-yaml"
        get '/suppliers'
        #
        last_meta.should eq([200, "text/x-yaml"])
        #
        last_response.body.should =~ /- :sid: 1/
      end

      it 'supports a charset specification' do
        #
        header "Accept", "application/json; charset=UTF-8"
        get '/suppliers'
        #
        last_meta.should eq([200, "application/json"])
        #
        result = JSON.load(last_response.body)
        result.should be_a(Array)
        result.size.should eq(5)
      end

    end
  end
end
