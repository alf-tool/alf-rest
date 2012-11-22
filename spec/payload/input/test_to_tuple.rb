require 'spec_helper'
module Alf
  module Rest
    class Payload
      describe Input, "to_tuple" do

        let(:payload){ json_input_payload(tuple) }

        context 'without heading' do
          let(:tuple){ {hello: "world"} }

          subject{ payload.to_tuple }

          it 'gets the expected tuple' do
            subject.should eq(Tuple(tuple))
          end
        end

        context 'with a heading' do
          let(:tuple){ {status: "200"} }

          subject{ payload.to_tuple(Heading[status: Integer]) }

          it 'gets the expected tuple' do
            subject.should eq(Tuple(status: 200))
          end
        end

      end
    end
  end
end