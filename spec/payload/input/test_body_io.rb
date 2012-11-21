require 'spec_helper'
module Alf
  module Rest
    class Payload
      describe Input, "body_io" do

        let(:payload){ Input.new(raw) }

        subject{ payload.send(:body_io) }

        context 'on a Rack::Request' do
          let(:raw){ Rack::Request.new('rack.input' => StringIO.new("foo")) }

          it{ should be_a(StringIO) }
          specify{
            subject.string.should eq("foo")
          }
        end

        context 'on a Rack::Response' do
          let(:raw){ Rack::Response.new([ "foo", "bar" ]) }

          it{ should be_a(StringIO) }
          specify{
            subject.string.should eq("foobar")
          }
        end

        context 'on a Rack::MockResponse' do
          let(:raw){ Rack::Response.new([ "foo", "bar" ]) }

          it{ should be_a(StringIO) }
          specify{
            subject.string.should eq("foobar")
          }
        end

      end
    end
  end
end