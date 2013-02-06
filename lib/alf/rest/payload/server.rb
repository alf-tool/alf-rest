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

      end # module Server
    end # class Payload
  end # module Rest
end # module Alf
