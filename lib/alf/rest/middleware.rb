module Alf
  module Rest
    class Middleware

      def initialize(app, config)
        @app    = app
        @config = config
      end

      def call(env)
        env[Rest::RACK_CONFIG_KEY] = cfg = @config.dup
        cfg.connect do
          @app.call(env)
        end
      end

    end # class Middleware
  end # module Rest
end # module Alf
