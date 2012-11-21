require 'spec_helper'
module Alf
  module Rest
    class Payload
      describe Input, "to_relation" do

        let(:tuples) { [{name: "Smith"}, {name: 'Jones'}] }
        let(:payload){ json_input_payload(tuples) }

        subject{ payload.to_relation }

        it 'gets the expected relation' do
          subject.should eq(Relation(tuples))
        end

      end
    end
  end
end