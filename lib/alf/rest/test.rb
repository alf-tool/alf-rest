require 'alf-rest'
module Alf
  module Rest
    module Test

      def self.config
        @config ||= Config.new.tap{|c|
          yield(c) if block_given?
        }
      end

    end # module Test
  end # module Rest
end # module Alf
require_relative 'test/ext'
require_relative 'test/client'
