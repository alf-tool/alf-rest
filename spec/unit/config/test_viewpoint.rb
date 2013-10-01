require 'spec_helper'
module Alf
  module Rest
    describe Config, "viewpoint=" do

      let(:config){ Config.new }

      subject{ config.viewpoint = Alf::Viewpoint::NATIVE }

      it 'sets it on the connection options' do
        subject
        config.connection_options[:viewpoint].should be(Alf::Viewpoint::NATIVE)
        config.viewpoint.should be(Alf::Viewpoint::NATIVE)
      end

    end
  end
end
