module Alf
  module Rest
    class Payload
      module Client

        def payload
          JSON::load(last_response.body)
        end

        def to_payload(h)
          case c = headers["Content-Type"]
          when /urlencoded/ then URI.escape(h.map{|k,v| "#{k}=#{v}"}.join('&'))
          when /json/       then ::JSON.dump(body)
          else
            raise "Unable to generate payload for Content-Type `#{c}`"
          end
        end

      end # module Client
    end # class Payload
  end # module Rest
end # module Alf
