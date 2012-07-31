require_relative 'route_spec/factory'
module Alf
  module Rest
    class RouteSpec
      extend Factory

      def initialize(options)
        @options = options
      end
      attr_reader :options

      def url(mode)
        url = options[:url] || "/#{options[:relvar]}"
        url = "#{url}/:id" if mode == :tuple
        url
      end

      def mode
        options[:mode]
      end

      def relvar_known?
        options.has_key?(:relvar)
      end

      def relvar_name
        options[:relvar]
      end

      def install(app)
        send(:"install_#{mode}", app)
      end

      def normalize_params!(params)
        params[:relvar] = relvar_name if relvar_known?
      end

      require_relative 'route_spec/get'
      require_relative 'route_spec/post'
      require_relative 'route_spec/delete'
      require_relative 'route_spec/patch'
      require_relative 'route_spec/put'
    end # class RouteSpec
  end # module Rest
end # module Alf
