require_relative 'agent/request_methods'
require_relative 'agent/service_methods'
require_relative 'agent/database_methods'
module Alf
  module Rest
    class Agent
      include RequestMethods
      include ServiceMethods
      include DatabaseMethods

      def initialize(app, env = {})
        @app = app
        @env = env
      end
      attr_reader :app
      attr_reader :env

      def settings
        app.settings
      end

    end # class Agent
  end # module Rest
end # module Alf