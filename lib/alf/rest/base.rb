require 'sinatra/base'
module Alf
  module Rest
    class Base < Sinatra::Base
      include Payload::Server

      configure do
        set :database, Alf::Schema.native
        set :agent,    Alf::Rest::Agent
      end

      before do
        env['alf-rest'] = settings.agent.new(self, env)
      end

      after do
        env['alf-rest'].disconnect
      end

      def agent
        env['alf-rest']
      end

      def database
        agent.database
      end
      alias :db :database

      not_found do
        status 404
        send_payload(:error => "not found")
      end

      error Alf::NoSuchRelvarError,
            Alf::NoSuchTupleError,
            Sinatra::NotFound do
        not_found
      end

      error Alf::FactAssertionError do
        halt 403
        send_payload(:error => "forbidden")
      end

      error Alf::CoercionError do
        status 400
        send_payload(:error => "coercion error")
      end

      error StandardError do |ex|
        if settings.environment.to_s =~ /^devel/
          puts ex.class
          puts ex.message
          puts ex.backtrace.join("\n")
        end
        if defined?(::Sequel) && ex.is_a?(::Sequel::DatabaseError)
          status 400
        else
          status 500
        end
        send_payload(:error => "an error occured")
      end

    end # class Base
  end # module Rest
end # module Alf