require 'spec_helper'
module Alf
  module Rest
    class Payload
      describe Input, "content_type" do

        let(:payload){ Input.new(raw) }

        subject{ payload.send(:content_type) }

        context 'on a Rack::Request' do
          let(:raw){ Rack::Request.new('CONTENT_TYPE' => 'application/json') }

          it{ should eq("application/json") }
        end

        context 'on a Rack::Response' do
          let(:raw){ Rack::Response.new([], 200, 'Content-Type' => 'application/json') }

          it{ should eq("application/json") }
        end

      end
    end
  end
end