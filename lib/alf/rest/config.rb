module Alf
  module Rest
    class Config < Support::Config

      # The database instance to use for obtaining connections
      option :database, Database, nil

      # The connection options to use
      option :connection_options, Hash, {}

      # The agent class to use for RESTful operations
      option :agent_class, Class, Rest::Agent

      # The error app to use when exception are catched
      option :error_app, Object, Rest::ErrorApp

      # Enclose all requests in a single database transaction
      option :transactional, Boolean, true

      # The logger instance to use for agent-related stuff
      option :logger, Object, Logger.new(STDOUT)

      # The current database connection
      attr_reader :connection

      # Yields the block with the database connection
      def connect(&bl)
        return yield unless database
        database.connect(connection_options) do |conn|
          @connection = conn
          if transactional?
            conn.in_transaction{ yield(conn) }
          else
            yield(conn)
          end
        end
      end

    end # class Config
  end # module Rest
end # module Alf
