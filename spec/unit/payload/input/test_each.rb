require 'spec_helper'
module Alf
  module Rest
    class Payload
      describe Input, "each" do

        before(:all) do
          class Input; public :each; end
        end

        let(:tuple)  { {hello: "world"} }
        let(:payload){ Input.new(raw)   }

        context 'without block' do
          let(:raw){ [] }
          subject{ payload.each }

          it{ should be_a(Enumerator) }
        end

        context 'on a Rack::Request' do
          let(:raw){ Rack::Request.new(env) }

          subject{ payload.each.to_a }

          context 'with application/x-www-form-urlencoded' do
            let(:env){ env_for("/foo", method: 'POST', params: tuple) }

            it 'gets the iterated tuples from POST' do
              subject.should eq([tuple])
            end
          end

          context 'with application/json and a single tuple' do
            let(:env){ json_post_env(tuple) }

            it 'gets the iterated tuples from a JSON reader' do
              subject.should eq([tuple])
            end
          end

          context 'with application/json and multiple tuples' do
            let(:tuples){ [tuple, tuple] }
            let(:env){ json_post_env(tuples) }

            it 'gets the iterated tuples from a JSON reader' do
              subject.should eq([tuple, tuple])
            end
          end
        end

        context 'on a Rack::Response' do
          let(:raw){ Rack::Response.new([ '{"hello":', '"world"}' ], 200, 'Content-Type' => 'application/json') }

          subject{ payload.each.to_a }

          it 'gets the iterated tuples from a JSON reader' do
            subject.should eq([tuple])
          end
        end
      end
    end
  end
end