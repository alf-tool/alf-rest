require_relative 'agent/database_methods'
require_relative 'agent/request_methods'
require_relative 'agent/service_methods'

module Alf
  module Rest
    class Agent
      include DatabaseMethods
      include RequestMethods
      include ServiceMethods

      # Sinatra application
      attr_reader :app

      # Creates an agent instance
      def initialize(app)
        @app = app
      end

      def settings
        app.settings
      end

      def request
        app.request
      end

    end # class Agent
  end # module Rest
end # module Alf