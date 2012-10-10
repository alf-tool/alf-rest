require 'spec_helper'
module Alf
  module Rest
    describe Config, "error_app=" do

      let(:config){ Config.new }

      subject{ config.error_app = ->(env){ @seen = env } }

      it 'sets the error app' do
        subject
        config.error_app.call("blah")
        @seen.should eq("blah")
      end

      it 'is correctly dupped' do
        subject
        config.dup.error_app.call("blah")
        @seen.should eq("blah")
      end

    end
  end
end