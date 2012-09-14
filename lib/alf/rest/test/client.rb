module Alf
  module Rest
    module Test
      class Client
        include ::Rack::Test::Methods
        include Agent::DatabaseMethods

        def initialize(app)
          @app = app
          @global_headers = {}
          @global_parameters = {}
          reset
        end
        attr_reader :app
        attr_accessor :global_parameters
        attr_accessor :global_headers
        attr_accessor :json_body
        attr_accessor :parameters

        def reset
          self.json_body  = nil
          self.parameters = {}
          global_headers.each{|k,v| header(k,v)}
        end

        def with_relvar(*args, &bl)
          with_database do |db|
            yield(db.relvar(*args))
          end
        end

        def loaded_body
          JSON::load(last_response.body)
        end

        def global_header(k, v)
          global_headers[k] = v
        end

        def parameter(k, v)
          parameters[k] = v
        end

        [:get, :patch, :put, :post, :delete].each do |m|
          define_method(m) do |url, &bl|
            url ||= ""
            url += (url =~ /\?/ ? "&" : "?")
            url += hash2uri(global_parameters.merge(parameters))
            args = [url]
            args << JSON.dump(json_body) if json_body
            result = super(*args, &bl)
            reset
            result
          end
        end

      private

        def hash2uri(h)
          URI.escape(h.map{|k,v| "#{k}=#{v}"}.join('&'))
        end

      end # class Client
    end # module Test
  end # module Rest
end # module Alf