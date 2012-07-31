module Alf
  module Rest
    class RouteSpec
      class Delete < RouteSpec

        def install_relation(app, spec = self)
          app.delete(url(:relation)) do
            spec.normalize_params!(params)

            with_relvar(params[:relvar]) do |rv|
              rv.delete
            end
            204
          end
        end

        def install_tuple(app, spec = self)
          app.delete(url(:tuple)) do
            spec.normalize_params!(params)

            with_relvar(params[:relvar], params[:id]) do |rv|
              rv.delete if rv.tuple_extract
            end
            204
          end
        end

      end # class Delete
    end # class RouteSpec
  end # module Rest
end # module Alf
