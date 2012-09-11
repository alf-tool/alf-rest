module Alf
  module Rest
    module Test
      class Client
        include ::Rack::Test::Methods

        def initialize(app)
          @app = app
        end
        attr_reader :app

        def settings
          app.settings
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

        def with_db(&bl)
          app.settings.database.connect(app.settings.adapter, &bl)
        end

        def with_relvar(*args, &bl)
          with_db do |db|
            yield(db.relvar(*args))
          end
        end

        [:get, :patch, :put, :post, :delete].each do |m|
          define_method(m) do |*args, &bl|
            args << JSON.dump(@body) if @body
            super(*args, &bl)
          end
        end

      end # class Client
    end # module Test
  end # module Rest
end # module Alf