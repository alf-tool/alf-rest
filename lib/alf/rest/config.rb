module Alf
  module Rest
    class Config < Support::Config

      # The database instance to use for obtaining connections
      option :database, Database, nil

      # The connection options to use
      option :connection_options, Hash, {}

      # Enclose all requests in a single database transaction
      option :transactional, Boolean, true

      # The logger instance to use for logging
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

      # Reconnect
      def reconnect(opts)
        connection.reconnect(opts)
      end

      # Sets the database, coercing it if required
      def database=(db)
        @database = db.is_a?(Database) ? db : Alf.database(db)
      end

      # Returns the default viewpoint to use
      def viewpoint
        connection_options[:viewpoint]
      end

      # Sets the default viewpoint on connection options
      def viewpoint=(vp)
        connection_options[:viewpoint] = vp
      end

    end # class Config
  end # module Rest
end # module Alf
