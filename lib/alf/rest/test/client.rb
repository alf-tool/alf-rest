module Alf
  module Rest
    module Test
      class Client
        include ::Rack::Test::Methods
        include Agent::DatabaseMethods

        def initialize(app)
          @app = app
        end
        attr_reader :app

        def with_relvar(*args, &bl)
          with_database do |db|
            yield(db.relvar(*args))
          end
        end

        def json_body
          @body
        end

        def json_body=(body)
          @body = body
        end

        def loaded_body
          JSON::load(last_response.body)
        end

        def default_parameters(h)
          @default_parameters = h
        end

        [:get, :patch, :put, :post, :delete].each do |m|
          define_method(m) do |url, &bl|
            url ||= ""
            url += (url =~ /\?/ ? "&" : "?")
            url += URI.escape(@default_parameters.map{|k,v| "#{k}=#{v}"}.join('&')) if @default_parameters
            args = [url]
            args << JSON.dump(@body) if @body
            super(*args, &bl)
          end
        end

      end # class Client
    end # module Test
  end # module Rest
end # module Alf