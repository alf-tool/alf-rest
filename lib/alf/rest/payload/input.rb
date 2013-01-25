module Alf
  module Rest
    class Payload
      class Input < Payload

        def to_relation(heading = nil)
          rel = Relation.coerce(each)
          if heading
            commons = heading.to_attr_list & rel.heading.to_attr_list
            rel = rel.project(commons).coerce(heading.project(commons))
          end
          rel
        end

      private

        def each(&bl)
          return to_enum unless block_given?
          ct = content_type
          if Rack::Request::FORM_DATA_MEDIA_TYPES.include?(ct) && raw.respond_to?(:POST)
            yield(Support.symbolize_keys(raw.POST))
          else
            Alf::Reader.by_mime_type(ct, body_io).each(&bl)
          end
        end

        def content_type
          raw.content_type
        end

        def body_io
          @body_io ||= case io = raw.body
                       when String           then StringIO.new(io)
                       when Array            then StringIO.new(io.join)
                       else
                         StringIO.new(io.read)
                       end
        end

      end # class Input
    end # class Payload
  end # module Rest
end # module Alf