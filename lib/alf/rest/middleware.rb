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
      rescue => ex
        if error_app = (cfg && cfg.error_app)
          env[Rest::RACK_ERROR_KEY] = ex
          error_app.call(env)
        else
          raise
        end
      end

    end # class Middleware
  end # module Rest
end # module Alf
