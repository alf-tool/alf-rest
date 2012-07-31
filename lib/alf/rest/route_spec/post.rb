module Alf
  module Rest
    class RouteSpec
      class Post < RouteSpec

        def install_relation(app, spec = self)
          app.post(url(:relation)) do
            spec.normalize_params!(params)

            with_relvar(params[:relvar]) do |rv|
              tuples  = JSON.parse(request.body.read) rescue halt(400)
              ids     = rv.insert(tuples)
              created = rv.restrict(predicate_for(ids))
              created = created.tuple_extract if tuples.is_a?(Hash)

              status 201
              serve created
            end
          end
        end

        def install_tuple(app, spec = self)
        end

      end # class Post
    end # class RouteSpec
  end # module Rest
end # module Alf
