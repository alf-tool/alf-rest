module Alf
  module Rest
    class RouteSpec
      class Get < RouteSpec

        def install_relation(app, spec = self)
          app.get(url(:relation)) do
            spec.normalize_params!(params)

            with_relvar(params[:relvar]) do |rv|
              serve rv
            end
          end
        end

        def install_tuple(app, spec = self)
          app.get(url(:tuple)) do
            spec.normalize_params!(params)

            with_relvar(params[:relvar], params[:id]) do |rv|
              serve rv.tuple_extract
            end
          end
        end

      end # class Get
    end # class RouteSpec
  end # module Rest
end # module Alf
