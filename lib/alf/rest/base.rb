require 'sinatra/base'
module Alf
  module Rest
    class Base < Sinatra::Base
      include DatabaseMethods

      def self.relvar(url = nil, options = {})
        url, options = nil, url if url.is_a?(Hash)

        options[:url]  ||= url
        options[:mode] ||= [:relation, :tuple]
        options[:verb] ||= [:get, :post, :delete, :patch, :put]

        Array(options[:verb]).each do |verb|
          Array(options[:mode]).each do |mode|
            singular = options.merge(:mode => mode, :verb => verb)
            RouteSpec.send(verb, singular).install(self)
          end
        end
      end

      def serve(data)
        content_type :json
        data.to_json
      end

      error Alf::NoSuchRelvarError,
            Alf::NoSuchTupleError do
        not_found
      end

      error StandardError do |ex|
        if defined?(::Sequel) && ex.is_a?(::Sequel::DatabaseError)
          status 400
        else
          status 500
        end
        content_type "text/plain"
        body ex.message
      end

    end # class Base
  end # module Rest
end # module Alf