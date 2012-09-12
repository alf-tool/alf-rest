require 'sinatra/base'
module Alf
  module Rest
    class Base < Sinatra::Base

      set :database, ::Alf::Schema.native

      def db
        @database ||= settings.database.connect(settings.adapter)
      end

      def agent
        @agent ||= Agent.new(self)
      end

      # Disconnect the database connection at end
      after{ @database.disconnect if @database }

      error Alf::NoSuchRelvarError,
            Alf::NoSuchTupleError,
            Sinatra::NotFound do
        not_found
      end

      error StandardError do |ex|
        puts ex.message
        puts ex.backtrace.join("\n")
        if defined?(::Sequel) && ex.is_a?(::Sequel::DatabaseError)
          status 400
        else
          status 500
        end
        content_type "text/plain"
        body ex.message
      end

    end # class Base
  end # module Rest
end # module Alf