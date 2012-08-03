require_relative 'rest/version'
require_relative 'rest/loader'
module Alf
  module Rest

    class MappingError < Alf::Error; end
    class KeyMismatch  < Alf::Error; end

  end
end
require_relative 'rest/agent'
require_relative 'rest/base'
