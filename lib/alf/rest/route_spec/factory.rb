module Alf
  module Rest
    class RouteSpec
      module Factory

        def get(options)
          RouteSpec::Get.new(options)
        end

        def delete(options)
          RouteSpec::Delete.new(options)
        end

        def post(options)
          RouteSpec::Post.new(options)
        end

        def patch(options)
          RouteSpec::Patch.new(options)
        end

        def put(options)
          RouteSpec::Put.new(options)
        end

      end # module Factory
    end # class RouteSpec
  end # module Rest
end # module Alf
