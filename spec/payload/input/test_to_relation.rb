require 'spec_helper'
module Alf
  module Rest
    class Payload
      describe Input, "to_relation" do

        let(:payload){ json_input_payload(tuples) }

        context 'without heading' do
          let(:tuples) { [{name: "Smith"}, {name: 'Jones'}] }

          subject{ payload.to_relation }

          it 'gets the expected relation' do
            subject.should eq(Relation(tuples))
          end
        end

        context 'with a heading' do
          let(:tuples){ [{name: "Smith", status: "200"}] }
          let(:heading){ Heading[status: Integer] }

          subject{ payload.to_relation(heading) }

          it 'gets the expected relation' do
            subject.should eq(Relation(status: 200))
          end
        end

      end
    end
  end
end