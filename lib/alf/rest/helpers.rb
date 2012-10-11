module Alf
  module Rest
    module Helpers
      extend Forwardable
      include Payload::Server

      def alf_config
        env[Rest::RACK_CONFIG_KEY]
      end

      def alf_agent
        @alf_agent ||= alf_config.agent_class.new(self, alf_config)
      end
      alias_method :agent, :alf_agent

      def db_conn
        alf_config.connection
      end

      def with_db_conn
        yield(db_conn)
      end

      def_delegators :db_conn, :relvar,
                               :query,
                               :tuple_extract,
                               :assert!,
                               :fact!,
                               :deny!

    end
  end
end
