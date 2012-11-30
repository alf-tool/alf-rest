require 'spec_helper'
module Alf
  module Rest
    describe Config, "viewpoint=" do

      let(:config){ Config.new }

      subject{ config.viewpoint = :vp }

      it 'sets it on the connection options' do
        subject
        config.connection_options[:default_viewpoint].should eq(:vp)
        config.viewpoint.should eq(:vp)
      end

    end
  end
end
