require_relative 'rest/version'
require_relative 'rest/loader'
require_relative 'rest/errors'
module Alf
  module Rest

    # there are circular dependencies due to config default values :-(
    class Agent;    end
    class ErrorApp < Sinatra::Base; end

    RACK_CONFIG_KEY = 'alf-rest-config'

    RACK_ERROR_KEY = 'alf-rest-error'

    def self.new(app, config = Config.new)
      yield(config) if block_given?
      Middleware.new(app, config)
    end

  end # module Rest
end # module Alf
require_relative 'rest/payload'
require_relative 'rest/helpers'

require_relative 'rest/config'
require_relative 'rest/middleware'
