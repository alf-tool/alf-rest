module Alf
  module Rest
    module Helpers
      include Payload::Server

      def alf_config
        env[Rest::RACK_CONFIG_KEY]
      end

      def alf_agent
        @alf_agent ||= Agent.new(self, alf_config)
      end
      alias_method :agent, :alf_agent

    end
  end
end