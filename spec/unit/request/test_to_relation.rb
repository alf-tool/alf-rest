require 'spec_helper'
module Alf
  module Rest
    describe Request, "to_relation" do

      let(:request){ Alf::Rest::Request.new(env, heading) }

      let(:heading){ {status: Integer, city: String} }

      subject{ request.to_relation }

      context 'with application/x-www-form-urlencoded' do
        let(:env)  { env_for("/foo", method: 'POST', params: tuple) }
        let(:tuple){ {city: "London", status: "200"} }

        it 'gets the iterated tuples from POST' do
          subject.should eq(Relation(city: "London", status: 200))
        end
      end

      context 'with a body conforming to Rack spec strictly' do
        let(:env)  { json_post_env(tuple) }
        let(:tuple){ {city: "London", status: "200"} }

        before do
          env['rack.input'] = Struct.new(:read, :rewind).new(env['rack.input'].read)
        end

        it 'gets the iterated tuples from POST' do
          subject.should eq(Relation(city: "London", status: 200))
        end
      end

      context 'with a JSON encoded body' do
        let(:env){ json_post_env(tuples) }

        context 'when the input matches exactly' do
          let(:tuples){ [{city: "London", status: "200"}] }

          it 'gets the expected relation' do
            subject.should eq(Relation(status: 200, city: "London"))
          end
        end

        context 'when a projection is needed' do
          let(:tuples){ [{name: "Smith", status: "200"}] }

          it 'gets the expected relation' do
            subject.should eq(Relation(status: 200))
          end
        end
      end

    end
  end
end