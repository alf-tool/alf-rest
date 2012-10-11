require_relative 'agent/request_methods'
require_relative 'agent/service_methods'
module Alf
  module Rest
    class Agent
      include RequestMethods
      include ServiceMethods

      def initialize(app, config)
        @app = app
        @config = config
      end
      attr_reader :app, :config

      def db_conn
        config.connection
      end

      def reconnect(opts)
        config.reconnect(opts)
      end

    end # class Agent
  end # module Rest
end # module Alf
