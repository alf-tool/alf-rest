require 'spec_helper'
module Alf
  module Rest
    class Payload
      describe Input, "to_tuple" do

        let(:tuple)  { {hello: "world"} }
        let(:payload){ json_input_payload(tuple) }

        subject{ payload.to_tuple }

        it 'gets the expected tuple' do
          subject.should eq(Tuple(tuple))
        end

      end
    end
  end
end