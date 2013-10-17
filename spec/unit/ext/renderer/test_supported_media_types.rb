require 'spec_helper'
module Alf
  describe Renderer, "supported_media_types" do

    subject{ Renderer.supported_media_types.sort }

    it{ should eq(["application/json", "text/csv", "text/plain", "text/yaml"]) }

  end
end