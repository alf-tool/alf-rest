module Rack
  module Test
    class Session
      attr_reader :headers
    end
  end
end

module Alf
  module Rest
    module Test
      class Client
        include ::Rack::Test::Methods
        include Payload::Client

        def initialize(database)
          @database = database
          @db_conn  = database.connection
          @global_headers = { "Content-Type" => "application/json" }
          @global_parameters = { }
          reset
        end
        attr_reader :database, :db_conn
        attr_accessor :global_parameters
        attr_accessor :global_headers
        attr_accessor :body
        attr_accessor :parameters

        def reset
          self.body       = nil
          self.parameters = {}
          global_headers.each{|k,v| header(k,v) }
        end

        def disconnect
          db_conn.close if db_conn
        end

        def with_database
          yield(database)
        end

        def with_db_conn(&bl)
          yield(db_conn)
        end

        def with_relvar(*args, &bl)
          with_db_conn do |db_conn|
            yield(db_conn.relvar(*args))
          end
        end

        def headers
          current_session.headers
        end

        def global_header(k, v)
          global_headers[k] = v
        end

        def parameter(k, v)
          parameters[k] = v
        end

        [:get, :patch, :put, :post, :delete].each do |m|
          define_method(m) do |url, &bl|
            # build the url
            url ||= ""
            url += (url =~ /\?/ ? "&" : "?")
            url += hash2uri(global_parameters.merge(parameters))
            args = [url]

            # encode and set the body
            args << to_payload(body)

            # make the call
            super(*args, &bl).tap{ reset }
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
