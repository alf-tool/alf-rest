module Alf
  module Rest
    class Payload
      module Server

        def payload
          case env['CONTENT_TYPE']
          when /json/ then ::JSON.parse(request.body.read)
          else
            params
          end
        end

        def send_payload(h)
          case c = env['HTTP_ACCEPT']
          when /json/
            content_type :json
            JSON.dump(h)
          when /text\/plain/
            content_type "text/plain"
            case h
            when ->(x){ x.respond_to?(:to_text) } then h.to_text
            when Hash, Tuple                      then Relation.coerce(h).to_text
            else                                  h.to_s
            end
          else
            content_type :json
            JSON.dump(h)
          end
        end

      end # module Server
    end # class Payload
  end # module Rest
end # module Alf
