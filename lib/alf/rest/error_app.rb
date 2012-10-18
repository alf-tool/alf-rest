module Alf
  module Rest
    class ErrorApp < Sinatra::Base
      include Helpers

      disable :dump_errors
      disable :logging
      disable :dump_errors
      disable :raise_errors
      disable :show_exceptions

      after do
        case ex = env[Rest::RACK_ERROR_KEY]
        when Sinatra::NotFound
          handle_error(404, "not found")
        when Alf::NoSuchRelvarError
          handle_error(ex.http_status || 404, "relvar not found")
        when Alf::NoSuchTupleError
          handle_error(ex.http_status || 404, "tuple not found")
        when Alf::FactAssertionError
          handle_error(ex.http_status || 403, "forbidden")
        when Alf::CoercionError
          handle_error(ex.http_status || 400, "coercion error")
        when JSON::ParserError
          handle_error(400, "invalid json body")
        when ->(ex){ defined?(::Sequel) && ex.is_a?(::Sequel::DatabaseError) }
          handle_error(400, "a database error occured")
        else
          handle_error(500, "an error occured")
        end
      end

    private

      def log_error(status, message, ex = env[Rest::RACK_ERROR_KEY])
        msg_and_class = "#{ex.message} (#{ex.class})"
        backtrace     = (ex.backtrace || []).join("\n")

        message = msg_and_class unless settings.production?

        gravity   = :error if status >= 500
        gravity ||= :warn  if status != 404
        gravity ||= :info

        to_log    = %Q{#{msg_and_class}\n#{backtrace}} if status >= 500
        to_log  ||= %Q{#{msg_and_class}\n#{backtrace}} unless settings.production?
        to_log  ||= msg_and_class

        alf_config.logger.send(gravity, to_log) if alf_config.logger
        message
      rescue => ex
        message
      end

      def handle_error(status, message)
        halt(status, send_payload(error: log_error(status, message)))
      end

    end # class ErrorApp
  end # module Rest
end # module Alf
