require 'alf-rest'
module Sinatra
  module AlfRest

    def rest_get(url, &bl)
      get(url) do
        payload = instance_exec(&bl)
        send_payload payload
      end
    end

    def rest_post(url, heading, &bl)
      post(url) do
        payload = Alf::Rest::Payload::Input.new(request)
        body    = payload.to_tuple(Alf::Heading.coerce(heading))
        ids     = instance_exec(body, &bl)
        ids     = ids.tuple_extract if Relation===ids
        ids     = ids.to_hash.values
        status 201
        headers("Location" => "#{url}/#{ids.join(',')}")
      end
    end

    def rest_delete(url, heading, &bl)
      delete(url) do
        body = Tuple[heading].coerce(params.select{|k| heading[k.to_sym]})
        instance_exec(body, &bl)
        status 204
        headers("Location" => request.path)
      end
    end

    def rest_put(url, heading, &bl)
      put(url) do
        payload = Alf::Rest::Payload::Input.new(request)
        body    = payload.to_tuple(Alf::Heading.coerce(heading))
        instance_exec(body, &bl)
        status 200
        headers("Location" => request.path)
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