require 'alf-rest'
module Sinatra
  module AlfRest

    def rest_get(url, &bl)
      get(url) do
        Alf::Rest::Response.new(env){|r|
          r.body = instance_exec(&bl)
        }.finish
      end
    end

    def rest_post(url, heading, &bl)
      post(url) do
        input   = Alf::Rest::Request.new(env, heading).to_tuple
        result  = instance_exec(input, &bl)

        Alf::Rest::Response.new(env){|r|
          r.status = result.rack_status
          r.body   = result.rack_body
          if not(location_set?) and (loc = result.rack_location(request))
            r["Location"] = loc
          end
        }.finish
      end
    end

    def rest_put(url, heading, &bl)
      put(url) do
        input   = Alf::Rest::Request.new(env, heading).to_tuple
        result  = instance_exec(input, &bl)

        Alf::Rest::Response.new(env){|r|
          r.status = result.rack_status
          r.body   = result.rack_body
          r["Location"] = request.path unless location_set?
        }.finish
      end
    end

    def rest_delete(url, heading, &bl)
      delete(url) do
        input  = Tuple[heading].coerce(params.select{|k| heading[k.to_sym]})
        result = instance_exec(input, &bl)

        Alf::Rest::Response.new(env){|r|
          r.status = result.rack_status
          r.body   = result.rack_body
          if not(location_set?) and (loc = result.rack_location(request))
            r["Location"] = loc
          end
        }.finish
      end
    end

    def alf_rest
      if block_given?
        yield(settings.alf_configuration)
      else
        settings.alf_configuration
      end
    end

    def self.registered(app)
      config = Alf::Rest::Config.new
      app.set :alf_configuration, config
      app.use Alf::Rest::Middleware, config
      app.helpers Alf::Rest::Helpers
    end

  end
  register AlfRest
end
