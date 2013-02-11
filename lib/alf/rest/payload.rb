require_relative 'payload/client'
require_relative 'payload/input'
module Alf
  module Rest
    class Payload

      def initialize(raw)
        @raw = raw
      end
      attr_reader :raw

      def to_tuple(heading = nil)
        to_relation(heading).tuple_extract
      end

      def to_rack_response(env, status = 200)
        accept = env['HTTP_ACCEPT'] || 'application/json'
        if renderer = Alf::Renderer.from_http_accept(accept)
          [ status,
            {'Content-Type' => renderer.mime_type},
            renderer.new(raw).each ]
        else
          raise Rack::Accept::Context::AcceptError, accept
        end
      end

    end # class Payload
  end # module Rest
end # module Alf