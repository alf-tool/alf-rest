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
        mime_type = env['HTTP_ACCEPT'] || 'application/json'
        [ status, {'Content-Type' => mime_type}, dump(env, mime_type) ]
      end

    private

      def dump(env, mime_type)
        if RelationLike===raw
          Alf::Renderer.by_mime_type(mime_type, raw).each
        else
          case env['HTTP_ACCEPT']
          when NilClass, /json/ then [ raw.to_json ]
          when /yaml/           then [ raw.to_yaml ]
          when /text\/plain/    then [ raw.to_s    ]
          else
            raise UnsupportedMimeTypeError, "Unsupported MIME type `#{mime_type}`"
          end
        end
      end

    end # class Payload
  end # module Rest
end # module Alf