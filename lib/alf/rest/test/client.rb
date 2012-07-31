module Alf
  module Rest
    module Test
      class Client
        include ::Rack::Test::Methods
        include DatabaseMethods

        def initialize(app)
          @app = app
        end
        attr_reader :app

        def settings
          app.settings
        end

        def json_body=(body)
          @body = JSON.dump(body)
        end

        def loaded_body
          JSON::load(last_response.body)
        end

        [:get, :patch, :put, :post, :delete].each do |m|
          define_method(m) do |*args, &bl|
            args << @body if @body
            super(*args, &bl)
          end
        end

      end # class Client
    end # module Test
  end # module Rest
end # module Alf