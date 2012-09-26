require 'sinatra/base'
module Alf
  module Rest
    class Base < Sinatra::Base
      include Payload::Server

      configure do
        set :database, Alf::Schema.native
        set :agent,    Alf::Rest::Agent
        set :logger,   nil
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

      def error_occured(ex)
        if settings.environment.to_s =~ /^devel|test/
          msg    = "#{ex.message} (#{ex.class})"
          to_log = %Q{#{msg}\n#{ex.backtrace.join("\n")}}
        else
          msg    = nil
          to_log = "#{ex.message} (#{ex.class})"
        end
        settings.logger.info("catched error: #{to_log}") if settings.logger
        msg
      end

      not_found do
        status 404
        send_payload(:error => "not found")
      end

      error Sinatra::NotFound do |ex|
        not_found
      end

      error Alf::NoSuchRelvarError,
            Alf::NoSuchTupleError do |ex|
        status 404
        send_payload(:error => error_occured(ex) || "not found")
      end

      error Alf::FactAssertionError do |ex|
        halt 403
        send_payload(:error => error_occured(ex) || "forbidden")
      end

      error Alf::CoercionError do |ex|
        status 400
        send_payload(:error => error_occured(ex) || "coercion error")
      end

      error StandardError do |ex|
        if defined?(::Sequel) && ex.is_a?(::Sequel::DatabaseError)
          status 400
        else
          status 500
        end
        send_payload(:error => error_occured(ex) || "an error occured")
      end

    end # class Base
  end # module Rest
end # module Alf