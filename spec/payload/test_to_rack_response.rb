require 'spec_helper'
module Alf
  module Rest
    describe Payload, "to_rack_response" do

      let(:payload){ Payload.new(raw) }

      subject{ payload.to_rack_response(env) }

      def status
        subject[0]
      end

      def content_type
        subject[1]['Content-Type']
      end

      def body
        subject[2]
      end

      context 'when the payload is an error message' do
        let(:raw){ {error: "an error message"} }

        context 'when the content-type is specified' do
          let(:env){ {'HTTP_ACCEPT' => "application/json"} }

          it 'should be the expected JSON-based response' do
            status.should eq(200)
            content_type.should eq('application/json')
            body.should eq([raw.to_json])
          end
        end

        context 'when the content-type is specified as text/plain' do
          let(:env){ {'HTTP_ACCEPT' => "text/plain"} }

          it 'should be the expected plain-text response' do
            status.should eq(200)
            content_type.should eq('text/plain')
            body.should eq([raw.to_s])
          end
        end

        context 'when the content-type is not specified' do
          let(:env){ {} }

          it 'should be the expected JSON-based response' do
            status.should eq(200)
            content_type.should eq('application/json')
            body.should eq([raw.to_json])
          end
        end

        context 'when the content-type is not supported' do
          let(:env){ {'HTTP_ACCEPT' => "not/a-content-type"} }

          it 'should raise an exeption' do
            lambda{
              subject
            }.should raise_error(Alf::UnsupportedMimeTypeError)
          end
        end
      end

      context 'when the payload is relation' do
        let(:raw){ Relation.coerce(id: [12, 13]) }

        context 'when the content-type is specified' do
          let(:env){ {'HTTP_ACCEPT' => "application/json"} }

          it 'should be the expected JSON-based response' do
            status.should eq(200)
            content_type.should eq('application/json')
            body.to_a.join.strip.should eq([{id: 12}, {id: 13}].to_json)
          end
        end


        context 'when the content-type is specified as text/csv' do
          let(:env){ {'HTTP_ACCEPT' => "text/csv"} }

          it 'should be the expected CSV response' do
            status.should eq(200)
            content_type.should eq('text/csv')
            body.to_a.join.strip.should eq("id\n12\n13")
          end
        end
      end

    end # class Payload
  end # module Rest
end # module Alf