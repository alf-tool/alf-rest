module Alf
  module Rest
    class Response < Rack::Response

      def initialize(env = {})
        accept = env['HTTP_ACCEPT'] || 'application/json'
        if @renderer = Alf::Renderer.from_http_accept(accept)
          super()
          self['Content-Type'] = @renderer.mime_type
        else
          raise Rack::Accept::Context::AcceptError, accept
        end
      end

      def body=(payload)
        super(@renderer.new(payload))
      end

    end # class Response
  end # module Rest
end # module Alf
