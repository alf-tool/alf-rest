module Alf
  module Rest
    class MappingError < Alf::Error; end
    class KeyMismatch  < Alf::Error; end
  end
  class Error
    attr_accessor :http_status
  end
end
