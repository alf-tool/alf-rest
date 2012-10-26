require_relative 'payload/server'
require_relative 'payload/client'
require_relative 'payload/input'
module Alf
  module Rest
    class Payload

      def initialize(raw)
        @raw = raw
      end
      attr_reader :raw

      def to_tuple
        to_relation.tuple_extract
      end

    end # class Payload
  end # module Rest
end # module Alf