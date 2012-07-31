module Alf
  module Rest
    class RouteSpec
      class Patch < RouteSpec

        def install_relation(app, spec = self)
        end

        def install_tuple(app, spec = self)
          app.patch(url(:tuple)) do
            spec.normalize_params!(params)

            with_relvar(params[:relvar], params[:id]) do |rv|
              attrs = JSON.parse(request.body.read) rescue halt(400)
              rv.update(attrs) if rv.tuple_extract
              serve rv.tuple_extract
            end
          end
        end

      end # class Patch
    end # class RouteSpec
  end # module Rest
end # module Alf
