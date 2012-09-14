module Alf
  module Rest
    module Payload

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
            h.respond_to?(:to_text) ? h.to_text : h.to_s
          else
            content_type :json
            JSON.dump(h)
          end
        end

      end # module Server

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

    end # module PayloadUtils
  end # module Rest
end # module Alf